//
//  Workpaper.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/7/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

class Workpaper : BaseObject {
    
    //this syntax is to allow for a pseudo-c# like initializer
    init(initializer:((Workpaper)->Void)? = nil) {
        super.init()
        initializer?(self)
    }
    
    required init(_ map: Map) {
        super.init(map)
    }


    static var term = [
        "title":"Title",
        "description":"Description",
        "parentTitle":"Parent",
        "parentType":"Parent",
        "reviewer":"Reviewer",
        "manager":"Manager",
        "dueDate":"Due Date",
        "reviewDueDate":"Review Due Date",
        "workflowState":"State"]
    
    class func getTerminology(key: String) -> String {
        return term[key] ?? ""
    }
    
    var oDescription: String? { didSet { setDirty("Description") } }
    var dueDate: NSDate? { didSet { setDirty("DueDate") } }
    var reviewDueDate: NSDate? { didSet { setDirty("ReviewDueDate") } }
    var manager: String = ""
    var reviewer: String = ""
    var attachmentId: Int = 0
    var attachmentTitle: String?
    var attachmentExtension: String?
    var attachmentSize: Int64 = 0
    var documentType : DocumentType? {
        get {
            return DocumentType(rawValue: attachmentExtension ?? "")
        }
    }
    
    var attachmentData: NSData?
    
    override func mapping(map: Map) {
        super.mapping(map)
        
        oDescription <- map["Description"]
        manager <- map["Manager"]
        reviewer <- map["Reviewer"]
        attachmentId <- map["AttachmentId"]
        attachmentTitle <- map["AttachmentTitle"]
        attachmentExtension <- map["AttachmentExtension"]
        attachmentSize <- map["AttachmentSize"]
        
        attachmentData <- map["AttachmentData"]
        
        dueDate <- (map["DueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        reviewDueDate <- (map["ReviewDueDate"], TransformOf<NSDate, String>(
            fromJSON: { $0 != nil ? NSDate(fromString: $0!.substring(10), format:DateFormat.ISO8601(nil)) : nil },
            toJSON: { $0.map { $0.toIsoString() } }))
        
        attachmentData <- (map["AttachmentData"], TransformOf<NSData, String>(
            fromJSON: {  $0 != nil ? NSData.fromEncodedString($0!) : nil },
            toJSON: { $0.map { $0.getEncodedString()! }}))
        
        isMapping = false
    }
    
    
    
    override var description: String {
        return "\(title!) \(parentTitle) \(oDescription) \(dueDate) \(allowedStates)"
    }
}
