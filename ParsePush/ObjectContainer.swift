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
    
    init(procedures: [Procedure], workpapers: [Workpaper]) {
        self.procedures = procedures
        self.workpapers = workpapers
    }
    
    var procedures = [Procedure]()
    var workpapers = [Workpaper]()
    
    func mapping(map: Map) {
        procedures <- map["Procedures"]
        workpapers <- map["Workpapers"]
    }
    
}