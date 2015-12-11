//
//  Application.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/11/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class Application {
    
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
    
    static var formatterForDouble : NSNumberFormatter { return singleton.formatterForDouble }
}