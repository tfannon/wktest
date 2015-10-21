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
//        LabelRow.defaultCellSetup = { cell, row in
//            cell.detailTextLabel?.textColor = UIColor.blackColor()
//            cell.detailTextLabel?.textAlignment = .Left
//        }
        TextAreaRow.defaultCellSetup = { cell, row in
            //cell.backgroundColor = UIColor.clearColor()
            //cell.textView.layer.cornerRadius = 10
            cell.textView.backgroundColor = UIColor.whiteColor()
            cell.textView.textContainerInset = UIEdgeInsetsMake(20,20,20,20);

            let fixedWidth = cell.textView.frame.size.width
            cell.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            let newSize = cell.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            var newFrame = cell.textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            cell.textView.frame = newFrame;

            
        }
        
        self.tableView?.estimatedRowHeight = 44.0
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.form
            +++ Section()
            <<< TextRow() {
                $0.placeholder = self.t("title")
                $0.value = self.procedure.title
            }
            <<< TextRow() {
                $0.placeholder = self.t("code")
                $0.value = self.procedure.code
            }
            +++ Section("")
            <<< DateInlineRow() {
                $0.title = self.t("dueDate") + ":"
                $0.value = self.procedure.dueDate
            }
            +++ Section("")
            <<< LabelRow() {
                $0.title = self.t("tester") + ":"
                $0.value = self.procedure.tester
             }
            +++ Section("")
            <<< LabelRow() {
                $0.title = self.t("reviewer") + ":"
                $0.value = self.procedure.reviewer
            }
            <<< DateInlineRow() {
                $0.title = self.t("reviewDueDate") + ":"
                $0.value = self.procedure.reviewDueDate
            }
            
            +++ Section("Workflow")
            <<< AlertRow<String>() {
                $0.title = self.t("workflowState")
                $0.selectorTitle = self.t("workflowState")
                $0.options = WorkflowState.displayNames
                $0.value = WorkflowState(rawValue: self.procedure.workflowState)?.displayName
            }
            .cellSetup { cell, row in
                cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
            }
            .cellUpdate { cell, row in
                self.procedure.workflowState = WorkflowState.getFromDisplayName(row.value!).rawValue
                cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
            }
            
            +++ Section("Details")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text1")
                $0.value = self.procedure.text1
            }
            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text2")
                $0.value = self.procedure.text2
            }
            +++ Section("Purpose")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text3")
                $0.value = self.procedure.text3
            }
            +++ Section("Sample Criteria")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text4")
                $0.value = self.procedure.text4
            }
            
            +++ Section()
            
            <<< SegmentedRow<String>() {
                $0.title = self.t("testResults")
                $0.options = Array(TestResultsType.displayNames)
                $0.value = TestResultsType(rawValue: self.procedure.testResults)?.displayName
            }
            
            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText1")
                $0.value = self.procedure.resultsText1
            }
            +++ Section("Conclusion")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText2")
                $0.value = self.procedure.resultsText2
            }
            +++ Section("Notes")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText3")
                $0.value = self.procedure.resultsText3
            }
            +++ Section("Results 4")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText4")
                $0.value = self.procedure.resultsText4
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
