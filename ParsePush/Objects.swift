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

enum NotificationType {
    case Assignment
    case Workflow
}

enum WorkflowState {
    case NotStarted
    case InProgress
    case Completed
    case Implemented
    case Reviewed
    case Closed
    case Responded
    case Issued
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