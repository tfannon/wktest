//
//  Misc.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/21/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class Misc {
    static func join<T : Equatable>(objs: [T], separator: String) -> String {
        return objs.reduce("") {
            sum, obj in
            let maybeSeparator = (obj == objs.last) ? "" : separator
            return "\(sum)\(obj)\(maybeSeparator)"
        }
    }
}
