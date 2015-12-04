//
//  ZZSEditorController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/3/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import RichEditorView
import iOS_Color_Picker

class HtmlEditorController : UIViewController, RichEditorDelegate, RichEditorToolbarDelegate, FCColorPickerViewControllerDelegate {

    @IBOutlet weak var innerView: UIView!
    
    private var editor : RichEditorView!
    private var editorIsLoaded = false
    private enum ColorPickerMode : Int {
        case None
        case Text
        case TextBackground
    }
    private var colorPickerMode = ColorPickerMode.None
    private var chosenColor : UIColor?
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()

    var _text : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.innerView.backgroundColor = UIColor.purpleColor()

        editor = RichEditorView(frame: innerView.frame)
        editor.delegate = self
        editor.inputAccessoryView = toolbar
        innerView.addSubview(editor)
        editor.frame = innerView.bounds
        
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
    }
    
    override func viewDidLayoutSubviews() {
        editor.frame = innerView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        editorIsLoaded = true
        editor.setHTML(_text)
        editor.focus()
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
        showColorPicker(.Text)
    }
    
    /**
     Called when the Background Color toolbar item is pressed.
     */
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        showColorPicker(.TextBackground)
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
    
    //MARK: FCColorPickerViewController
    
    var colorPicker : FCColorPickerViewController?
    
    private func showColorPicker(mode : ColorPickerMode) {
        self.colorPickerMode = mode
        if colorPicker == nil {
            self.colorPicker = FCColorPickerViewController.colorPicker()
            colorPicker!.color = UIColor.blueColor()
            colorPicker!.delegate = self
        }
        self.presentViewController(colorPicker!, animated: true, completion: nil)
    }
    
    private func hideColorPicker() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func colorPickerViewController(colorPicker: FCColorPickerViewController, didSelectColor color: UIColor) {
        self.chosenColor = color
        hideColorPicker()
    }
    
    /**
     Called on the delegate of `colorPicker` when the user has canceled selecting a color.
     
     @param colorPicker The `FCColorPickerViewController` that has canceled picking a color.
     */
    func colorPickerViewControllerDidCancel(colorPicker: FCColorPickerViewController) {
        hideColorPicker()
    }

    var textString : String {
        get {
            return self.editor.getHTML()
        }
        set {
            _text = newValue
            if (editorIsLoaded) {
                editor.setHTML(_text)
            }
        }
    }
}
