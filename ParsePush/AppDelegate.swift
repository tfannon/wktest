//
//  AppDelegate.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

import Alamofire

//let ipStAug = "10.0.0.2"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings (settings)
        application.registerForRemoteNotifications()
        
     
        
//        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
//            .responseJSON { request, response, result in
//                print("GET: \(JSON(result.value!))")
//                //print(response)
//        }
//
//        Alamofire.request(.GET, url + "/1", parameters: nil, encoding: .JSON)
//            .responseJSON { request, response, result in
//                print("GET with ID: \(JSON(result.value!))")
//                //print(response)
//        }
//        
//
//        let dict = ["LoginName":"tommy", "DeviceToken":"FFF-AAA"]
//        Alamofire.request(.POST, url, parameters: dict, encoding: .JSON)
//            .responseJSON { request, response, result in
//                print("POST: \(JSON(result.value!))")
//                //print(JSON(response!))
//        }
//        
//        Alamofire.request(.PUT, url + "/1", parameters: dict, encoding: .JSON)
//            .responseJSON { request, response, result in
//                print(result.value)
//                print(response)
//        }
        
        
        
        //let jsonData = JSON(dict).arrayObject
//        do {
//            let post = try dict.rawData()
//            let postLength = String(post.length)
//            let req = NSMutableURLRequest(URL: NSURL(string: url)!)
//            req.HTTPMethod = "POST"
//            req.HTTPBody = post
//            req.setValue(postLength, forHTTPHeaderField: "Content-Length")
//            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            req.setValue("application/json", forHTTPHeaderField: "Accept")
//            
//            session.dataTaskWithRequest(req, completionHandler: {(data, response, error) in
//                print(data)
//                print(response)
//                print(error)
//            }).resume()
//            
//        }
//        catch {
//            
//        }
        
        
        

        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let installation = PFInstallation.currentInstallation()
//        installation.setDeviceTokenFromData(deviceToken)
//        installation.saveInBackground()

        // Create a reference to a Firebase location
//        let node = FirebaseHelper.Devices.childByAutoId()
//        let tokenString = PushHelper.tokenToString(deviceToken)
//        let vals = ["name":"joe.contact", "token":"\(tokenString)"]
//        node.updateChildValues(vals)
        
//        Services.login("joe.contact", token: deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //PFPush.handlePush(userInfo)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

