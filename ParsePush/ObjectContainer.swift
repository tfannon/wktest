//
//  MyObjectsContainer.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/15/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjectContainer : Mappable, CustomStringConvertible {

    required init(_ map: Map) {
    }
    
    init() {
    }
    
    init(procedures: [Procedure], workpapers: [Workpaper], issues: [Issue]) {
        self.procedures = procedures
        self.workpapers = workpapers
        self.issues = issues
    }
    
    convenience init(procedures: [Procedure], workpapers: [Workpaper], issues: [Issue], attachments: [Attachment]) {
        self.init(procedures: procedures, workpapers: workpapers, issues: issues)
        self.attachments = attachments
    }
    
    
    var procedures = [Procedure]()
    var workpapers = [Workpaper]()
    var issues = [Issue]()
    var attachments = [Attachment]()
    
    func mapping(map: Map) {
        procedures <- map["Procedures"]
        workpapers <- map["Workpapers"]
        issues <- map["Issues"]
        attachments <- map["Attachments"]
    }
    
    var description: String {
        return ("\(procedures.count) procs, \(workpapers.count) workpapers, \(issues.count) issues  \(attachments.count)")
    }
}