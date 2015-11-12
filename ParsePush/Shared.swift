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