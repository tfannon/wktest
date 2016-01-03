//
//  CustomCells.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/9/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import RichEditorView

@objc protocol CustomCellDelegate {
    func changed(cell : UITableViewCell)
    func getViewController() -> UIViewController
    var parent : BaseObject? { get set }
    var primaryObject : BaseObject! { get set }
    optional func beganEditing(cell : UITableViewCell)
    optional func finishedEditing(cell : UITableViewCell)

    func enableSave()
    func childSaved(child : BaseObject, showForm : Bool)
    func childCancelled(child : BaseObject)
    var savedChildIndexPath : NSIndexPath? { get set }
    var parentForm : CustomCellDelegate? { get set }
}

public class CustomCell : UITableViewCell {
    var delegate : CustomCellDelegate?
    func changed() {
        delegate?.changed(self)
    }
    func beganEditing() {
        delegate?.beganEditing?(self)
    }
    func finishedEditing() {
        delegate?.finishedEditing?(self)
    }
    func getViewController() -> UIViewController {
        return (delegate?.getViewController())!
    }
}

public class SegmentedCell : CustomCell {
    @IBOutlet var segmented : UISegmentedControl!
    @IBOutlet public var label : UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()

        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let attr : [NSObject : AnyObject] = [font : NSFontAttributeName]
        segmented.setTitleTextAttributes(attr, forState: .Normal)
        segmented.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
        selectionStyle = .None
        self.detailTextLabel?.hidden = true
        self.textLabel?.hidden
        self.label.text = ""
    }
    
    public func setOptions(options : [String]) {
        var segmentWidth : CGFloat = 0
        let entireCell = (self.label.text ?? "").isEmpty
        
        self.segmented.apportionsSegmentWidthsByContent = !entireCell
        
        segmented.removeAllSegments()
        for option in options.enumerate() {
            segmented.insertSegmentWithTitle(option.element, atIndex: option.index, animated: false)
            let s = option.element as NSString
            let attr : [String : AnyObject] = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
            let width = s.sizeWithAttributes(attr).width
            if (width > segmentWidth) {
                segmentWidth = width
            }
        }

        if (entireCell) {
            let constraint = NSLayoutConstraint(item: segmented, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .LeftMargin, multiplier: 1, constant: 0)
            contentView.addConstraint(constraint)
        }
        else
        {
            segmentWidth += 10
            for option in options.enumerate() {
                segmented.setWidth(segmentWidth, forSegmentAtIndex: option.index)
            }
        }
    }
    
    func valueChanged() {
        changed()
    }
}

public class DatePickerCell : CustomCell
{
    @IBOutlet var datePicker : UIDatePicker!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    var value : NSDate {
        get { return datePicker.date }
        set { datePicker.date = newValue }
    }
    
    func datePickerDidChange(sender: UIDatePicker) {
        changed()
    }
}

public class DatePickerNullableCell : CustomCell
{
    @IBOutlet weak var nodateView: UIView!
    @IBOutlet weak var noneLabel: UILabel!
    @IBOutlet weak var noneSelector: UISwitch!
    @IBOutlet var datePicker : UIDatePicker!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
        noneSelector.addTarget(self, action: Selector("switchDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    var value : NSDate? {
        get {
            return (noneSelector.on) ? nil : datePicker.date
        }
        set {
            if let v = newValue {
                noneSelector.on = false
                datePicker.date = v
            }
            else {
                noneSelector.on = true
                datePicker.date = NSDate()
            }
            displayChange()
        }
    }

    private func displayChange() {
        datePicker.enabled = !noneSelector.on
        datePicker.userInteractionEnabled = !noneSelector.on
        datePicker.alpha = (noneSelector.on) ? 0.5 : 1
    }
    
    func datePickerDidChange(sender: UIDatePicker) {
        changed()
    }
    func switchDidChange(sender: UISwitch) {
        displayChange()
        changed()
    }
}

public class SwitchCell: CustomCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ctrlSwitch: UISwitch!
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        ctrlSwitch.addTarget(self, action: Selector("switchDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    var value : Bool {
        get { return ctrlSwitch.on }
        set { ctrlSwitch.on = newValue }
    }
    func switchDidChange(sender: UISwitch) {
        changed()
    }
}

public class TextCellWithLabel : TextCell {
    
