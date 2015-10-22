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
        "parentTitle":"Parent",
        "parentType":"Parent",
        "code":"Code",
        "dueDate":"Due Date",
        "tester":"Tester",
        "reviewer":"Reviewer",
        "reviewDueDate":"Review Due Date",
        "text1":"Details",
        "text2":"Scope",
        "text3":"Purpose",
        "text4":"Sample Criteria",
        "testResults":"Results",
        "workflowState":"State",
        "resultsText1":"Record of Work Done",
        "resultsText2":"Conclusion",
        "resultsText3":"Notes",
        "resultsText4":"Results 4"
    ]
    
    static func getTerminology(key : String) -> String{
        return terminology[key] ?? ""
    }
    
    var id: Int?
    var parentTitle: String?
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
    var workflowState: Int = 1
    var readOnly  : Bool?
    var allowedStates : [Int]?

    func mapping(map: Map) {
        id <- map["Id"]
        title <- map["Title"]
        parentTitle <- map["ParentTitle"]
        parentType <- map["ParentType"]
        workflowState <- map["WorkflowState"]
        code <- map["Code"]
        text1 <- map["Text1"]
        text2 <- map["Text2"]
        text3 <- map["Text3"]
        text4 <- map["Text4"]
        tester <- map["Tester"]
        reviewer <- map["Reviewer"]
        testResults <- map["TestResults"]
        resultsText1 <- map["ResultsText1"]
        resultsText2 <- map["ResultsText2"]
        resultsText3 <- map["ResultsText3"]
        resultsText4 <- map["ResultsText4"]
        readOnly <- map["ReadOnly"]
        
        //todo: nil dates are taking today
        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: {  NSDate(fromString: $0!, format:DateFormat.ISO8601(nil)) },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        reviewDueDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
            fromJSON: {  NSDate(fromString: $0!, format:DateFormat.ISO8601(nil)) },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        allowedStates <- map["AllowedStates"]
    }
    
    
    override var description: String {
        return "\(title!) \(parentTitle) \(testResults) \(dueDate) \(allowedStates)"
    }
}

