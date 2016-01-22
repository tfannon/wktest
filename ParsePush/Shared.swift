//
//  Constants.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/9/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

//this file is shared with FileProvider.  It cannot reference anything file provider cannot reference
//keep things private unless you know it has to be shared.  this will minimize breakages and dependencies later
public class Shared {
    static var appGroupName = "group.com.crazy8dev.ParsePush"

    private static var dirtyDocumentUrlKey = "dirtyDocumentUrlKey"
    
    private static var appGroupDefaults: NSUserDefaults {
        return NSUserDefaults.init(suiteName: appGroupName)!
    }
    
    static func markDocumentDirty(documentUrl: NSURL) {
        if appGroupDefaults.objectForKey(dirtyDocumentUrlKey) == nil {
            print("creating \(dirtyDocumentUrlKey) entry")
            appGroupDefaults.setObject([String:String](), forKey: dirtyDocumentUrlKey)
        }
        let pathKey = documentUrl.path!
        var dict = appGroupDefaults.objectForKey(dirtyDocumentUrlKey) as! [String:String]
        dict[pathKey] = pathKey
        print ("File marked as dirty: \(documentUrl.path!)")
    }
}

public class WorkpaperShared {
    
    var id: Int?
    var code: String?
    var parentTitle: String?
    var parentType: Int = 0
    var title: String?
    var workflowState: Int = 1
    var readOnly  : Bool?
    var oDescription: String?
    var dueDate: NSDate?
    var reviewDueDate: NSDate?
    var manager: String = ""
    var reviewer: String = ""
    var attachmentId: Int = 0
    var attachmentTitle: String?
    var attachmentExtension: String?
    var attachmentSize: Int64 = 0
    var documentType : DocumentType?
}


protocol ImageProvider {
    var imageName: String { get }
}

enum DocumentType: String, ImageProvider {
    case Word = "doc"
    case WordX = "docx"
    case Excel = "xls"
    case ExcelX = "xlsx"
    case PDF = "pdf"
    case Powerpoint = "ppt"
    case PowerpointX = "pptx"
    case ImageJpg = "jpg"
    case ImagePng = "png"
    
    var imageName: String {
        get {
            switch self {
            case .Word, .WordX: return "icons_word"
            case .Excel, .ExcelX: return  "icons_excel"
            case .Powerpoint, .PowerpointX: return "icons_powerpoint"
            case .PDF: return  "icons_pdf"
            case .ImageJpg, .ImagePng: return "icons_image"
            }
        }
    }
}