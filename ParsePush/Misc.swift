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
    
    // Works around a bug in Swift where pushing the ViewController the normal way
    //  doesn't initialize the cell templates in a UITableView
    static func getViewController<T : UIViewController>(
        storyboardName : String,
        viewIdentifier: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(viewIdentifier) as! T
        return vc
    }
    
    static func random<T>(array : Array<T>) -> T {
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }

    enum CustomError : ErrorType {
        case DevelopmentError(String)
    }

    static func throwDevError(message : String) throws {
        throw CustomError.DevelopmentError(message)
    }
}

class ClassName<T: AnyObject> {
    var name : String {
        let fullName: String = NSStringFromClass(T.self)
        let range = fullName.rangeOfString(".", options: .BackwardsSearch)
        if let range = range {
            return fullName.substringFromIndex(range.endIndex)
        } else {
            return fullName
        }
    }
}

