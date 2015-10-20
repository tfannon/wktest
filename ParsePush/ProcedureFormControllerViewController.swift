//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import Eureka



class ProcedureFormControllerViewController: FormViewController {
    
    var procedure : Procedure!
    
    private func t(key : String) -> String
    {
        return Procedure.getTerminology(key)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.form
            +++ Section()
            <<< TextRow() {
                $0.title = self.t("title") + ":"
                $0.placeholder = self.t("title")
                $0.value = self.procedure.title
            }
            .cellUpdate {
                    $0.cell.textField.textAlignment = .Left
                    $0.cell.textLabel?.textAlignment = .Right
            }
            <<< TextRow() {
                $0.title = self.t("code") + ":"
                $0.placeholder = self.t("code")
                $0.value = self.procedure.code
            }
                .cellUpdate {
                    $0.cell.textField.textAlignment = .Left
                    $0.cell.textLabel?.textAlignment = .Right
            }
            +++ Section()
            <<< DateRow() {
                $0.title = self.t("dueDate") + ":"
                $0.value = self.procedure.dueDate
            }
                .cellUpdate {
                    $0.cell.textLabel?.textAlignment = .Right
            }
            +++ Section()
            <<< TextRow() {
                $0.title = self.t("tester") + ":"
                $0.value = self.procedure.tester
             }
                .cellUpdate {
                    $0.cell.textField.textAlignment = .Left
                    $0.cell.textLabel?.textAlignment = .Right
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
