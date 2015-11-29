//
//  Procedure.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper


class Procedure : BaseObject  {
    static var term =  [
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
        "resultsText4":"Results 4"]

    class func getTerminology(key: String) -> String {
        return term[key] ?? ""
    }
    
    var code: String? { didSet { setDirty("Code") } }
    var text1: String? { didSet { setDirty("Text1") } }
    var text2: String? { didSet { setDirty("Text2") } }
    var text3: String? { didSet { setDirty("Text3") } }
    var text4: String? { didSet { setDirty("Text4") } }
    var dueDate: NSDate? { didSet { setDirty("DueDate") } }
    var testResults: Int = 0 { didSet { setDirty("TestResults") } }
    var resultsText1: String? { didSet { setDirty("ResultsText1") } }
    var resultsText2: String? { didSet { setDirty("ResultsText2") } }
    var resultsText3: String? { didSet { setDirty("ResultsText3") } }
    var resultsText4: String? { didSet { setDirty("ResultsText4") } }
    var reviewDueDate: NSDate? { didSet { setDirty("ReviewDueDate") } }
    var tester: String = ""
    var reviewer: String = ""
    
    //can hang new workpapers off here
    var workpapers = [Workpaper]()
    
       
    override func mapping(map: Map) {
        super.mapping(map)
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
        
        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        reviewDueDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        workpapers <- map["Workpapers"]
       
        isMapping = false
    }
    
    override var description: String {
        return "\(title!) \(parentTitle) \(testResults) \(dueDate) \(allowedStates)"
    }
}

