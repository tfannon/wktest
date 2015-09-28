//
//  Notification.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/27/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Notification : Mappable {
    required init(_ map: Map){}
    
    var title: String?
    var description: String?
    
    func mapping(map: Map) {
        title <- map["Title"]
        description <- map["Description"]
    }
    
}
