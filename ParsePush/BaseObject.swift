//
//  BaseObject.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/16/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BusinessObject {
    //static var terminology : [String:[String:String]] { get }
    //class func populateTerminology()
}

class BaseObject : NSObject, Mappable, CustomDebugStringConvertible, BusinessObject {
    
    required init(_ map: Map) {
    }
    
    override init() {
    }
    
    var id: Int?
    var parentTitle: String?
    var parentType: Int = 0
    var title: String? { didSet { setDirty("Title") } }
    var workflowState: Int = 1 { didSet { setDirty("WorkflowState") } }
    var readOnly  : Bool?
    var allowedStates : [Int]?
    var lmg: String?
    var wasChangedOnServer : Bool?
    var syncState: SyncState = .Unchanged
    
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
    
    var changes : [Change]?
}

