//
//  WorkpaperHelper.swift
//  TeamMate
//
//  Created by Tommy Fannon on 11/26/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

//the workpaper chooser needs to know about its owner and viewcontroller so it can present and save
protocol WorkpaperChooserDelegate {
    var workpaperOwner: Procedure { get }
    var owningViewController: UIViewController { get }
    func workpaperAddedCallback(wasAdded: Bool)
}

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
            let owner = self.delegate.workpaperOwner
            owner.workpapers.append(
                Workpaper() {
                    $0.title = self._title
                    $0.oDescription = self._description
                    $0.attachmentData = jpg
                    $0.attachmentExtension = "jpg"
            })
            self.delegate.workpaperAddedCallback(true)
        }
        self.delegate.owningViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}