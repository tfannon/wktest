//
//  BaseObject.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/16/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

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
        "businessContact":"Business Contact",

        "createdUser":"Creator",
        "createdDate":"Created",

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
    var objectType : ObjectType {
        if let _ = self as? Issue {
            return ObjectType.Issue
        }
        else if let _ = self as? Procedure {
            return ObjectType.Procedure
        }
        else if let _ = self as? Workpaper {
            return ObjectType.Workpaper
        }
        return ObjectType.None
    }
    
    // issues
    var issues : [Issue] {
        var issues = [Issue]()
        Services.getMyData(objectTypes: [.Issue], completed: { result in
            issues = (result?.issues.filter{ x in
                self.issueIds.contains(x.id!) })! })
        return issues
    }
    // workpapers
    var workpapers : [Workpaper] {
        var workpapers = [Workpaper]()
        Services.getMyData(objectTypes: [.Workpaper], completed: { result in
            workpapers = (result?.workpapers.filter{ x in
                self.workpaperIds.contains(x.id!) })! })
        return workpapers
    }
    
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
        return id < 0 || setDirtyFields.count > 0
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
                self.issueIds.append(issue.id!)
                return true
            }
        }
        else if let workpaper = child as? Workpaper {
            if !self.workpaperIds.contains(workpaper.id!) {
                self.workpaperIds.append(workpaper.id!)
                return true
            }
        }
        else {
            fatalError("not handling child of type \(child.className)")
        }
        return false
    }
    
    func getChildren(objectType : ObjectType) -> [BaseObject]? {
        switch objectType {
        case .Issue:
            return issues
        case .Workpaper:
            return workpapers
        default:
            return nil
        }
    }
    
    var changes : [Change]?
}

