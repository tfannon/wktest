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

public class TextAutoSizeCell : Cell<String>, CellType {
    
    //@IBOutlet weak var textView: UITextView!
    
    public override func setup() {
        height = { 120 }
        super.setup()
        selectionStyle = .None
    }
}

public final class TextAutoSizeRow: Row<String, TextAutoSizeCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<TextAutoSizeCell>(nibName: "TextAutoSizeCell")
        //self.cell.textView.text = self.value
    }
}