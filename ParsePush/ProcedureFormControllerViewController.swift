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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.form +++ Section()
            <<< TextRow() {
                $0.placeholder = "Title"
                $0.value = self.procedure.title
            }
            <<< TextRow() {
                $0.placeholder = "Code"
                $0.value = self.procedure.code
            }
            <<< TextRow() {
                $0.placeholder = "Code"
                $0.value = self.procedure.code
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
