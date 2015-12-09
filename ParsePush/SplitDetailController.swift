//
//  SplitDetailController.swift
//  TeamMate
//
//  Created by Tommy Fannon on 11/30/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class SplitDetailController: UIViewController {

    @IBOutlet weak var imgWorkflowState: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var procedure: Procedure! {
        didSet (newProcedure) {
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        lblTitle.text = procedure.title
        imgWorkflowState.image = UIImage(named: (WorkflowState(rawValue: procedure.workflowState)?.imageName)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
