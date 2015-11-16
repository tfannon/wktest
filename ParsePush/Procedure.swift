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
//    required init(_ map: Map) {
//    }
//    
//    // used for creating one from scratch
//    override init() {
//    }
    
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
    
    private var isMapping = false
    
    // this holds the names of the dirtied properties
    // we use the name of the property as specified in the Map (Capital case)
    // because this is used to match to a property name on the server side
    private var setDirtyFields = Set<String>()
    private var dirtyFields : [String] {
        get { return Array(setDirtyFields) }
        set { setDirtyFields = Set<String>(newValue) }
    }
    
    static func getTerminology(key : String) -> String{
        return terminology[key] ?? ""
    }
    
    //var id: Int?
    var parentTitle: String?
    var parentType: Int = 0
    var title: String? { didSet { setDirty("Title") } }
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
    var workflowState: Int = 1 { didSet { setDirty("WorkflowState") } }
    var readOnly  : Bool?
    var allowedStates : [Int]?
    var lmg: String?
    var wasChangedOnServer : Bool?
    var syncState: SyncState = .Unchanged

    //grid cannot read enums
    var sync: String { get { return syncState.displayName } }
    

    var changes : [Change]?
    
    func isDirty() -> Bool{
        return setDirtyFields.count > 0
    }
    
    func clean() {
        setDirtyFields = []
    }

    private func setDirty(field : String!)
    {
        if (!isMapping)
        {
            setDirtyFields.insert(field)
            self.syncState = .Dirty
        }
    }


    override func mapping(map: Map) {
        isMapping = true
        
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
        lmg <- map["LMG"]
        wasChangedOnServer <- map["WasChangedOnServer"]
        changes <- map["Changes"]
        
        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        reviewDueDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        allowedStates <- map["AllowedStates"]
        
        syncState <- map["SyncState"]
        
        isMapping = false
    }
    
    
    
    override var description: String {
        return "\(title!) \(parentTitle) \(testResults) \(dueDate) \(allowedStates)"
    }
}

