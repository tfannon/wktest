    //
    //  Services.swift
    //  ParsePush
    //
    //  Created by Tommy Fannon on 9/25/15.
    //  Copyright © 2015 Crazy8Dev. All rights reserved.
    //
    
    import Foundation
    import Alamofire
    import ObjectMapper
    
    
    public class Services {
        static var ipAddress = "192.168.1.14"
        static var assessmentId = "572301013"
        static var userName = "joe.tester"
        static var deviceToken = ""
        
        public static func setDeviceToken(token: NSData) {
            Services.deviceToken = tokenToString(token)
        }
        
        static var loginUrl: String {
            return "http://\(Services.ipAddress)/Offline/api/login"
        }
        
        static var notificationUrl: String {
            return "http://\(Services.ipAddress)/Offline/api/Notification"
        }
        
        static var procedureUrl: String {
            return "http://\(Services.ipAddress)/Offline/api/BO"
        }
        
        static var headers: [String:String] {
            let headers = ["UserName":Services.userName]
            return headers
        }
        
        
        
        public static func login(name: String, token: NSData, completed: (result: String?)->()) {
            return login(name, token: tokenToString(token), completed: completed)
        }
        
        static func login(name: String, token: String, completed: (result: String?)->()) {
            let dict = ["LoginName":name, "DeviceToken":token]
            Alamofire.request(.POST, loginUrl + "/PostLogin", parameters: dict, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let json = data as? String
                        completed(result: json)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                        completed(result: nil)
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
        
        static func getUnreadCount(completed: (result: Int)->()) {
            Alamofire.request(.GET, notificationUrl + "/GetUnreadCount", parameters: nil, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let json = data as? Int
                        //debugPrint(json)
                        completed(result: json!)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
            
        }
        
        static func getUnreadNotifications(completed: (result: [Notification]?)->()) {
            Alamofire.request(.GET, notificationUrl + "/Get", parameters: nil, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let jsonAlamo = data as? [[String:AnyObject]]
                        let result = jsonAlamo?.map { Mapper<Notification>().map($0)! }
                        result!.each { a in print(a) }
                        completed(result: result)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
            
        }
        
        
        static func markRead(ids: [Int], completed: (result: String)->()) {
            let dict = ["ids":ids]
            Alamofire.request(.POST, notificationUrl + "/MarkRead", parameters: dict, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let json = data as? String
                        print(json!)
                        completed(result: json!)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
        
        //MARK: procedure
        static func getMyProcedures(completed: (result: [Procedure]?)->()) {
            Alamofire.request(.GET, procedureUrl + "/GetMyProcedures", headers:Services.headers, parameters: nil, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let jsonAlamo = data as? [[String:AnyObject]]
                        let result = jsonAlamo?.map { Mapper<Procedure>().map($0)! }
                        //result!.each { a in print(a) }
                        completed(result: result)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
        
        
        static func GetPOCAssessmentId(completed: (result: Int?)->()) {
            Alamofire.request(.GET, procedureUrl + "/GetPOCAssessmentId", parameters: nil, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let result = data as? Int
                        completed(result: result)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
        
        static func GetProcedures(completed: (result: [Procedure]?)->()) {
            completed(result: Mock.getProcedures())
            
            //        Services.GetPOCAssessmentId { id in
            //            Alamofire.request(.GET, procedureUrl + "/GetProcedures/\(id!)", parameters: nil, encoding: .JSON)
            //            .responseJSON { request, response, result in
            //                switch result {
            //                case .Success(let data):
            //                    let jsonAlamo = data as? [[String:AnyObject]]
            //                    let result = jsonAlamo?.map { Mapper<Procedure>().map($0)! }
            //                    result!.each { a in print(a) }
            //                    completed(result: result)
            //                case .Failure(_, let error):
            //                    print("Request failed with error: \(error)")
            //                }
            //        }
            //    }
        }
        
    }