    @IBOutlet weak var label: UILabel!
}

public class TextCell : CustomCell, UITextFieldDelegate
{
    @IBOutlet var textField: UITextField!

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        textField.font = .preferredFontForTextStyle(UIFontTextStyleBody)
        textField.delegate = self
        textField.borderStyle = .None
        
        textField.delegate = self
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }

    func textFieldDidChange(textField: UITextField) {
        changed()
    }
    
    public func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {

            var isOk = true
            let checkNumbers =
                textField.keyboardType == UIKeyboardType.NumberPad
                || textField.keyboardType == UIKeyboardType.DecimalPad
            let allowDecimal = textField.keyboardType == UIKeyboardType.DecimalPad
            let checkRequired = checkNumbers
            
            if checkRequired {
                let nf = Application.formatterForDouble
                
                let t = ((textField.text ?? "") as NSString).stringByReplacingCharactersInRange(range, withString: string)
                if t.length > 0 {
                    if t == "-" {
                        // ok
                    } else if !allowDecimal && t.containsString(nf.decimalSeparator) {
                        isOk = false
                    } else if allowDecimal && t == "." {
                        // ok
                    } else if let _ = nf.numberFromString(t) {
                        // max integer & decimal places
                        var integerDigits = t.replace("-", withString: "")
                        if let p = t.indexOfCharacter(nf.decimalSeparator.characters.first!) {
                            integerDigits = t.substring(p - 1)
                            let s = t.substringFrom(p)
                            isOk = s.length <= (nf.maximumFractionDigits + 1) //including the '.'
                        }
                        isOk = isOk && integerDigits.length <= nf.maximumIntegerDigits
                    } else {
                        isOk = false
                    }
                }
            }
            
            return isOk
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        beganEditing()
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        finishedEditing()
    }
}

public class TextAutoSizeCell: CustomCell, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        textView.font = .preferredFontForTextStyle(UIFontTextStyleBody)
        
        // Disable scrolling inside the text view so we enlarge to fitted size
        textView.scrollEnabled = false
        textView.delegate = self
    }
    
    /// Custom setter so we can initialise the height of the text view
    var textString: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    public func textViewDidChange(textView: UITextView) {
        
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPathForCell(self) {
                tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
            }
        }
        
        changed()
    }

    public func textViewDidBeginEditing(textView: UITextView) {
        beganEditing()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        finishedEditing()
    }
}

public class HtmlCell: CustomCell, RichEditorDelegate, RichEditorToolbarDelegate {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.innerView.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()

    var colorMatrix : [[UIColor]]?

    private var editor : RichEditorView!
    private var contentHeight : CGFloat = 0
    private enum ColorPickerMode : Int {
        case None
        case Text
        case TextBackground
    }
    private var colorPickerMode = ColorPickerMode.None
    private var chosenColor : UIColor?

    private var resized = false
    private var firstSet = true

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        
        editor = RichEditorView(frame: innerView.frame)
        editor.delegate = self
        editor.inputAccessoryView = toolbar

        toolbar.delegate = self
        toolbar.editor = editor
        toolbar.options = [
            RichEditorOptions.Clear,
            RichEditorOptions.Undo,
            RichEditorOptions.Redo,
            RichEditorOptions.Bold,
            RichEditorOptions.Italic,
            RichEditorOptions.Subscript,
            RichEditorOptions.Superscript,
            RichEditorOptions.Strike,
            RichEditorOptions.Underline,
            RichEditorOptions.TextColor,
            RichEditorOptions.TextBackgroundColor,
            RichEditorOptions.Header(1),
            RichEditorOptions.Header(2),
            RichEditorOptions.Header(3),
            RichEditorOptions.Header(4),
            RichEditorOptions.Header(5),
            RichEditorOptions.Header(6),
            RichEditorOptions.Indent,
            RichEditorOptions.Outdent,
            RichEditorOptions.OrderedList,
            RichEditorOptions.UnorderedList,
            RichEditorOptions.AlignLeft,
            RichEditorOptions.AlignCenter,
            RichEditorOptions.AlignRight,
            /*RichEditorOptions.Image,*/
            /*RichEditorOptions.Link*/
        ]
        
