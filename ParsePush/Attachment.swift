//
//  Attachment.swift
//  TeamMate
//
//  Created by Tommy Fannon on 12/10/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Attachment: BaseObject {

    var fileExtension: String?
    var attachmentData: String?
    
    override func mapping(map: Map) {
        super.mapping(map)
        fileExtension <- map["FileExtension"]
        attachmentData <- map["AttachmentData"]
    }
    
    override var debugDescription: String {
        get {
            return "\(self.id) \(self.fileExtension)"
        }
    }
}
