//
//  DocumentPickerViewController.swift
//  TeamMateDoc
//
//  Created by Tommy Fannon on 11/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController {

    @IBAction func openDocument(sender: AnyObject?) {
        let documentURL = self.documentStorageURL!.URLByAppendingPathComponent("Lorem.docx")
      
        // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
        self.dismissGrantingAccessToURL(documentURL)
    }

    override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
        print(mode.rawValue)
        // TODO: present a view controller appropriate for picker mode here
    }

}
