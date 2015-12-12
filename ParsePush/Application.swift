//
//  Application.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/11/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class Application {
    
    private static let newIdForObjectsKey = "Application.newIdForObjectsKey"
    private static let lockQueue = dispatch_queue_create("Application.getNewId", nil)
    
    //MARK: Singleton
    // using a singleton ensures tread safety - only one is created
    // so everything in the init() of the singleton is only executed once
    static private let singleton = _Singleton()
    
    private class _Singleton {
        private(set) var formatterForDouble : NSNumberFormatter
        init() {
            formatterForDouble = NSNumberFormatter()
            formatterForDouble.numberStyle = .DecimalStyle
            formatterForDouble.maximumFractionDigits = 4
            formatterForDouble.maximumIntegerDigits = 10
        }
    }
    
    // MARK: Public properties/functions
    static var formatterForDouble : NSNumberFormatter { return singleton.formatterForDouble }

    static func getNewId() -> Int {
        var value = -1
        dispatch_sync(lockQueue) {
            if let current = NSUserDefaults.standardUserDefaults().valueForKey(newIdForObjectsKey) as? Int {
                value  = current - 1
            }
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: newIdForObjectsKey)
        }
        return value
    }
}