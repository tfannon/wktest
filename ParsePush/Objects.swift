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
}

enum NotificationType: Int {
    case Assignment = 2
    case Workflow = 1
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