//
//  Services.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/25/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import Alamofire

let ipAddress = "192.168.1.16"
let url = "http://\(ipAddress)/Offline/api/login"


public class Services {
 
    public static func login(name: String, token: NSData) {
        return login(name, token: tokenToString(token))
    }
    
    public static func login(name: String, token: String) {
        let dict = ["LoginName":name, "DeviceToken":token]
        Alamofire.request(.POST, url, parameters: dict, encoding: .JSON)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
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