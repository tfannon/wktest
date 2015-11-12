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
        segmented.apportionsSegmentWidthsByContent = true
        segmented.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
        selectionStyle = .None
        self.detailTextLabel?.hidden = true
        self.textLabel?.hidden
    }
    
    public func setOptions(options : [String]) {
        var maxWidth : CGFloat = 0
        segmented.removeAllSegments()
        for option in options.enumerate() {
            segmented.insertSegmentWithTitle(option.element, atIndex: option.index, animated: false)
            let s = option.element as NSString
            let attr : [String : AnyObject] = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
            let width = s.sizeWithAttributes(attr).width
            if (width > maxWidth) {
                maxWidth = width
            }
        }
        for option in options.enumerate() {
            segmented.setWidth(maxWidth + 10, forSegmentAtIndex: option.index)
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
