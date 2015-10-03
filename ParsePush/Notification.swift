//
//  Notification.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/27/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Notification : Mappable, CustomDebugStringConvertible {
    required init(_ map: Map){}
    
    var title: String?
    var description: String?
    var eventType: Int?
    var objectType: Int?
    
    func mapping(map: Map) {
        title <- map["Title"]
        description <- map["Description"]
        eventType <- map["EventType"]
        objectType <- map["ObjectType"]
    }
    
    var debugDescription: String {
        return "\(title!): \(description!)"
    }
}
