//
//  Issue.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/23/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Issue : BaseObject {
    static var term = [
        "manager":"Manager",
        "reviewer":"Reviewer",
        "createdUser":"Creator",
        "createdDate":"Created Date",
        "text1":"Finding",
        "text2":"Criteria",
        "text3":"Cause",
        "text4":"Effect",
        "text5":"Executive Summary",
        "workflowState":"State",
        "released":"Released",
    ]
    
    class func getTerminology(key: String) -> String {
        return term[key] ?? ""
    }
}
