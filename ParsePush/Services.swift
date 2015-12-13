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
    static var userName = "joe.tester"
    static var deviceToken = ""
    static var mock = false

    static var appGroupStorageDirectory = "File Provider Storage"
    
    internal static func initializeServices() {
        
        //grab the default ipaddress from last used
        let defaults = NSUserDefaults.standardUserDefaults()
        if let ipAddress = defaults.objectForKey("ipAddress") as? String {
            Services.ipAddress = ipAddress
        }
        if let userName = defaults.objectForKey("userName") as? String {
            Services.userName = userName
        }
        if let mock = defaults.objectForKey("mock") as? Bool {
            Services.mock = mock
        }
    
    }
    
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
        return "http://\(Services.ipAddress)/Offline/api/Offline"
    }
    
    static var headers: [String:String] {
        let headers = ["UserName":Services.userName]
        return headers
    }
    
    static var storageProviderLocation: NSURL {
        let appGroupUrl = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(Shared.appGroupName)!
        return appGroupUrl.URLByAppendingPathComponent(appGroupStorageDirectory)
    }
    
    static var appGroupDefaults: NSUserDefaults {
        return NSUserDefaults.init(suiteName: Shared.appGroupName)!
    }
    
    //MARK:  Assessments
    static func getPOCAssessmentId(completed: (result: Int?)->()) {
        Alamofire.request(.GET, procedureUrl + "/GetPOCAssessmentId", parameters: nil, headers:Services.headers, encoding: .JSON)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    let result = data as? Int
                    completed(result: result)
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                    completed(result: nil)
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
    
    //MARK: Business Objects
    enum FetchOptions {
        case Default
        case ForceRefresh
        case LocalOnly
    }
    
    static func getMyData(
        fetchOptions: FetchOptions = .Default,
        objectTypes: [ObjectType]? = nil,
        explicitIds: [Int]? = nil,
        completed: (container: ObjectContainer?)->()) {
        print(__FUNCTION__)

        if (mock) {
            Mock.initialize()
        }
        
        //this is to test local store without going to server
        if fetchOptions == .LocalOnly {
            if let container: ObjectContainer = loadObjects(objectTypes, explicitIds: explicitIds) {
                print("\tfetched \(container) using local store")
            }
            return
        }
        //this is the default which is to check the local store first
        if fetchOptions == .Default {
            if let container: ObjectContainer = loadObjects(objectTypes, explicitIds: explicitIds) {
                print("\tfetched \(container) using local store")
                completed(container: container)
                return
            }
        }
        //if the store had nothing or we force a refresh fetch from services
        Alamofire.request(.GET, procedureUrl + "/GetMyObjects", headers:Services.headers, parameters: nil, encoding: .JSON)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    let jsonAlamo = data as? [String:AnyObject]
                    if let objects = Mapper<ObjectContainer>().map(jsonAlamo) {
                        print("\tfetched objects using web service")
                        saveObjects(objects)
                        completed(container: objects)
                    }
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    //MARK: Sync
    //grab the dirty procedures from the local store and send them to server
    static func sync(completed: (result: ObjectContainer?)->()) {
        print(__FUNCTION__)
        getMyData() { result in
            let objects = ObjectContainer()
            objects.procedures = (result?.procedures.filter { $0.isDirty() == true || $0.hasNewChildren })!
            objects.issues = (result?.issues.filter { $0.isDirty() == true || $0.hasNewChildren })!
            sendDataToServer(objects) {
                completed(result:$0)
            }
        }
    }
    
    private static func sendDataToServer(dirty: ObjectContainer, completed: (result: ObjectContainer?)->()) {
        print(__FUNCTION__)
        
        let request = NSMutableURLRequest(URL: NSURL(string:  procedureUrl + "/Sync")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let json = Mapper().toJSONArray(dirty)
        let json = Mapper().toJSON(dirty)
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        request.addValue(Services.headers["UserName"]!, forHTTPHeaderField: "UserName")
        Alamofire.request(request)
            .responseJSON { request, response, result in
                switch result {
                case .Success(let data):
                    if let jsonAlamo = data as? [String:AnyObject],
                           server = Mapper<ObjectContainer>().map(jsonAlamo),
                           local = loadObjects() {
                            
                        checkObjectState(dirty.procedures,  local: local.procedures, server: server.procedures)
                        checkObjectState(dirty.issues,      local: local.issues,     server: server.issues)
                        checkObjectState(dirty.workpapers,  local: local.workpapers, server: server.workpapers)
                        
                        saveObjects(server)
                        
                        completed(result: server)
                    } else {
                        print("\(__FUNCTION__) something went wrong with response or loading local objects")
                    }
                case .Failure(_, let error):
                    print("Request failed with error: \(error)")
                    completed(result: nil)
                }
        }
    }
    
    
    private static func checkObjectState<T: BaseObject>(dirty: [T], local: [T], server: [T]) {
        var localNotDirty = [T]()
        local.each { l in
            if dirty.indexOf ({ $0.id == l.id })  == nil {
                localNotDirty.append(l)
            }
        }
        print("\t\(T.self)")
        print("\t\tlocal:\(local.count), \(dirty.count) dirty  \(localNotDirty.count) not dirty")

        server.each { p in
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
        print ("\t\tserver:\(server.count), \(server.filter({ $0.syncState == .New }).count) new, \(server.filter({ $0.syncState == .Modified }).count) modified")
    }
    
    //MARK: Store - private
    enum DataKey : String {
        case ProcedureIds = "procedureIds"
        case WorkpaperIds = "workpaperIds"
        case IssueIds = "issueIds"
        case AttachmentIds = "attachmentIds"
        //cant be fullname or it conflicts with class definitions
        case Proc = "procedure:"
        case Iss = "issue:"
        case Wp = "workpaper:"
        case Att = "attachment:"
        
        static func getKeyForIdList(obj: [BaseObject]) -> String {
            if obj is [Procedure] {
                return DataKey.ProcedureIds.rawValue
            }
            else if obj is [Issue] {
                return DataKey.IssueIds.rawValue
            }
            else if obj is [Workpaper] {
                return DataKey.WorkpaperIds.rawValue
            }
            else if obj is [Attachment] {
                return DataKey.AttachmentIds.rawValue
            }
            else {
                assertionFailure("no key defined for \(obj)")
            }
            return ""
        }
        
        static func getKeyForObject(obj: BaseObject) -> String {
            if obj is Procedure {
                return getProcKey(obj.id!)
            }
            else if obj is Issue {
                return getIssueKey(obj.id!)
            }
            else if obj is Workpaper {
                return getWorkpaperKey(obj.id!)
            }
            else if obj is Attachment {
                return getAttachmentKey(obj.id!)
            }
            else {
                assertionFailure("no key defined for \(obj)")
            }
            return ""
        }

        static func getProcKey(id : Int) -> String {
            return "\(Proc.rawValue)\(id)"
        }
        static func getIssueKey(id : Int) -> String {
            return "\(Iss.rawValue)\(id)"
        }
        static func getWorkpaperKey(id : Int) -> String {
            return "\(Wp.rawValue)\(id)"
        }
        static func getAttachmentKey(id : Int) -> String {
            return "\(Att.rawValue)\(id)"
        }
    }

    static func getObject(baseObject : BaseObject) -> BaseObject? {
        switch baseObject.objectType {
        case .Issue:
            return getIssue(baseObject.id!)
        case .Workpaper:
            return getWorkpaper(baseObject.id!)
        default:
            return nil
        }
    }
    
    static func getIssue(id : Int) -> Issue? {
        if let issues: [Issue] = loadObjectsImpl() {
            return issues.filter { x in x.id == id }.first
        }
        return nil
    }
    
    static func getWorkpaper(id : Int) -> Workpaper? {
        if let workpapers: [Workpaper] = loadObjectsImpl() {
            return workpapers.filter { x in x.id == id }.first
        }
        return nil
    }

    //this is problematic in we have to remember to add each thing we store?
    static func clearStore() {
        print (__FUNCTION__)
        let defaults = NSUserDefaults.standardUserDefaults()
        let appGroupDefaults = Services.appGroupDefaults
        if let procIds = loadProcedureIds() {
            procIds.each { defaults.removeObjectForKey(DataKey.getProcKey($0)) }
            defaults.removeObjectForKey(DataKey.ProcedureIds.rawValue)
        }
        if let issueIds = loadIssueIds() {
            issueIds.each { defaults.removeObjectForKey(DataKey.getIssueKey($0)) }
            defaults.removeObjectForKey(DataKey.IssueIds.rawValue)
        }
        if let workpaperIds = loadWorkpaperIds() {
            workpaperIds.each { defaults.removeObjectForKey(DataKey.getWorkpaperKey($0)) }
            defaults.removeObjectForKey(DataKey.WorkpaperIds.rawValue)
        }
        
        if let attachmentIds = loadAttachmentIds() {
            attachmentIds.each { defaults.removeObjectForKey(DataKey.getAttachmentKey($0)) }
            defaults.removeObjectForKey(DataKey.AttachmentIds.rawValue)
        }
        
        //remove all preferences
        defaults.removeObjectForKey("procedureColumnPrefs")
        
        if let attachmentIds2 = appGroupDefaults.valueForKey(DataKey.AttachmentIds.rawValue) as? [Int] {
            //remove file paths
            attachmentIds2.each { appGroupDefaults.removeObjectForKey(DataKey.getAttachmentKey($0)) }
            defaults.removeObjectForKey(DataKey.AttachmentIds.rawValue)
        }
        //delete all the files in the storage directory as well
        FileHelper.deleteDirectory(storageProviderLocation)
    }

    /*
        procedureIds:[3,10] //array of ints
        procedure3:[Data]
        workpaperIds:[2,3,4] //array of ints
        workpaper2:[Data]
        attachmentIds:[5,10] //array of ints
        attachment5:[FilePath]
    */
    
    //MARK: save local store
    private static func saveObjects(objects: ObjectContainer) {
        print(__FUNCTION__)
        clearStore()
        saveObjectsImpl(objects.procedures)
        saveObjectsImpl(objects.workpapers)
        saveObjectsImpl(objects.issues)
        saveObjectsImpl(objects.attachments)
    }
    
    private static func saveObjectsImpl(objects: [BaseObject]) {
        if objects.count > 0 {
            print ("\tsaving \(objects.count) \(objects[0].dynamicType)s")
            let ids = objects.map { $0.id! }
            let idListKey = DataKey.getKeyForIdList(objects)
            NSUserDefaults.standardUserDefaults().setObject(ids, forKey: idListKey)
            objects.each { saveObject($0, log: objects is [Attachment]) }
        }
    }

    static func saveObject(obj: BaseObject, parent: BaseObject? = nil, log: Bool = false) {
        saveObjectImpl(obj, parent: parent, log: log, syncRedundantFieldsToChildren: true)
    }
    
    ///
    /// implementation of saveObject
    /// syncRedundantFieldsToChildren is used to tell the function whether to sync up the 
    ///     immediate childrens' redundant parent fields (e.g. parentTitle) if they are not a match
    ///     we only look to immediate children - we do not recurse down the entire tree
    ///     that's why syncRedundantFieldsToChildren defaults to false - it's only set to true
    ///     when saving the initial object in saveObject()
    ///
    private static func saveObjectImpl(
        obj: BaseObject,
        parent: BaseObject? = nil,
        log: Bool = false,
        syncRedundantFieldsToChildren : Bool = false)
    {
        // if we have a parent object - and obj
        // is not yet a child of the parent object,
        // set the child's redundant parent properties
        //  before we save it
        if let p = parent {
            if !p.isChild(obj) {
                obj.parentTitle = p.title
                obj.parentType = p.objectType.rawValue
            }
        } else if syncRedundantFieldsToChildren && obj.isDirty("Title") {
            // if this is an update to the obj and title is dirty
            // update any children whose parentTitle is not a match
            let children =
                (obj.issues.map { x in x as BaseObject }
                + obj.workpapers.map { x in x as BaseObject })
                    .filter { x in x.parentTitle != obj.title }
            for child in children {
                child.parentTitle = obj.title
                saveObjectImpl(child)
            }
        }
        
        //save it in its own slot.  will overwrite anything there
        let json = Mapper().toJSONString(obj, prettyPrint: true)
        let key = DataKey.getKeyForObject(obj)
        if log { print("Saving \(key) sizeof:\(json!.length) to local store") }
        NSUserDefaults.standardUserDefaults().setValue(json, forKey: key)
        
        // if there is a parent
        if let p = parent {
            // and it's actually a brand new child
            if p.addChild(obj) {
                // save the parent so that the parent's id list gets saved
                saveObjectImpl(p, log: true)
            }
        }

        // update the id lists to store
        var idListKey : String
        var ids = [Int]()
        if obj is Procedure {
            ids = loadProcedureIds() ?? [Int]()
            idListKey = DataKey.ProcedureIds.rawValue
        }
        else if obj is Issue {
            ids = loadIssueIds() ?? [Int]()
            idListKey = DataKey.IssueIds.rawValue
        }
        else if obj is Workpaper {
            ids = loadWorkpaperIds() ?? [Int]()
            idListKey = DataKey.WorkpaperIds.rawValue
        }
        else if let _ = obj as? Attachment {
            ids = loadAttachmentIds() ?? [Int]()
            idListKey = DataKey.AttachmentIds.rawValue
        }
        else {
            fatalError("save object not handled for \(obj.dynamicType)")
        }
        if !ids.contains(obj.id!) {
            ids.append(obj.id!)
            NSUserDefaults.standardUserDefaults().setObject(ids, forKey: idListKey)
        }
    }
    
    
    //MARK: load local store
    private static func loadObjects(objectTypes: [ObjectType]? = nil, explicitIds : [Int]? = nil) -> ObjectContainer? {
        print(__FUNCTION__)
        
        if let types = objectTypes {
            if types.count > 1 && explicitIds != nil {
                fatalError("can't ask for explicit ids for two or more types of objects")
            }
            
            var procedures = [Procedure]()
            var workpapers = [Workpaper]()
            var issues = [Issue]()
            if types.contains(.Procedure) {
                procedures = loadObjectsImpl(explicitIds) ?? [Procedure]()
            }
            if types.contains(.Workpaper) {
                workpapers = loadObjectsImpl(explicitIds) ?? [Workpaper]()
            }
            if types.contains(.Issue) {
                issues = loadObjectsImpl(explicitIds) ?? [Issue]()
            }
            return ObjectContainer(procedures: procedures, workpapers: workpapers, issues: issues)
        } else if let
            procedures:  [Procedure] = loadObjectsImpl(),
            workpapers:  [Workpaper] = loadObjectsImpl(),
            issues:      [Issue] =     loadObjectsImpl() {
            return ObjectContainer(procedures: procedures, workpapers: workpapers, issues: issues)
        }
        return nil
    }
    
    private static func loadObjectsImpl<T: Mappable>(explicitIds : [Int]? = nil) -> [T]? {
               let defaults = NSUserDefaults.standardUserDefaults()
        //may be empty
        var ids: [Int]?
        var keyFunc: ((Int)->(String))
        if T.self is Procedure.Type {
            ids = explicitIds ?? loadProcedureIds()
            keyFunc = DataKey.getProcKey
        }
        else if T.self is Workpaper.Type {
            ids = explicitIds ?? loadWorkpaperIds()
            keyFunc = DataKey.getWorkpaperKey
        }
        else if T.self is Issue.Type {
            ids = explicitIds ?? loadIssueIds()
            keyFunc = DataKey.getIssueKey
        }
        else {
            preconditionFailure("loadObjects not implemented for \(T.self)")
        }
        if ids != nil {
            return ids!.map {
                let key = keyFunc($0)
                let jsonProc = defaults.valueForKey(key) as! String
                return Mapper<T>().map(jsonProc)!
            }
        }
        return nil
    }

    
    
    //MARK: - Load,  All functions return nil if there is no local store data
    private static func loadProcedureIds() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DataKey.ProcedureIds.rawValue) as? [Int]
    }
    
    private static func loadWorkpaperIds() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DataKey.WorkpaperIds.rawValue) as? [Int]
    }
    
    private static func loadIssueIds() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DataKey.IssueIds.rawValue) as? [Int]
    }
    
    private static func loadAttachmentIds() -> [Int]? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DataKey.AttachmentIds.rawValue) as? [Int]
    }
    
    
    static func getAttachment(id: Int, completed: (String->())) {
        let key = DataKey.getAttachmentKey(id)
        if let destination = appGroupDefaults.valueForKey(key) as? String {
            print("Using cached file at:\(destination)")
            completed(destination)
            return
        }
        Alamofire.download(.GET, procedureUrl + "/GetAttachment/\(id)", headers:Services.headers) { temporaryURL, response in
            let destination = FileHelper.moveFile(temporaryURL, targetDirectoryUrl:self.storageProviderLocation, fileName: response.suggestedFilename!)
            print("Downloaded file was stored at: \(destination.path!)")
            //write this location into the app group defaults.
            appGroupDefaults.setValue(destination.path!, forKey: key)
            //grab the existing collection of attachment ids, create if non exist,  add if it does not contain
            var attachmentIds = appGroupDefaults.valueForKey(DataKey.AttachmentIds.rawValue) as? [Int] ?? [Int]()
            if attachmentIds.indexOf(id) == nil {
                attachmentIds.append(id)
            }
            appGroupDefaults.setValue(attachmentIds, forKey: DataKey.AttachmentIds.rawValue)
            completed(destination.path!)
            return destination
        }
    }
    
    //test only
    static func getAttachment(completed: (String->())) {
        Alamofire.download(.GET, procedureUrl + "/GetFile") { temporaryURL, response in
            let destination = FileHelper.moveFile(temporaryURL, targetDirectoryUrl: self.storageProviderLocation, fileName: response.suggestedFilename!, overwrite: true)
            print("Downloaded file was stored at: \(destination.path!)")
            completed(destination.path!)
            return destination
        }
    }
}