        self.innerView.addSubview(editor)
        editor.frame.origin = CGPoint(x: 0, y: 0)
        indicator.hidden = true
        self.frame.size.height = 50
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        editor.frame = innerView.bounds
    }
    
    /// Custom setter so we can initialise the height of the text view
    var _textString : String! = ""
    var textString: String {
        get {
            let html = editor.contentHTML
            return html
        }
        set {
            // reset
            if (firstSet || _textString != newValue) {
                firstSet = false
                startWaiting()
                resized = false
                _textString = newValue
                editor.setHTML(_textString)
            }
        }
    }

    private func startWaiting() {
        if !editor.hidden {
            self.resized = false
            editor.hidden = true
            indicator.sizeToFit()
            indicator.hidden = false
            indicator.startAnimating()
        }
    }
    private func stopWaiting() {
        if (editor.hidden) {
            self.resized = true
            editor.hidden = false
            indicator.hidden = true
            indicator.stopAnimating()
        }
    }

    public var isResized : Bool {
        get {
            return self.resized 
        }
    }
    
    private func resize() {
        let currentHeight = editor.frame.size.height
        if currentHeight != contentHeight {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            if heightConstraint.constant != contentHeight {
                heightConstraint.constant = contentHeight
            }
            editor.frame.size.height = contentHeight
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        stopWaiting()
    }

    // MARK: - RichEditorDelegate
    /**
    Called when the inner height of the text being displayed changes
    Can be used to update the UI
    */
    public func richEditor(editor: RichEditorView, heightDidChange height: Int) {
        contentHeight = max(50.0, CGFloat(height))
        resize()
    }
    
    /**
     Called whenever the content inside the view changes
     */
    public func richEditor(editor: RichEditorView, contentDidChange content: String) {
        changed()
    }

    /**
     Called when the rich editor starts editing
     */
    public func richEditorTookFocus(editor: RichEditorView) {
        beganEditing()
    }
    
    /**
     Called when the rich editor stops editing or loses focus
     */
    public func richEditorLostFocus(editor: RichEditorView) {
        finishedEditing()
    }
    
    /**
     Called when the RichEditorView has become ready to receive input
     More concretely, is called when the internal UIWebView loads for the first time, and contentHTML is set
     */
    public func richEditorDidLoad(editor: RichEditorView) {
    }
    
    /**
     Called when the internal UIWebView begins loading a URL that it does not know how to respond to
     For example, if there is an external link, and then the user taps it
     */
    public func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool {
        return false
    }
    
    /**
     Called when custom actions are called by callbacks in the JS
     By default, this method is not used unless called by some custom JS that you add
     */
    public func richEditor(editor: RichEditorView, handleCustomAction action: String) {
        
    }

    // MARK: - RichEditorToolbarDelegate
    /**
    Called when the Text Color toolbar item is pressed.
    */
    public func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        showColorPicker(.Text)
        
    }
    
    /**
     Called when the Background Color toolbar item is pressed.
     */
    public func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        showColorPicker(.TextBackground)
    }
    
    /**
     Called when the Insert Image toolbar item is pressed.
     */
    public func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        
    }
    
    /**
     Called when the Isert Link toolbar item is pressed.
     */
    public func richEditorToolbarChangeInsertLink(toolbar: RichEditorToolbar) {
        
    }
    
    private let colorsInPicker = [
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.cyanColor(),
        UIColor.magentaColor(),
        UIColor.purpleColor(),
        UIColor.brownColor(),
        UIColor.grayColor()
    ]
    
    private func showColorPicker(mode : ColorPickerMode) {
        self.colorPickerMode = mode
        
        let colorPickerVC = SwiftColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.dataSource = self
        colorPickerVC.modalPresentationStyle = .Popover
        colorPickerVC.numberColorsInXDirection = colorsInPicker.count
        colorPickerVC.numberColorsInYDirection = 6
        colorPickerVC.view.backgroundColor = UIColor.whiteColor()
        (colorPickerVC.view as! SwiftColorView).showGridLines = true
        let popVC = colorPickerVC.popoverPresentationController!
        popVC.sourceRect = self.toolbar.frame
        popVC.sourceView = self.toolbar
        popVC.permittedArrowDirections = .Any
        popVC.delegate = self;
        self.getViewController().presentViewController(colorPickerVC, animated: true, completion: nil)
    }

    private func colorPicked(color : UIColor) {
        self.chosenColor = color
        switch self.colorPickerMode {
        case .Text:
            self.editor.setTextColor(color)
            break
        case .TextBackground:
            self.editor.setTextBackgroundColor(color)
            break
        default:
            break
        }
    }
}

