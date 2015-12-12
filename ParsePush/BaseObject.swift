//
//  BaseObject.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/16/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

protocol IssueParent {
    var issues : [Issue] { get }
}
protocol WorkpaperParent {
    var workpapers : [Workpaper] { get }
}

class BaseObject : NSObject, Mappable, CustomDebugStringConvertible {
    
    required init(_ map: Map) {
    }
    
    override init() {
    }
    
    static let baseTerm = [
        "sync":"Sync",
        "title":"Title",
        "code":"Code",

        "parentType":"",
        "parentTitle":"Parent",

        "tester":"Tester",
        "reviewer":"Reviewer",
        "manager":"Manager",
        "dueDate":"Due",
        "reviewDueDate":"Review Due",
        
        "workflowState":"",
        "workflowStateTitle":"State",
    ]
    
    var id: Int?
    var code: String?
    var parentTitle: String?
    var parentType: Int = 0
    var title: String? { didSet { setDirty("Title") } }
    var workflowState: Int = 1 { didSet { setDirty("WorkflowState") } }
    var readOnly  : Bool?
    var allowedStates : [Int]?
    var lmg: String?
    var wasChangedOnServer : Bool?
    var syncState: SyncState = .Unchanged
    
    var isNew : Bool { return id < 0 }
    
    //can hang new workpapers off here
    var workpapers = [Workpaper]()
    // issues
    var issues = [Issue]()
    
    var issueIds = [Int]()
    var workpaperIds = [Int]()
    

    //grid cannot read enums
    var sync: String { get { return syncState.displayName } }
    //another hack for the grid
    var workflowStateTitle: String { get { return WorkflowState(rawValue: workflowState)!.displayName } }
    
    var isMapping = false
    
    func mapping(map: Map) {
        isMapping = true
        id <- map["Id"]
        title <- map["Title"]
        parentTitle <- map["ParentTitle"]
        parentType <- map["ParentType"]
        workflowState <- map["WorkflowState"]
        
        //server flags
        readOnly <- map["ReadOnly"]
        dirtyFields <- map["DirtyFields"]
        lmg <- map["LMG"]
        wasChangedOnServer <- map["WasChangedOnServer"]
        syncState <- map["SyncState"]

        allowedStates <- map["AllowedStates"]
        changes <- map["Changes"]
   }
    
    // this holds the names of the dirtied properties
    // we use the name of the property as specified in the Map (Capital case)
    // because this is used to match to a property name on the server side
    private var setDirtyFields = Set<String>()
    
    private var dirtyFields : [String] {
        get { return Array(setDirtyFields) }
        set { setDirtyFields = Set<String>(newValue) }
    }
    
    func isDirty() -> Bool{
        return setDirtyFields.count > 0
    }
    
    func clean() {
        setDirtyFields = []
    }
    
    func setDirty(field : String!) {
        if (!isMapping) {
            setDirtyFields.insert(field)
            self.syncState = .Dirty
        }
    }
    
    func addChild(child : BaseObject) -> Bool {
        if let issue = child as? Issue {
            if !self.issueIds.contains(issue.id!) {
                self.issues.append(issue)
                self.issueIds.append(issue.id!)
                return true
            }
        }
        else if let workpaper = child as? Workpaper {
            if !self.workpaperIds.contains(workpaper.id!) {
                self.workpapers.append(workpaper)
                self.workpaperIds.append(workpaper.id!)
                return true
            }
        }
        else {
            fatalError("not handling child of type \(child.className)")
        }
        return false
    }
    
    var changes : [Change]?
}

