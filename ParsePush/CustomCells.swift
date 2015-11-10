//
//  CustomCells.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/9/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

public class TextCell : UITableViewCell, UITextFieldDelegate
{
    @IBOutlet var textField: UITextField!

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        textField.font = .preferredFontForTextStyle(UIFontTextStyleBody)
        textField.delegate = self
        textField.borderStyle = .None
    }
}

public class TextAutoSizeCell: UITableViewCell, UITextViewDelegate {
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
    }
}
