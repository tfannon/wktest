//
//  Issue.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/23/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Issue : BaseObject {

    static var term = [
        "title":"Title",
        "parentTitle":"Parent",
        "parentType":"Parent",
        "workflowState":"State",
        "manager":"Manager",
        "reviewer":"Reviewer",
        "businessContact":"Business Contact",
        
        "createdUser":"Creator",
        "createdDate":"Created Date",
        "released":"Released",
    ]
    
    class func getTerminology(key: String) -> String {
        return term[key] ?? ""
    }

    var businessContact: String = ""
    var manager: String = ""
    var reviewer: String = ""

    var createdUser: String = ""
    var createdDate: NSDate?
    var released: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map)
        businessContact <- map["BusinessContact"]
        manager <- map["Manager"]
        reviewer <- map["Reviewer"]
        createdUser <- map["CreatedUser"]
        createdDate <- map["CreatedDate"]
        released <- map["Released"]
        
        createdDate <- (map["CreatedDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        isMapping = false
    }
    
    override var description: String {
        return "\(title!) \(parentTitle) \(createdDate)"
    }
}
