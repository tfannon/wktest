//
//  HtmlEditorController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 11/25/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import RichEditorView

class HtmlEditorController: UIViewController, RichEditorDelegate, RichEditorToolbarDelegate {
    
    private var html : String
    var editor : RichEditorView!
    
    init(html : String?) {
        self.html = html ?? ""
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        editor = RichEditorView()
        editor.delegate = self
        self.view.addSubview(editor)
        editor.setHTML(self.html)
    }

    override func viewDidLayoutSubviews() {
        let m : CGFloat = 30
        let h = view.layoutMarginsGuide.layoutFrame.height
        editor.frame = CGRect(
            origin: CGPoint(x: view.readableContentGuide.layoutFrame.origin.x, y: m),
            size: CGSize(
                width: self.view.readableContentGuide.layoutFrame.width,
                height: h - m * 2))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - RichEditorDelegate
    /**
    Called when the inner height of the text being displayed changes
    Can be used to update the UI
    */
    func richEditor(editor: RichEditorView, heightDidChange height: Int) {
    }
    
    /**
     Called whenever the content inside the view changes
     */
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
    }
    
    /**
     Called when the rich editor starts editing
     */
    func richEditorTookFocus(editor: RichEditorView) {
        
    }
    
    /**
     Called when the rich editor stops editing or loses focus
     */
    func richEditorLostFocus(editor: RichEditorView) {
        
    }
    
    /**
     Called when the RichEditorView has become ready to receive input
     More concretely, is called when the internal UIWebView loads for the first time, and contentHTML is set
     */
    func richEditorDidLoad(editor: RichEditorView) {
        
    }
    
    /**
     Called when the internal UIWebView begins loading a URL that it does not know how to respond to
     For example, if there is an external link, and then the user taps it
     */
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool {
        return false
    }
    
    /**
     Called when custom actions are called by callbacks in the JS
     By default, this method is not used unless called by some custom JS that you add
     */
    func richEditor(editor: RichEditorView, handleCustomAction action: String) {
        
    }
    
    // MARK: - RichEditorToolbarDelegate
    /**
     Called when the Text Color toolbar item is pressed.
     */
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        
    }
    
    /**
     Called when the Background Color toolbar item is pressed.
     */
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        
    }
    
    /**
     Called when the Insert Image toolbar item is pressed.
     */
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        
    }
    
    /**
     Called when the Isert Link toolbar item is pressed.
     */
    func richEditorToolbarChangeInsertLink(toolbar: RichEditorToolbar) {
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
