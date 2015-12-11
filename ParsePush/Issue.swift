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
        "code":"Code",
        "parentTitle":"Parent",
        "parentType":"Parent",
        "workflowState":"State",
        
        "manager":"Manager",
        "reviewer":"Reviewer",
        "businessContact":"Business Contact",
        
        "text1":"Finding",
        "text2":"Criteria",
        "text3":"Condition",
        "text4":"Cause",
        "text5":"Effect",
        
        "yesNo1":"Regulatory Impact",
        "yesNo2":"Recurred",

        "numericValue1":"Cost Avoidance",
        "numericValue2":"Cost Savings",
        
        "createdUser":"Creator",
        "createdDate":"Created",
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

    var text1: String? { didSet { setDirty("Text1") } }
    var text2: String? { didSet { setDirty("Text2") } }
    var text3: String? { didSet { setDirty("Text3") } }
    var text4: String? { didSet { setDirty("Text4") } }
    var text5: String? { didSet { setDirty("Text5") } }

    var numericValue1: Float? { didSet { setDirty("numericValue1") } }
    var numericValue2: Float? { didSet { setDirty("numericValue2") } }

    var yesNo1: Bool? { didSet { setDirty("yesNo1") } }
    var yesNo2: Bool? { didSet { setDirty("yesNo2") } }
    
    var dueDate: NSDate? { didSet { setDirty("DueDate") } }
    var reviewDueDate: NSDate? { didSet { setDirty("ReviewDueDate") } }

    //can hang new workpapers off here
    var workpapers = [Workpaper]()

    override func mapping(map: Map) {
        super.mapping(map)
        businessContact <- map["BusinessContact"]
        manager <- map["Manager"]
        reviewer <- map["Reviewer"]
        createdUser <- map["CreatedUser"]
        createdDate <- map["CreatedDate"]
        released <- map["Released"]
 
        text1 <- map["Text1"]
        text2 <- map["Text2"]
        text3 <- map["Text3"]
        text4 <- map["Text4"]
        text5 <- map["Text5"]
        
        numericValue1 <- map["NumericValue1"]
        numericValue2 <- map["NumericValue2"]

        yesNo1 <- map["YesNo1"]
        yesNo2 <- map["YesNo2"]

        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        reviewDueDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))

        createdDate <- (map["CreatedDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))

        workpapers <- map["Workpapers"]

        isMapping = false
    }
    
    override var description: String {
        return "\(title!) \(parentTitle) \(createdDate)"
    }
}
