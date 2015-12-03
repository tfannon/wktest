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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.redColor()
    }
    
//    var textString : String {
//        get {
//            return self.getHTML()
//        }
//        set {
//            self.setHTML(newValue)
//        }
//    }
    
    
}
