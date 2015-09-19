//
//  PushHelper.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/14/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//
import Foundation

class PushHelper {
    static func tokenToString(data: NSData) -> String {
        let tokenChars = UnsafePointer<CChar>(data.bytes)
        var tokenString = ""
        
        for var i = 0; i < data.length; i++ {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("tokenString: \(tokenString)")
        return tokenString
    }
}
