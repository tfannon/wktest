//
//  NavigationRow.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/26/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class TextAutoSizeCell: Cell<String>, CellType, UITextViewDelegate {
    @IBOutlet var textView: UITextView!

    public override func setup() {
        row.title = nil
        super.setup()
        selectionStyle = .None
        textView.font = .preferredFontForTextStyle(UIFontTextStyleBody)

        // makw sure the height of the content view never shrinks < 50
        let heightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
        heightConstraint.priority = 400
        contentView.addConstraint(heightConstraint)
    }
    
    public override func update() {
        row.title = nil
        super.update()
        textString = row.value ?? ""
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

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable scrolling inside the text view so we enlarge to fitted size
        textView.scrollEnabled = false
        textView.delegate = self
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
        let newValue = (textView.text == nil || textView.text.isEmpty) ? "" : textView.text
        row.value = newValue
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
//            if let thisIndexPath = tableView?.indexPathForCell(self) {
//                tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
//            }
        }
    }
    

}


public final class TextAutoSizeRow: Row<String, TextAutoSizeCell>, RowType {
    
    public var placeholder : String? = nil

    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<TextAutoSizeCell>(nibName: "TextAutoSizeCell")
    }
    
}
