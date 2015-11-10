//
//  ViewController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import ObjectMapper


class TestController: UIViewController, UITextFieldDelegate, UIDocumentInteractionControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtIPAddress.delegate = self
        txtIPAddress.text = Services.ipAddress
        
        txtUserName.delegate = self
        txtUserName.text = Services.userName
        
        segMockMode.selectedSegmentIndex = (Services.mock) ? 1 : 0
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
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblProcedures: UILabel!
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var segMockMode: UISegmentedControl!
    
    //MARK - persistent store
    @IBAction func storeLocalPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.getMyProcedures {
            self.lblProcedures.text = String($0!.count)
        }
    }
    
    @IBAction func readLocalPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.getMyProcedures(.LocalOnly) {
            self.lblProcedures.text = String($0!.count)
        }
    }
    
    @IBAction func clearLocalPressed(sender: AnyObject) {
        Services.clearStore()
    }
    
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
    
    @IBAction func editProcedurePressed(sender: AnyObject) {
        let vc = ProcedureFormControllerViewController()
        vc.procedure = Mock.getProcedures()[0]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        var key = ""
        let value = textField.text!
        if (textField == self.txtIPAddress) {
            key = "ipAddress"
            Services.ipAddress = value
        }
        else if (textField == self.txtUserName) {
            self.imgLoginResult.hidden = false
            Services.userName = value
            
            Services.login(Services.userName, token: "foobar") { result in
                let imageName = result != nil ? "icons_implemented" : "icons_issue"
                self.imgLoginResult.image = UIImage(named: imageName)
            }
        }
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func getAttachmentPressed(sender: AnyObject) {
        Services.getAttachment { result in
            let dc = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: result))
            dc.delegate = self
            dc.presentPreviewAnimated(true)
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
    
    @IBAction func segMockModeChanged(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        Services.mock = sender.selectedSegmentIndex == 1
        defaults.setBool(Services.mock, forKey: "mock")
        defaults.synchronize()
    }
    
    @IBAction func miscPressed(sender: UIButton) {
        //let procedures = Mock.getProcedures()
        let proc = Procedure()
        proc.title = "something new"
        let json = Mapper().toJSONString(proc, prettyPrint: true)!
        print(json)
        
    }
    
    @IBAction func proceduresPressed(sender: AnyObject) {
        self.lblProcedures.text = ""
        Services.getMyProcedures { result in
            self.lblProcedures.text = String(result!.count)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerWillBeginPreview(controller: UIDocumentInteractionController) {
        
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(controller: UIDocumentInteractionController) {
        print("here")
    }
    
    
}