// MARK: HtmlCell
extension HtmlCell: UIPopoverPresentationControllerDelegate, SwiftColorPickerDelegate, SwiftColorPickerDataSource {
    // this enables pop over on iphones
    public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.None
    }
    
    // this populates the midway point in data between startindex & finishIndex 
    //  with a color that is midway between the two values in startindex & finishIndex
    private func midwayFill(inout data : [UIColor], startIndex: Int, finishIndex: Int) {
        let delta = (finishIndex - startIndex) / 2
        if delta > 0 {
            let midPointIndex = startIndex + delta
            let midColor = data[startIndex].betweenColor(data[finishIndex])
            data[midPointIndex] = midColor
            midwayFill(&data, startIndex: startIndex, finishIndex: midPointIndex)
            midwayFill(&data, startIndex: midPointIndex, finishIndex: finishIndex)
        }
    }
    
    // fills the color matrix array with all the colors to make available
    private func fillColorMatrix(numX: Int, _ numY: Int) {
        colorMatrix = [[UIColor]]()
        let midPoint = 1 + ((numY-1) / 2)
        if numX > 0 && numY > 0 {
            for x in 0..<numX {
                // this is the seed color (goes in the middle)
                let color = self.colorsInPicker[x]
                let isShade = color == UIColor.grayColor() || color == UIColor.blackColor()
                var colInX = [UIColor]()
                // fill the array with that color (because we need to fill out the array with element)
                for _ in 0..<numY {
                    colInX.append(color)
                }
                // dark is black for gray & 50% darker for colors
                let darkest = (isShade) ? UIColor.blackColor() : color.darkerColor(0.5)
                // light is white (extremes)
                let lightest = UIColor.whiteColor()
                // next is black
                colInX[1] = lightest
                // bottom is white
                colInX[numY-1] = darkest
                // fill in from black to mid-point
                midwayFill(&colInX, startIndex: 1, finishIndex: midPoint)
                // fill in from midpoint to white
                midwayFill(&colInX, startIndex: midPoint - 1, finishIndex: numY-1)
                // if the original color isn't gray - replace black with the mid point between
                //  the nearest color to black and replace white with the mid point between the
                //  nearest color and white (because gray will provide white & black as a choice)
                if (!isShade) {
                    colInX[1] = colInX[1].betweenColor(colInX[2])
                }
                colorMatrix!.append(colInX)
            }
        }
    }
    
    // MARK: - Swift Color Picker Data Source
    public func colorForPalletIndex(x: Int, y: Int, numXStripes: Int, numYStripes: Int) -> UIColor {
        if colorMatrix?.count > x  {
            let colorArray = colorMatrix![x]
            if colorArray.count > y {
                return colorArray[y]
            } else {
                fillColorMatrix(numXStripes,numYStripes)
                return colorForPalletIndex(x, y:y, numXStripes: numXStripes, numYStripes: numYStripes)
            }
        } else {
            fillColorMatrix(numXStripes,numYStripes)
            return colorForPalletIndex(x, y:y, numXStripes: numXStripes, numYStripes: numYStripes)
        }
    }
    
    
    // MARK: Color Picker Delegate
    public func colorSelectionChanged(selectedColor color: UIColor) {
        colorPicked(color)
    }
}

