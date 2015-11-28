//
//  TestController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import ObjectMapper


class TestController: UIViewController, UITextFieldDelegate, UIDocumentInteractionControllerDelegate, WorkpaperChooserDelegate {

    //MARK: - WorkpaperChooserDelegate
    var procedure: Procedure?
    var owningObject: Procedure { return procedure! }
    var owningViewController: UIViewController  { return self }
    

    //MARK: - view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        txtIPAddress.delegate = self
        txtIPAddress.text = Services.ipAddress
        
        txtUserName.delegate = self
        txtUserName.text = Services.userName
        
        segMockMode.selectedSegmentIndex = (Services.mock) ? 1 : 0
        //clear text fields
        self.lblSync.text = ""
        self.lblProcedures.text = ""
        self.lblNotifications.text = ""
        self.lblCount.text = ""
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var txtIPAddress: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var imgLoginResult: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblProcedures: UILabel!
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var segMockMode: UISegmentedControl!
    @IBOutlet weak var imgIPAddressResult: UIImageView!
    @IBOutlet weak var lblSync: UILabel!
    
    //MARK: - Connection options
    @IBAction func segMockModeChanged(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        Services.mock = sender.selectedSegmentIndex == 1
        defaults.setBool(Services.mock, forKey: "mock")
        defaults.synchronize()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        var key = ""
        let value = textField.text!
        
        if textField == self.txtIPAddress {
            self.imgIPAddressResult.hidden = true
            //set the ip address and make sure it works by making a simple call
            Services.ipAddress = value
            Services.getPOCAssessmentId() { result in
                self.imgIPAddressResult.hidden = false
                let imageName = result != nil ? "icons_implemented" : "icons_issue"
                self.imgIPAddressResult.image = UIImage(named: imageName)
            }
            key = "ipAddress"
        }
        else if textField == self.txtUserName {
            self.imgLoginResult.hidden = true
            Services.userName = value
            Services.login(Services.userName, token: "foobar") { result in
                self.imgLoginResult.hidden = false
                let imageName = result != nil ? "icons_implemented" : "icons_issue"
                self.imgLoginResult.image = UIImage(named: imageName)
            }
            key = "userName"
        }
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func miscPressed(sender: UIButton) {
        print ("test out some func here")
    }
    
 
      //MARK: - Notifications
    @IBAction func countPressed(sender: AnyObject) {
        Services.getUnreadCount() { result in
            self.lblCount.text = String(result)
        }
    }
    
    @IBAction func markReadPressed(sender: AnyObject) {
        Services.markRead([2,3]) { result in
        }
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
    
    //MARK: - Procedures
    @IBAction func editProcedurePressed(sender: AnyObject) {
        let vc = ProcedureFormController(procedure: Mock.getProcedures()[0])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func readLocalPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.getMyData(.LocalOnly) { result in
            self.lblProcedures.text = "\(result!.procedures.count) p, \(result!.workpapers.count) wp"
        }
    }
    
    @IBAction func clearLocalPressed(sender: AnyObject) {
        Services.clearStore()
    }
    
    
    @IBAction func proceduresPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.getMyData() { result in
            self.lblProcedures.text = "\(result!.procedures.count) p, \(result!.workpapers.count) wp"
        }
    }
    
    
    @IBAction func syncPressed(sender: AnyObject) {
        self.lblSync.text = ""
        Services.sync { result in
            print(result?.count)
        }
    }
    
    //MARK: - Attachments
    @IBAction func getAttachmentPressed(sender: AnyObject) {
        Services.getAttachment { result in
            let dc = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: result))
            dc.delegate = self
            dc.presentPreviewAnimated(true)
        }
    }
  
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
   @IBAction func addWorkpaperPressed(sender: AnyObject) {
        if self.procedure == nil {
            Services.getMyData() { result in
                self.procedure = result?.procedures.first!
                WorkpaperChooser.choose(self)
            }
        } else {
            WorkpaperChooser.choose(self)
        }
    }
}

