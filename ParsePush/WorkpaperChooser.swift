//
//  WorkpaperHelper.swift
//  TeamMate
//
//  Created by Tommy Fannon on 11/26/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit



class WorkpaperChooser : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var _title = ""
    var _description: String?
    var delegate: WorkpaperChooserDelegate!
    
    
    required init(owner: WorkpaperChooserDelegate) {
        self.delegate = owner
    }
    
    class func choose(delegate: WorkpaperChooserDelegate) {
        let chooser = WorkpaperChooser(owner: delegate)
        chooser.handleAddWorkpaper()
    }
    
    
    //MARK: - add workpaper
    func handleAddWorkpaper() {
        let alertController = UIAlertController(title: "Add Workpaper", message: "Choose title and attachment", preferredStyle: .Alert)
        
        let photoAction = UIAlertAction(title: "Add photo", style: .Default) { (_) in
            self._title = alertController.textFields![0].text!
            self._description = alertController.textFields![1].text
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            self.delegate.owningViewController.presentViewController(imagePicker, animated: true, completion: nil)
        }
        photoAction.enabled = false
        
        let documentAction = UIAlertAction(title: "Add document", style: .Default) { (_) in
        }
        documentAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                photoAction.enabled = textField.text != ""
                documentAction.enabled = textField.text != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Description"
        }
        
        alertController.addAction(photoAction)
        alertController.addAction(documentAction)
        alertController.addAction(cancelAction)
        self.delegate.owningViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let jpg = UIImageJPEGRepresentation(image, 0.0) {
                let workpaper = Workpaper.create(self.delegate.workpaperOwner) as Workpaper
                workpaper.title = _title
                workpaper.oDescription = _description
                workpaper.attachmentExtension = "jpg"
                
                let attachment = Attachment.create(workpaper) as Attachment
                attachment.attachmentData = jpg.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                Services.saveObject(attachment, log: true)
                
                workpaper.attachmentId = attachment.id!
                Services.saveObject(workpaper, parent: self.delegate.workpaperOwner, log: true)

                self.delegate.workpaperAddedCallback(true, workpaper: workpaper)
        }
        self.delegate.owningViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}