//
//  MyObjectsContainer.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/15/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjectContainer : Mappable {

    required init(_ map: Map) {
    }
    
    init(procedures: [Procedure], workpapers: [Workpaper], issues: [Issue]) {
        self.procedures = procedures
        self.workpapers = workpapers
        self.issues = issues
    }
    
    var procedures = [Procedure]()
    var workpapers = [Workpaper]()
    var issues = [Issue]()
    
    func mapping(map: Map) {
        procedures <- map["Procedures"]
        workpapers <- map["Workpapers"]
        issues <- map["Issues"]
    }
}