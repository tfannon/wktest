//
//  Objects.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/5/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

enum ObjectType: Int {
    case Risk = 45
    case Control = 46
    case Procedure = 48
    
    var imageName: String {
        get {
            switch self {
            case .Risk: return "icons_risk"
            case .Control: return  "icons_control"
            case .Procedure: return "icons_procedure"
            }
        }
    }
    
}

enum NotificationType: Int {
    case Assignment = 2
    case Workflow = 1
}

enum TestResultsType: Int {
    case NotTested = 0
    case Pass = 1
    case Fail = 2
 
    static let displayNames = Array(lookup
        .sort{ (first, second) in first.0.rawValue < second.0.rawValue }
        .map{ x in x.1 })

    private static let lookup : [TestResultsType : String] =
    [
        .NotTested:("Not Started"),
        .Pass:("In Progress"),
        .Fail:("Completed"),
    ]
    
    var displayName : String {
        get
        {
            return TestResultsType.lookup[self]!
        }
    }
    
}

enum WorkflowState: Int {
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
        .Implemented:("icons_notstarted", "Implemented"),
        .Reviewed:("icons_reviewed", "Reviewed"),
        .Closed:("icons_notstarted", "Closed"),
        .Responded:("icons_notstarted", "Responded"),
        .Issued:("icons_notstarted", "Issued"),
    ]
    
    static let displayNames = Array(lookup
        .sort{ (first, second) in first.0.rawValue < second.0.rawValue }
        .map{ x in x.1.displayName })
    
    static func getFromDisplayName(displayName : String) -> WorkflowState
    {
        let v = lookup
            .filter { x in x.1.displayName == displayName }
            .map { x in x.0 }
        
        return v[0]
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