//
//  BaseObject.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/16/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

class BaseObject : NSObject, Mappable, CustomDebugStringConvertible {
    
    required init(_ map: Map) {
    }
    override init() {
    }
    
    var id: Int?
    
    func mapping(map: Map) {
    }
}

