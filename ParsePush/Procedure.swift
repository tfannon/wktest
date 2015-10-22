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
    
    private static var terminology = [
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
    
    // this holds the names of the dirtied properties
    // we use the name of the property as specified in the Map (Capital case)
    // because this is used to match to a property name on the server side
    var dirtyFields = Set<String>()
    
    static func getTerminology(key : String) -> String{
        return terminology[key] ?? ""
    }
    
    var id: Int?
    var parentTitle: String?
    var parentType: Int = 0
    var title: String? { didSet { dirtyFields.insert("Title") } }
    var code: String? { didSet { dirtyFields.insert("Code") } }
    var text1: String? { didSet { dirtyFields.insert("Text1") } }
    var text2: String? { didSet { dirtyFields.insert("Text2") } }
    var text3: String? { didSet { dirtyFields.insert("Text3") } }
    var text4: String? { didSet { dirtyFields.insert("Text4") } }
    var dueDate: NSDate? { didSet { dirtyFields.insert("DueDate") } }
    var testResults: Int = 0 { didSet { dirtyFields.insert("TestResults") } }
    var resultsText1: String? { didSet { dirtyFields.insert("ResultsText1") } }
    var resultsText2: String? { didSet { dirtyFields.insert("ResultsText2") } }
    var resultsText3: String? { didSet { dirtyFields.insert("ResultsText3") } }
    var resultsText4: String? { didSet { dirtyFields.insert("ResultsText4") } }
    var reviewDueDate: NSDate? { didSet { dirtyFields.insert("ReviewDueDate") } }
    var tester: String?
    var reviewer: String?
    var workflowState: Int = 1 { didSet { dirtyFields.insert("WorkflowState") } }
    var readOnly  : Bool?
    var allowedStates : [Int]?
    
    func isDirty() -> Bool{
        return dirtyFields.count > 0
    }
    
    func clean() {
        dirtyFields = []
    }


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
        dirtyFields <- map["DirtyFields"]
        
        //todo: make this a shared function pointer
        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: {  NSDate(fromString: $0!, format:DateFormat.ISO8601(nil)) },
            toJSON: { $0.map { $0.toIsoString() } }))
        
//        reviewDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
//            fromJSON: { return $0 != nil ? NSDate(fromString: "\($0!)-05:00", format:DateFormat.ISO8601(nil)) : nil },
//            toJSON: { $0.map { $0 != nil ? $0!.toIsoString() : "" } }))
        
        allowedStates <- map["AllowedStates"]
    }
    
    
    override var description: String {
        return "\(title!) \(parentTitle) \(testResults) \(dueDate) \(allowedStates)"
    }
}

