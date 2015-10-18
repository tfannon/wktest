//
//  ViewController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class TestController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        txtIPAddress.delegate = self
        txtIPAddress.text = Services.ipAddress
        
        txtUserName.delegate = self
        txtUserName.text = Services.userName
    }
    
    //MARK - view controller

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Outlets
    @IBOutlet weak var txtIPAddress: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgLoginResult: UIImageView!
    @IBOutlet weak var lblAssessment: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblProcedures: UILabel!
    @IBOutlet weak var lblNotifications: UILabel!
    
    //MARK - Actions



    @IBAction func countPressed(sender: AnyObject) {
        Services.getUnreadCount() { result in
            self.lblCount.text = String(result)
        }
    }
    
    @IBAction func markReadPressed(sender: AnyObject) {
        Services.markRead([2,3]) { result in
        }
    }
   

    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        var key = ""
        if (textField == self.txtIPAddress) {
            Services.ipAddress = textField.text!
            key = "ipAddress"
        }
        else if (textField == self.txtUserName) {
            self.imgLoginResult.hidden = false
            Services.userName = textField.text!
            key == "userName"
            Services.login(Services.userName, token: "foobar") { result in
                let imageName = result != nil ? "icons_implemented" : "icons_issue"
                self.imgLoginResult.image = UIImage(named: imageName)
            }
        }
        defaults.setObject(textField.text!, forKey: key)
        defaults.synchronize()
        textField.resignFirstResponder();
        return true;
    }
    
    
    @IBAction func getNotificationsPressed(sender: AnyObject) {
        self.lblNotifications.text = ""
        Services.getUnreadNotifications() { result in
            for x in result! {
                print("\(x.title!): \(x.description!)")
            }
            self.lblNotifications.text = "\(result!.count) received"
        }
    }


    @IBAction func assessmentPressed(sender: AnyObject) {
        self.lblAssessment.text = ""
        Services.GetPOCAssessmentId { id in
            self.lblAssessment.text = String(id!)
        }
    }
    

    @IBAction func proceduresPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.GetProcedures { result in
            self.lblProcedures.text = String(result!.count)
        }
    }
    
}

