//
//  CustomCells.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/9/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

protocol CustomCellDelegate {
    func changed(cell : UITableViewCell)
}

public class CustomCell : UITableViewCell {
    var delegate : CustomCellDelegate? = nil
    func changed() {
        delegate?.changed(self)
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
        contentView.bringSubviewToFront(nodateView)
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
}

public class HtmlCell: CustomCell, UIWebViewDelegate {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private var loaded = false
    private var timer : NSTimer?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        
        webView.delegate = self
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        self.contentView.bringSubviewToFront(indicator)
     }
    
    /// Custom setter so we can initialise the height of the text view
    var _textString : String?
    var textString: String {
        get {
            return webView.stringByEvaluatingJavaScriptFromString("document.documentElement.innerText;")
                ?? ""
        }
        set {
            startWaiting()
            _textString = newValue
            webView.loadHTMLString(newValue, baseURL: nil)
        }
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if webView == nil {
            return
        }
        if selected {
            webView.becomeFirstResponder()
        } else {
            webView.resignFirstResponder()
        }
    }
    
    public func webViewDidFinishLoad(_: UIWebView)
    {
        loaded = true
    }
    
    private func startWaiting() {
        if !webView.hidden {
            webView.hidden = true
            indicator.sizeToFit()
            indicator.hidden = false
            indicator.startAnimating()
        }
    }
    private func stopWaiting() {
        if webView.hidden {
            webView.hidden = false
            indicator.hidden = true
            indicator.stopAnimating()
        }
    }
    
    public func resize() {
        startWaiting()
        if (!loaded && self.timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "resizeImpl", userInfo: nil, repeats: true)
        }
        else {
            resizeImpl()
        }
    }
    
    public func resizeImpl() {
        if (loaded) {
            self.timer?.invalidate()
            self.timer = nil

            var content_height : CGFloat = 100
            let a = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.scrollHeight")
            let b = a ?? "0"
            if let c = Int(b) {
                content_height = CGFloat(c)
            }
            let current_height = webView.frame.size.height
            
            if current_height != content_height {
                UIView.setAnimationsEnabled(false)
                tableView?.beginUpdates()
                if heightConstraint.constant != content_height {
                    heightConstraint.constant = content_height
                }
                tableView?.endUpdates()
                UIView.setAnimationsEnabled(true)
            }
            
            stopWaiting()
        }
    }
}
