//
//  Procedure.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Procedure : Mappable, CustomDebugStringConvertible {
    required init(_ map: Map){}
    
    // used for creating one from scratch
    init() {}
    
    var id: Int?
    var title: String?
    var code: String?
    var text1: String?
    var text2: String?
    var text3: String?
    var text4: String?
    var dueDate: String?
    var testResults: Int?
    var resultsText1: String?
    var resultsText2: String?
    var resultsText3: String?
    var resultsText4: String?
    var reviewDueDate: String?
    var tester: String?
    var reviewer: String?
    var workflowState: Int?
    var readOnly  : Bool?

    func mapping(map: Map) {
        id <- map["Id"]
        title <- map["Title"]
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
    
    var debugDescription: String {
        return "\(title!) \(text1) \(testResults) \(resultsText1) \(dueDate)"
    }
}
