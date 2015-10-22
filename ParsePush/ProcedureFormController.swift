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
        
        TextAreaRow.defaultCellSetup = { cell, row in
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
        
        // MARK: - Form Setup
        self.form
            +++ Section()
            <<< TextRow() {
                $0.placeholder = self.t("title")
                $0.value = self.procedure.title
                }
                .cellUpdate { cell, row in
                    self.procedure.title = row.value
            }
            <<< TextRow() {
                $0.placeholder = self.t("code")
                $0.value = self.procedure.code
                }
                .cellUpdate { cell, row in
                    self.procedure.code = row.value
            }
            +++ Section("")
            <<< DateInlineRow() {
                $0.title = self.t("dueDate") + ":"
                $0.value = self.procedure.dueDate
                }
                .cellUpdate { cell, row in
                    self.procedure.dueDate = row.value
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
                .cellUpdate { cell, row in
                    self.procedure.reviewDueDate = row.value
            }
            
            +++ Section("Workflow")
            <<< AlertRow<String>() {
                $0.title = self.t("workflowState")
                $0.selectorTitle = self.t("workflowState")
                $0.options = WorkflowState.getFilteredDisplayNames(self.procedure.allowedStates, current: self.procedure.workflowState)
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
                .cellUpdate { cell, row in
                    self.procedure.text1 = row.value
            }
            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text2")
                $0.value = self.procedure.text2
                }
                .cellUpdate { cell, row in
                    self.procedure.text2 = row.value
            }
            +++ Section("Purpose")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text3")
                $0.value = self.procedure.text3
                }
                .cellUpdate { cell, row in
                    self.procedure.text3 = row.value
            }
            +++ Section("Sample Criteria")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text4")
                $0.value = self.procedure.text4
                }
                .cellUpdate { cell, row in
                    self.procedure.text4 = row.value
            }
            
            +++ Section()
            
            <<< SegmentedRow<String>() {
                $0.title = self.t("testResults")
                $0.options = TestResults.displayNames
                $0.value = TestResults(rawValue: self.procedure.testResults)?.displayName
                }
                .cellUpdate { cell, row in
                    self.procedure.testResults = TestResults.getFromDisplayName(row.value!).rawValue
            }
            
            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText1")
                $0.value = self.procedure.resultsText1
                }
                .cellUpdate { cell, row in
                    self.procedure.resultsText1 = row.value
            }
            +++ Section("Conclusion")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText2")
                $0.value = self.procedure.resultsText2
                }
                .cellUpdate { cell, row in
                    self.procedure.resultsText2 = row.value
            }
            +++ Section("Notes")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText3")
                $0.value = self.procedure.resultsText3
                }
                .cellUpdate { cell, row in
                    self.procedure.resultsText3 = row.value
            }
            +++ Section("Results 4")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText4")
                $0.value = self.procedure.resultsText4
                }
                .cellUpdate { cell, row in
                    self.procedure.resultsText4 = row.value
        }
        
        // MARK: X -
        
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        let bar = self.navigationController?.navigationBar
        if (bar != nil)
        {
            let left = UIBarButtonItem(title: "Cancel",
                style: UIBarButtonItemStyle.Plain,
                target: self, action: "navbarCancelClicked")
            self.navigationItem.leftBarButtonItem = left
            
            let right = UIBarButtonItem(title: "Save",
                style: UIBarButtonItemStyle.Plain,
                target: self, action: "navbarSaveClicked")
            self.navigationItem.rightBarButtonItem = right
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    private func dismiss()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navbarCancelClicked()
    {
        dismiss();
    }
    
    func navbarSaveClicked()
    {
        dismiss();
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
