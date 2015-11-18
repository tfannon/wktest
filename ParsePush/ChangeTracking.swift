//
//  ChangeTracking.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/7/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Change: BaseObject 
{
    var user : String?
    var date : NSDate?
    var title : String?
    var changeDescription : String?
    var details : [ChangeDetail]?
    
    override func mapping(map: Map) {
        id <- map["Id"]
        user <- map["User"]
        title <- map["Title"]
        changeDescription <- map["Description"]
        date <- (map["Date"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: (($0!.length >= 19) ? $0!.substring(19) : $0!.substring(10)) + "-5:00", format: DateFormat.ISO8601(ISO8601Format.DateTime)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        details <- map["Details"]
    }
}

class ChangeDetail: BaseObject
{
    var label : String?
    var isHtml : Bool?
    var priorValue : String?
    var currentValue : String?
    
    override func mapping(map: Map) {
        label <- map["Label"]
        isHtml <- map["IsHtml"]
        priorValue <- map["PriorValue"]
        currentValue <- map["CurrentValue"]
    }
}

