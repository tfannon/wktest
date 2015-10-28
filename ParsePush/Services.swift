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

protocol Saveable {
    
}
    
public class Services {
    static var ipAddress = "192.168.1.14"
    static var assessmentId = "572301013"
    static var userName = "joe.tester"
    static var deviceToken = ""
    static var mock = false
    
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
    
    //MARK:  Assessments
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
    

    //MARK:  Login
    static func login(name: String, token: NSData, completed: (result: String?)->()) {
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
    
    
    //MARK: Notifications
    
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
    
    //MARK: Procedures
    enum FetchOptions {
        case Default
        case ForceRefresh
        case LocalOnly
    }
    
    static func getMyProcedures(fetchOptions: FetchOptions = .Default, completed: (result: [Procedure]?)->()) {
        print(__FUNCTION__)
        if (mock) {
            completed(result: Mock.getProcedures())
        }
        else {
            if fetchOptions == .LocalOnly {
                completed(result: loadProcedures())
                return
            }
            //default is to check the local store first
            if fetchOptions == .Default {
                if let procedures = loadProcedures() {
                    completed(result: procedures)
                    return
                }
            }
            //if the store had nothing or we force a refresh fetch from services
            Alamofire.request(.GET, procedureUrl + "/GetMyProcedures", headers:Services.headers, parameters: nil, encoding: .JSON)
                .responseJSON { request, response, result in
                    switch result {
                    case .Success(let data):
                        let jsonAlamo = data as? [[String:AnyObject]]
                        let result = jsonAlamo?.map { Mapper<Procedure>().map($0)! }
                        //save it back to local store, erasing whatever was there
                        saveAll(result!)
                        completed(result: result)
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    }
            }
        }
    }
    
    //MARK: Sync
    //grab the dirty procedures from the local store and send them to server
    static func sync(completed: (result: [Procedure]?)->()) {
        print(__FUNCTION__)
        getMyProcedures(FetchOptions.LocalOnly) { procs in
            let dirty = procs?.filter { $0.isDirty() == true }
            saveProcedures(dirty!) {
                completed(result:$0)
            }
        }
    }
    
    private static func saveProcedures(dirty: [Procedure], completed: (result: [Procedure]?)->()) {
        print(__FUNCTION__)

        let request = NSMutableURLRequest(URL: NSURL(string:  procedureUrl + "/Sync")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = Mapper().toJSONArray(dirty)
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        request.addValue(Services.headers["UserName"]!, forHTTPHeaderField: "UserName")
        Alamofire.request(request)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    let jsonAlamo = data as? [[String:AnyObject]]

                    let server = jsonAlamo?.map { Mapper<Procedure>().map($0)! }
                    let local = loadProcedures()!

                    //replace this shit with a map
                    var localNotDirty = [Procedure]()
                    local.each { l in
                        if dirty.indexOf ({ $0.id == l.id })  == nil {
                            localNotDirty.append(l)
                        }
                    }
                    print ("local not dirty")
                    localNotDirty.each {
                        print($0.id)
                    }

                    //compare results to local store. 
                    server!.each { p in
                        //if not found in local store, it is new
                        if local.indexOf({$0.id == p.id}) == nil {
                            p.syncState = .New
                        }
                        else {
                            //otherwise if it is one of the ones i sent down, check the server flag
                            if dirty.indexOf ({ $0.id == p.id }) != nil {
                                p.syncState = p.wasChangedOnServer! ? .Modified : .Unchanged
                            }
                            //otherwise if my guid != match the server guid, it is dirty
                            else {
                                let i = localNotDirty.indexOf({$0.id == p.id})!
                                let l = localNotDirty[i]
                                p.syncState = l.lmg != p.lmg ? .Modified : .Unchanged
                            }
                        }
                    }
                    print ("\(server!.filter { $0.syncState != .Unchanged }.count) new or modified")

                    
                    saveAll(server!)
                    
                    completed(result: server!)
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                    completed(result: nil)
                }
        }
    }
    
    

    //MARK: Save local
    static func save(obj: Procedure, persistKey: Bool = false) {
        //print(__FUNCTION__)
        let procJson = Mapper().toJSONString(obj, prettyPrint: true)!
        let defaults = NSUserDefaults.standardUserDefaults()
        //save it in its own slot.  will overwrite anything there
        let key = DataKey.getProcKey(obj.id!)
        //print("Saving \(key) to local store")
        defaults.setValue(procJson, forKey: key)
        //if its coming from the load from services, all keys need to be persisted
        if persistKey {
            if let ids = loadIds()
                where ids.indexOf(obj.id!) == nil {
                    var newIds = ids
                    newIds.append(obj.id!)
                    defaults.setObject(newIds, forKey: DataKey.ProcedureIds.rawValue)
            } else {
                //make a new id collection and put it in the store
                defaults.setObject([obj.id!], forKey: DataKey.ProcedureIds.rawValue)
            }
        }
    }
    
 
    //MARK: Store - private
    enum DataKey : String {
        case ProcedureIds = "procIds"
        case Proc = "proc:"
        static func getProcKey(id : Int) -> String {
            return "\(Proc.rawValue)\(id)"
        }
    }
    
    static func clearStore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(DataKey.ProcedureIds.rawValue)
        defaults.removeObjectForKey(DataKey.Proc.rawValue)
        defaults.synchronize()
    }
    
    private static func saveAll(objects: [Procedure]) {
        print(__FUNCTION__)
        clearStore()
        let ids = objects.map { $0.id! }
        NSUserDefaults.standardUserDefaults().setObject(ids, forKey: DataKey.ProcedureIds.rawValue)
        //write them all in but we have already saved the keys so skip that
        objects.each { save($0, persistKey: false) }
    }
    
    
    //may be empty
    private static func loadIds() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DataKey.ProcedureIds.rawValue) as? [Int]
    }
    
    //may be empty
    private static func loadProcedures() -> [Procedure]? {
        print(__FUNCTION__)
        let defaults = NSUserDefaults.standardUserDefaults()
        //may be empty
        if let ids = loadIds() {
            return ids.map { id in
                let key = DataKey.getProcKey(id)
                let jsonProc = defaults.valueForKey(key) as! String
                return Mapper<Procedure>().map(jsonProc)!
            }
        }
        return nil
    }
}