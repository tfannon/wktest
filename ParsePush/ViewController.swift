//
//  ViewController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var lblLoginResult: UILabel!
    @IBAction func loginPressed(sender: AnyObject) {
        Services.login("joe.contact", token: "foobar") { result in
            self.lblLoginResult.text = result
        }
    }
    
    
    @IBOutlet weak var lblCount: UILabel!
    @IBAction func countPressed(sender: AnyObject) {
        Services.getUnreadCount() { result in
            self.lblCount.text = String(result)
        }
    }
    
    
    @IBOutlet weak var txtNotifications: UITextView!
    @IBAction func getNotificationsPressed(sender: AnyObject) {
        Services.getUnreadNotifications() { result in
            for x in result! {
                print("\(x.title!): \(x.description!)")
            }
        }
    }
}

