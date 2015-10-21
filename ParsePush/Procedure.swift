//
//  Procedure.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Procedure : NSObject, Mappable, CustomDebugStringConvertible {
    required init(_ map: Map) {
    }
    
    // used for creating one from scratch
    override init() {
    }
    
    static var terminology = [
        "title":"Title",
        "parent":"Parent",
        "parentType":"Parent",
        "code":"Code",
        "dueDate":"Due Date",
        "tester":"Tester",
        "reviewer":"Reviewer",
        "reviewDueDate":"Review Due Date",
        "text1":"Details",
        "text2":"Scope",
        "text3":"Purpose",
        "testResults":"Results",
        "workflowState":"State",
        "resultsText1":"Record of Work Done",
        "resultsText2":"Conclusion",
        "resultsText3":"Notes"
    ]
    
    static func getTerminology(key : String) -> String{
        return terminology[key] ?? ""
    }
    
    var id: Int?
    var parent: String?
    var parentType: Int = 0
    var title: String?
    var code: String?
    var text1: String?
    var text2: String?
    var text3: String?
    var text4: String?
    var dueDate: NSDate?
    var testResults: Int = 0
    var resultsText1: String?
    var resultsText2: String?
    var resultsText3: String?
    var resultsText4: String?
    var reviewDueDate: NSDate?
    var tester: String?
    var reviewer: String?
    var workflowState: Int = 0
    var readOnly  : Bool?

    func mapping(map: Map) {
        id <- map["Id"]
        title <- map["Title"]
        parent <- map["Parent"]
        parentType <- map["ParentType"]
        workflowState <- map["WorkflowState"]
        code <- map["Code"]
        text1 <- map["Text1"]
        text2 <- map["Text2"]
        text3 <- map["Text3"]
        text4 <- map["Text4"]
        tester <- map["Tester"]
        reviewer <- map["Reviewer"]
        testResults <- map["Results.TestResults"]
        resultsText1 <- map["Results.ResultsText1"]
        resultsText2 <- map["Results.ResultsText2"]
        resultsText3 <- map["Results.ResultsText3"]
        resultsText4 <- map["Results.ResultsText4"]
        readOnly <- map["ReadOnly"]
        
        //todo: make this a shared function pointer
        dueDate <- (map["DueDate"], TransformOf<NSDate?, String>(
            fromJSON: { return $0 != nil ? NSDate(fromString: "\($0!)-05:00", format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0!.toIsoString() } }))
        
        dueDate <- (map["ReviewDueDate"], TransformOf<NSDate?, String>(
            fromJSON: { return $0 != nil ? NSDate(fromString: "\($0!)-05:00", format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0!.toIsoString() } }))
    }
    
    
    override var description: String {
        return "\(title!) \(text1) \(testResults) \(resultsText1) \(dueDate)"
    }
}

