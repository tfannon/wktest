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
    
    required override init() {
    }
    
    class func create<T : BaseObject>(parent: BaseObject) -> T {
        let o = T()
        o.id = Application.getNewId()
        o.parentType = parent.objectType.rawValue
        o.parentTitle = parent.title
        o.workflowState = WorkflowState.NotStarted.rawValue
        return o
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
    var title: String? {
        didSet {
            setDirty("Title")
        }
    }
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
    
    // only go looking for a realized child if there are ids
    // issues
    var issues : [Issue] {
        let local = Services.loadObjects([.Issue], explicitIds: self.issueIds)!
        print ("\t\(local.issues.count) child issues")
        return local.issues
    }
    // workpapers
    var workpapers : [Workpaper] {
        let local = Services.loadObjects([.Workpaper], explicitIds: self.workpaperIds)!
        print ("\t\(local.workpapers.count) child workpapers")
        return local.workpapers
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
    
    func isDirty(field : String? = nil) -> Bool{
        if let f = field {
            return setDirtyFields.contains(f)
        } else {
            return id < 0 || setDirtyFields.count > 0
        }
    }
    
    //todo: can we merge this into isDirty?
    var hasNewChildren : Bool {
        return issueIds.any { $0 < 0 } || workpaperIds.any { $0 < 0 }
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
    
    func isChild(child : BaseObject) -> Bool {
        if let issue = child as? Issue {
            return self.issueIds.contains(issue.id!)
        }
        else if let workpaper = child as? Workpaper {
            return self.workpaperIds.contains(workpaper.id!)
        }
        else {
            fatalError("not handling child of type \(child.className)")
        }
        return false
    }
    
    func addChild(child : BaseObject) -> Bool {
        if !self.isChild(child) {
            if let issue = child as? Issue {
                self.issueIds.append(issue.id!)
            }
            else if let workpaper = child as? Workpaper {
                self.workpaperIds.append(workpaper.id!)
            }
            return true
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

