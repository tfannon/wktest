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

        self.testResults = 0
        self.dueDate = NSDate()
        self.resultsText1 = ""
    }
    
    // used for creating one from scratch
    override init() {
        self.testResults = 0
        self.dueDate = NSDate()
        self.resultsText1 = ""
    }
    
    static var terminology = [
        "title":"Title",
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
    var title: String?
    var code: String?
    var text1: String?
    var text2: String?
    var text3: String?
    var text4: String?
    var dueDate: NSDate?
    var testResults: Int = 0
    var resultsText1: String
    var resultsText2: String?
    var resultsText3: String?
    var resultsText4: String?
    var reviewDueDate: String?
    var tester: String?
    var reviewer: String?
    var workflowState: Int = 0
    var readOnly  : Bool?
    
    var foo: String?

    func mapping(map: Map) {
        id <- map["Id"]
        title <- map["Title"]
        workflowState <- map["WorkflowState"]
        code <- map["Code"]
        dueDate <- map["DueDate"]
        reviewDueDate <- map["ReviewDueDate"]
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
    }
    
    override var description: String {
        return "\(title!) \(text1!) \(testResults) \(resultsText1) \(dueDate)"
    }
}
