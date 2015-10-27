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
        
        var i = 0
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.textView.backgroundColor = UIColor.whiteColor()
            cell.textView.textContainerInset = UIEdgeInsetsMake(20,20,20,20);
            cell.height = { 300 }
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
                .onChange{ field in
                    self.enableSave()
                    self.procedure.title = field.value
                }

            +++ Section("")
            <<< NavigationRow() {
                $0.value = "Whatever"
            }
                .onCellSelection{ cell, row in
                    i = 1 - i
                    if (i == 0) {
                        cell.backgroundColor = UIColor.blueColor()
                    }
                    else {
                        cell.backgroundColor = UIColor.greenColor()
                    }
            }
            
            <<< TextRow() {
                $0.placeholder = self.t("code")
                $0.value = self.procedure.code
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.code = field.value
            }

            +++ Section("")
            <<< DateInlineRow() {
                $0.title = self.t("dueDate") + ":"
                $0.value = self.procedure.dueDate
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.dueDate = field.value
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
                $0.options = WorkflowState.getFilteredDisplayNames(self.procedure.allowedStates, current: self.procedure.workflowState)
                $0.value = WorkflowState(rawValue: self.procedure.workflowState)?.displayName
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.workflowState = WorkflowState.getFromDisplayName(field.value!).rawValue
                    field.cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
                    field.options = WorkflowState.getFilteredDisplayNames(self.procedure.allowedStates, current: self.procedure.workflowState)
                }
            
            +++ Section("Details")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text1")
                $0.value = self.procedure.text1
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.text1 = field.value
            }

            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text2")
                $0.value = self.procedure.text2
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.text2 = field.value
            }

            +++ Section("Purpose")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text3")
                $0.value = self.procedure.text3
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.text3 = field.value
            }

            +++ Section("Sample Criteria")
            <<< TextAreaRow() {
                $0.placeholder = self.t("text4")
                $0.value = self.procedure.text4
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.text4 = field.value
            }
    
            +++ Section()
            
            <<< SegmentedRow<String>() {
                $0.title = self.t("testResults")
                $0.options = TestResults.displayNames
                $0.value = TestResults(rawValue: self.procedure.testResults)?.displayName
                }
                .cellUpdate { cell, row in
                    
            }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.testResults = TestResults.getFromDisplayName(field.value!).rawValue
            }
            
            +++ Section("Scope")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText1")
                $0.value = self.procedure.resultsText1
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.resultsText1 = field.value
            }
            +++ Section("Conclusion")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText2")
                $0.value = self.procedure.resultsText2
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.resultsText2 = field.value
            }
            +++ Section("Notes")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText3")
                $0.value = self.procedure.resultsText3
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.resultsText3 = field.value
            }
            +++ Section("Results 4")
            <<< TextAreaRow() {
                $0.placeholder = self.t("resultsText4")
                $0.value = self.procedure.resultsText4
                }
                .onChange{ field in
                    self.enableSave()
                    self.procedure.resultsText4 = field.value
        }

        
        // MARK: X -
        
        self.title = "Procedure"
        
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
    
    private func enableSave()
    {
        self.navigationItem.rightBarButtonItem!.enabled = true
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
//        // http://stackoverflow.com/questions/23072442/uitableviewcontroller-crash-due-to-cell-identifier
//        let storyboard = UIStoryboard(name: "Procedure", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("ChangesViewController") as! ChangesController
//        
//        vc.changes = self.procedure.changes
//        self.navigationController?.pushViewController(vc, animated: true)
        Services.save(self.procedure)
        dismiss()
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


