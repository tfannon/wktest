//
//  NSDateExtensions.swift
//  LiftTracker
//
//  Created by Tommy Fannon on 7/20/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import Foundation

extension NSDate {
    func toIsoString() -> String {
        let s = self.toString(format: DateFormat.ISO8601(.Date))
        let index = s.startIndex.advancedBy(10)
        return s.substringToIndex(index)
    }
    
    func toShortString() -> String {
        return self.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle, doesRelativeDateFormatting: false)
    }
    
//    convenience init(isoString : String) {
//        //let stringWithTime = isoString + "T00:00:00-05:00"
//        let stringWithTime = isoString + "-05:00"        
//        self.init(fromString: stringWithTime, format: DateFormat.ISO8601(.Date))
//    }
    
}