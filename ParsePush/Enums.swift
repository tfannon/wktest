//
//  Objects.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/5/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

protocol ImageProvider {
    var imageName: String { get }
}


enum ObjectType: Int, ImageProvider {
    case Risk = 45
    case Control = 46
    case Procedure = 48
    case Entity = 36
    
    var imageName: String {
        get {
            switch self {
            case .Risk: return "icons_risk"
            case .Control: return  "icons_control"
            case .Procedure: return "icons_procedure"
            case .Entity: return "icons_assessment"
            }
        }
    }
}


enum DocumentType: String, ImageProvider {
    case Word = "doc"
    case WordX = "docx"
    case Excel = "xls"
    case ExcelX = "xlsx"
    case PDF = "pdf"
    case Powerpoint = "ppt"
    case PowerpointX = "pptx"
    case ImageJpg = "jpg"
    case ImagePng = "png"
    
    var imageName: String {
        get {
            switch self {
            case .Word, .WordX: return "icons_word"
            case .Excel, .ExcelX: return  "icons_excel"
            case .Powerpoint, .PowerpointX: return "icons_powerpoint"
            case .PDF: return  "icons_pdf"
            case .ImageJpg, .ImagePng: return "icons_image_file"
            }
        }
    }
}



enum SyncState: Int {
    case Unchanged = 0
    case Dirty = 1
    case New = 2
    case Modified = 3

    var displayName: String {
        get {
            switch(self) {
            case Unchanged: return "Unchanged"
            case Dirty: return "Dirty"
            case New: return "New"
            case Modified: return "Changed"
            }
        }
    }
}


enum NotificationType: Int {
    case Assignment = 2
    case Workflow = 1
}

enum TestResults: Int {
    case NotTested = 0
    case Pass = 1
    case Fail = 2
 
    static let displayNames = Array(lookup
        .sort{ (first, second) in first.0.rawValue < second.0.rawValue }
        .map{ x in x.1 })
    private static var displayNameLookup = [String : TestResults]()

    private static let lookup : [TestResults : String] =
    [
        .NotTested:"Not Tested",
        .Pass:"Pass",
        .Fail:"Fail",
    ]

    static func getFilteredDisplayNames(included : [Int]?) -> [String]
    {
        if (included == nil)
        {
            return [String]()
        }
        
        let includedNames = Array(included!.map { x in TestResults(rawValue: x)!.displayName })
        return Array(displayNames.filter { x in includedNames.contains(x) })
    }
    
    static func getFromDisplayName(displayName : String) -> TestResults
    {
        // populate the lookup for display name if it's not already populated
        if (displayNameLookup.count == 0)
        {
            for i in lookup
            {
                displayNameLookup[i.1] = i.0
            }
        }
        
        return displayNameLookup[displayName]!
    }
    
    
    var displayName : String {
        get
        {
            return TestResults.lookup[self]!
        }
    }
    
}

enum WorkflowState: Int, ImageProvider {
    
    case NotStarted = 1
    case InProgress = 2
    case Completed = 3
    case Implemented = 4
    case Reviewed = 5
    case Closed = 6
    case Responded = 7
    case Issued = 8
    
    private static let lookup : [WorkflowState : (imageName : String, displayName : String)] =
    [
        .NotStarted:("icons_notstarted", "Not Started"),
        .InProgress:("icons_inprogress", "In Progress"),
        .Completed:("icons_completed", "Completed"),
        .Implemented:("icons_implemented", "Implemented"),
        .Reviewed:("icons_reviewed", "Reviewed"),
        .Closed:("icons_closed", "Closed"),
        .Responded:("icons_responded", "Responded"),
        .Issued:("icons_issued", "Issued"),
    ]
    
    private static var displayNameLookup = [String : WorkflowState]()

    static func getFilteredDisplayNames(included : [Int]?, current : Int?) -> [String]
    {
        if (included == nil)
        {
            return [String]()
        }
        
        let includedNames = Array(included!
            .filter{ x in current == nil || x != current }
            .map { x in WorkflowState(rawValue: x)!.displayName })

        return Array(displayNames.filter { x in includedNames.contains(x) })
    }
    
    static let displayNames = Array(lookup
        .sort{ (first, second) in first.0.rawValue < second.0.rawValue }
        .map{ x in x.1.displayName })
    
    static func getFromDisplayName(displayName : String) -> WorkflowState
    {
        // populate the lookup for display name if it's not already populated
        if (displayNameLookup.count == 0)
        {
            for i in lookup
            {
                displayNameLookup[i.1.displayName] = i.0
            }
        }
        
        return displayNameLookup[displayName]!
    }
    
    var imageName : String {
        get
        {
            return WorkflowState.lookup[self]!.imageName
        }
    }
    
    var displayName : String {
        get
        {
            return WorkflowState.lookup[self]!.displayName
        }
    }
    

}

enum SecurityRole {
    case Administrator
    case SystemAdministrator
    case AssessmentManager
    case ComplianceUser
    case TestManager
    case Observer
    case BusinessContact
    case Owner
    case BusinessReviewer
    case TestReviewer
    case TeamStoreGet
    case Reviewer
    case Tester
    case Manager
    case Recipient
}