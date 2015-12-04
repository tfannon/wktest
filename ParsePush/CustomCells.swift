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
import iOS_Color_Picker

@objc protocol CustomCellDelegate {
    func changed(cell : UITableViewCell)
    func getViewController() -> UIViewController
    optional func beganEditing(cell : UITableViewCell)
    optional func finishedEditing(cell : UITableViewCell)
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

public class HtmlCell: CustomCell, RichEditorDelegate, RichEditorToolbarDelegate, FCColorPickerViewControllerDelegate {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.innerView.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()

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
            if (_textString != newValue) {
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
    
    //MARK: FCColorPickerViewController
    
    var colorPicker : FCColorPickerViewController?
    
    private func showColorPicker(mode : ColorPickerMode) {
        self.colorPickerMode = mode
        if colorPicker == nil {
            self.colorPicker = FCColorPickerViewController.colorPicker()
            colorPicker!.color = UIColor.blueColor()
            colorPicker!.delegate = self
        }
        self.getViewController().presentViewController(colorPicker!, animated: true, completion: nil)
    }
    
    private func hideColorPicker() {
        self.getViewController().dismissViewControllerAnimated(true, completion: nil)
        if let c = self.chosenColor {
            switch self.colorPickerMode {
            case .Text:
                self.editor.setTextColor(c)
                break
            case .TextBackground:
                self.editor.setTextBackgroundColor(c)
                break
            default:
                break
            }
        }
    }
    
    public func colorPickerViewController(colorPicker: FCColorPickerViewController, didSelectColor color: UIColor) {
        self.chosenColor = color
        hideColorPicker()
    }
    
    /**
     Called on the delegate of `colorPicker` when the user has canceled selecting a color.
     
     @param colorPicker The `FCColorPickerViewController` that has canceled picking a color.
     */
    public func colorPickerViewControllerDidCancel(colorPicker: FCColorPickerViewController) {
        hideColorPicker()
    }
}

