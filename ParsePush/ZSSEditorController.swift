//
//  ZZSEditorController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/3/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import ZSSRichTextEditor

class HtmlEditorController : ZSSRichTextEditor {
    
    required init(value : String?) {
        super.init(nibName: nil, bundle: nil)
        self.setHTML(value ?? "")
        self.formatHTML = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textString : String {
        get {
            return self.getHTML()
        }
    }
    
    
}
