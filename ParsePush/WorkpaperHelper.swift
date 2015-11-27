//
//  WorkpaperHelper.swift
//  TeamMate
//
//  Created by Tommy Fannon on 11/26/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

protocol WorkpaperOwnerDelegate {
    var owningObject: Procedure { get }
    var owningViewController: UIViewController { get }
}

class WorkpaperChooser : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var _title = ""
    var _description: String?
    var delegate: WorkpaperOwnerDelegate!
    
    required init(owner: WorkpaperOwnerDelegate) {
        self.delegate = owner
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
        //print(self.title, info)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            data = UIImagePNGRepresentation(image) {
            let procedure = self.delegate.owningObject
            let fileName = Services.storageProviderLocation.URLByAppendingPathComponent(self._title).path!
                data.writeToFile(fileName, atomically: true)
                print(try! NSFileManager.defaultManager().attributesOfItemAtPath(fileName))
                procedure.workpapers.append(
                    Workpaper() {
                        $0.title = self._title
                        $0.oDescription = self._description
                })
                Services.save(procedure)
        }
        self.delegate.owningViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}