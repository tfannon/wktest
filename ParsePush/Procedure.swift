//
//  Procedure.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Procedure : Mappable, CustomDebugStringConvertible {
    required init(_ map: Map){}
    
    var id: Int?
    var title: String?
    var code: String?
    var text1: Int?
    var text2: Int?
    var text3: Int?

    func mapping(map: Map) {
        id <- map["Id"]
        title <- map["Title"]
        code <- map["Code"]
        text1 <- map["Text1"]
        text2 <- map["Text2"]
        text3 <- map["Text3"]
    }
    
    var debugDescription: String {
        return "\(title!)"
    }
}
