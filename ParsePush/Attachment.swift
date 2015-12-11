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

    var attachmentData: String?
    
    override func mapping(map: Map) {
        super.mapping(map)
        attachmentData <- map["AttachmentData"]
    }
}
