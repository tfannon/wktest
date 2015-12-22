//
//  FileHelper.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/9/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class FileHelper {
    //return the url of the location where it was stored.
    static func moveFile(sourceUrl: NSURL, targetDirectoryUrl: NSURL, fileName : String, overwrite: Bool = false) -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        var tmpName = targetDirectoryUrl.URLByAppendingPathComponent(fileName).path!
        try! NSFileManager.defaultManager().createDirectoryAtURL(targetDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
        let fileExists = fileManager.fileExistsAtPath(tmpName)
        if overwrite {
            if fileExists {
                try! fileManager.removeItemAtPath(tmpName)
            }
        } else {
            if fileExists {
                var i = 2
                repeat {
                    tmpName = targetDirectoryUrl.URLByAppendingPathComponent("\(i++)_\(fileName)").path!
                }
                while fileManager.fileExistsAtPath(tmpName)
            }
        }
        try! fileManager.moveItemAtPath(sourceUrl.path!, toPath: tmpName)
        //try! print(fileManager.attributesOfItemAtPath(tmpName))
        return NSURL(fileURLWithPath: tmpName)
    }
    
    static func deleteFile(sourceUrl: NSURL) {
        let path = sourceUrl.path!
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path) {
            try! fileManager.removeItemAtPath(path)
        }
    }
    
    static func deleteDirectory(directoryUrl: NSURL) {
        let fileManager = NSFileManager.defaultManager()
        let enumerator = fileManager.enumeratorAtPath(directoryUrl.path!)
        
        while let file = enumerator?.nextObject() as? String {
            try! fileManager.removeItemAtURL(directoryUrl.URLByAppendingPathComponent(file))
        }
    }
    
    static var documentsDirectory: NSURL {
        return try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
    static func getUrlUsingDocumentsDirectory(fileName: String) -> NSURL {
        let url = documentsDirectory
        return url.URLByAppendingPathComponent(fileName)
    }
}