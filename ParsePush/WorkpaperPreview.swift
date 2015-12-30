//
//  WorkpaperPreview.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/29/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

protocol WorkpaperPreviewerDelegate : UIDocumentInteractionControllerDelegate {
    var documentInteractionController: UIDocumentInteractionController! { get }
}

class WorkpaperHelper {
    class func preview(previewer : WorkpaperPreviewerDelegate, workpaper : Workpaper) {
        let att = Services.loadObjects([.Attachment], explicitIds: [workpaper.attachmentId])!.attachments.first!
        let data = NSData(base64EncodedString: att.attachmentData!, options: .IgnoreUnknownCharacters)
        
        let baseUrl = Services.storageProviderLocation
            .URLByAppendingPathExtension(workpaper.attachmentTitle!)
            .URLByAppendingPathExtension(workpaper.attachmentExtension!)
        FileHelper.deleteFile(baseUrl)
        data!.writeToURL(baseUrl, atomically: true)
        previewer.documentInteractionController.URL = baseUrl
        previewer.documentInteractionController.presentPreviewAnimated(true)
        
    }
}