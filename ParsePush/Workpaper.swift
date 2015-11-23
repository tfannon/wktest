//
//  Workpaper.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/7/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Workpaper : BaseObject {

    //    required init(_ map: Map) {
//    }
//    
//    // used for creating one from scratch
//    override init() {
//    }
    
    private static var terminology = [
        "title":"Title",
        "description":"Description",
        "parentTitle":"Parent",
        "parentType":"Parent",
        "reviewer":"Reviewer",
        "manager":"Manager",
        "dueDate":"Due Date",
        "reviewDueDate":"Review Due Date",
        "workflowState":"State"
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
    var oDescription: String? { didSet { setDirty("Description") } }
    var dueDate: NSDate? { didSet { setDirty("DueDate") } }
    var reviewDueDate: NSDate? { didSet { setDirty("ReviewDueDate") } }
    var workflowState: Int = 1 { didSet { setDirty("WorkflowState") } }
    var manager: String = ""
    var reviewer: String = ""
    var attachmentId: Int = 0
    var attachmentTitle: String?
    var attachmentExtension: String?
    var attachmentSize: Int64 = 0
    
    var readOnly  : Bool?
    var allowedStates : [Int]?
    var lmg: String?
    var wasChangedOnServer : Bool?
    var syncState: SyncState = .Unchanged
    
    //grid cannot read enums
    var sync: String { get { return syncState.displayName } }
    //another hack for the grid
    var workflowStateTitle: String { get { return WorkflowState(rawValue: workflowState)!.displayName } }
    
    
    
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
        oDescription <- map["Description"]
        manager <- map["Manager"]
        reviewer <- map["Reviewer"]
        attachmentId <- map["AttachmentId"]
        attachmentTitle <- map["AttachmentTitle"]
        attachmentExtension <- map["AttachmentExtension"]
        attachmentSize <- map["AttachmentSize"]
        
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
        return "\(title!) \(parentTitle) \(oDescription) \(dueDate) \(allowedStates)"
    }
}
