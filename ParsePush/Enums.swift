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

enum TestResults: Int {
    case NotTested = 0
    case Pass = 1
    case Fail = 2
    var imageName: String {
        get {
            switch self {
            case .NotTested: return "icons_notstarted"
            case .Pass: return  "icons_inprogress"
            case .Fail: return "icons_completed"
            }
        }
    }
    var displayName: String {
        get {
            switch self {
            case .NotTested: return "Not Tested"
            case .Pass: return  "Pass"
            case .Fail: return "Fail"
            }
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
    
    var imageName: String {
        get {
            switch self {
            case .NotStarted: return "icons_notstarted"
            case .InProgress: return  "icons_inprogress"
            case .Completed: return "icons_completed"
            case .Reviewed: return "icons_reviewed"
            default: return "icons_notstarted"
            }
        }
    }
    
    var displayName: String {
        get {
            switch self {
            case .NotStarted: return "Not Started"
            case .InProgress: return  "In Progress"
            case .Completed: return "Completed"
            case .Reviewed: return "Reviewed"
            default: return "sir not appearing in this film"
            }
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