//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class ProcedureFormController: UITableViewController, CustomCellDelegate {
    
    private var procedure : Procedure!
    private var watchForChanges = false
    private var formHelper : FormHelper!
    
    init(procedure : Procedure)
    {
        super.init(style: .Grouped)

        self.procedure = procedure
        formHelper = FormHelper(controller: self)
    }
    
    required init(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func t(key : String) -> String
    {
        return Procedure.getTerminology(key)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Procedure"
        
        tableView.estimatedRowHeight = 200.0 // Replace with your actual estimation
        // Automatic dimensions to tell the table view to use dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
         
        setupForm()
        
        self.tableView.reloadData()
        
        watchForChanges = true
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
    
    private func setupForm() {
        
        formHelper.addSection(" ",
        data: [
            CellData(identifier: "TextCell", value: procedure.title, placeHolder: self.t("title"),
                setup: formHelper.textCellSetup,
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    self.procedure.title = textCell.textField.text
                    self.enableSave()
            }),
            CellData(identifier: "TextCell", value: procedure.code, placeHolder: self.t("code"),
                setup: formHelper.textCellSetup,
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    self.procedure.code = textCell.textField.text
                    self.enableSave()
            }),
            
            CellData(identifier: "_BasicCell", value: procedure.tester, label: self.t("tester"),
                style: UITableViewCellStyle.Value1,
                imageName: "769-male",
                setup: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.dueDate?.ToLongDateStyle(),
                label: self.t("dueDate"),
                style: UITableViewCellStyle.Value1,
                setup: formHelper.dateCellSetup,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerCell",
                setup: { cell, data in
                    let dateCell = cell as! DatePickerCell
                    if let date = self.procedure.dueDate {
                        dateCell.datePicker.date = date
                    }
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerCell
                    self.procedure.dueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.procedure.dueDate?.ToLongDateStyle()
                    self.enableSave()
            }),
        ])

        formHelper.addSection("Workflow", data: [
            CellData(identifier: "_BasicCell",
                value: WorkflowState(rawValue: self.procedure.workflowState)?.displayName,
                style: UITableViewCellStyle.Value1,
                setup: { cell, _ in
                    cell.selectionStyle = .None
                    cell.detailTextLabel?.textColor = cell.textLabel?.textColor
                    cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
                },
                selected: { cell, data, indexPath in
                    let alertController = UIAlertController(title: "Workflow State", message: "Choose the new workflow state", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    let choices = WorkflowState.getFilteredDisplayNames(self.procedure.allowedStates, current: self.procedure.workflowState)
                    for choice in choices {
                        let action = UIAlertAction(title: choice, style: UIAlertActionStyle.Default, handler: { alertAction in
                                self.enableSave()
                                self.procedure.workflowState = WorkflowState.getFromDisplayName(alertAction.title!).rawValue
                                cell.detailTextLabel?.text = alertAction.title
                                cell.imageView?.image = UIImage(named: WorkflowState(rawValue: self.procedure.workflowState)!.imageName)
                            })
                        alertController.addAction(action)
                    }
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    
                    if let popover = alertController.popoverPresentationController
                    {
                        popover.sourceView = cell;
                        popover.sourceRect = cell.bounds;
                        popover.permittedArrowDirections = UIPopoverArrowDirection.Any;
                    }
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
        ])

        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: procedure.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                setup: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                setup: formHelper.dateCellSetup,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerCell",
                setup: { cell, data in
                    let dateCell = cell as! DatePickerCell
                    if let date = self.procedure.reviewDueDate {
                        dateCell.datePicker.date = date
                    }
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerCell
                    self.procedure.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.procedure.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
                })
            ])
        formHelper.addSection(self.t("text1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text1,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text1 = htmlCell.textString
                self.enableSave()
            })])
        formHelper.addSection(self.t("text2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text2,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text3,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text3 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text4,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text4 = textCell.textString
                self.enableSave()
        })])
 
        formHelper.addSection("Results", data: [CellData(identifier: "SegmentedCell",
            setup: { cell, data in
                let segmentedCell = cell as! SegmentedCell
                segmentedCell.delegate = self
                segmentedCell.setOptions(TestResults.displayNames)
                //segmentedCell.label.text = self.t("testResults")
                segmentedCell.segmented.selectedSegmentIndex = self.procedure.testResults
            },
            changed: { cell, _ in
                let segmentedCell = cell as! SegmentedCell
                self.procedure.testResults = segmentedCell.segmented.selectedSegmentIndex
                self.enableSave()
        })])

        formHelper.addSection(self.t("resultsText1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText1,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText2,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText3,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText3 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText4,
            setup: formHelper.htmlCellSetup,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText4 = htmlCell.textString
                self.enableSave()
        })])
        
        formHelper.addSection("", data: [CellData(identifier: "_NavigationCell", label: "Change Tracking", imageName: "icons_change",
            setup: { cell, data in
                cell.accessoryType = .DisclosureIndicator },
            selected: { cell, data, indexPath in
                let vc : ChangeController = Misc.getTableViewController("Procedure", viewIdentifier: "ChangeViewController")
                vc.changes = self.procedure.changes
                self.navigationController?.pushViewController(vc, animated: true)
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })])
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        return formHelper.sections[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return formHelper.data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formHelper.data[section].filter { data in return data.visible }.count
    }
    
    var cellLookup = [Int : UITableViewCell]()
    var cellSetup = [Int : Bool]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        let cellData = formHelper.getCellData(indexPath)
        
        if let nibName = cellData.nibIdentifier {
            if (nibName == "HtmlCell") {
                if let c = cellLookup[cellData.tag] {
                    cell = c
                }
                else {
                    let d = NSBundle.mainBundle().loadNibNamed("HtmlCell", owner: self, options: nil)[0]
                    cell = d as! UITableViewCell
                    cellLookup[cellData.tag] = cell
                }
            }
            else {
                cell = self.tableView.dequeueReusableCellWithNibName(nibName)!
            }
        }
        else if let identifier = cellData.identifier {
            if let c = tableView.dequeueReusableCellWithIdentifier(identifier) {
                cell = c
            }
            else {
                cell = cellData.initialize()
            }
            
        }
        else {
            fatalError("cellForRowAtIndexPath has not been handled")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let data = formHelper.getCellData(indexPath)
        data.selected(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // so that the separator appears under the image
        cell.separatorInset = UIEdgeInsetsZero
        configureCell(tableView, cell: cell, forRowAtIndexPath: indexPath)
    }
    
    private func configureCell(tableView: UITableView,
        cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        let cellData = formHelper.getCellData(indexPath)
        
        cell.textLabel?.text = cellData.label
        cell.detailTextLabel?.text = cellData.value as! String?
        
        if let imageName = cellData.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        
        if let _ = cell as? HtmlCell, let _ = cellSetup[cellData.tag] {
            return
        }
        
        cellSetup[cellData.tag] = true
        
        cellData.setup(cell)
    }
    
    func changed(cell: UITableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let cellData = formHelper.getCellData(indexPath)
            cellData.changed(cell)
        }
    }
    
    private func enableSave()
    {
        if watchForChanges {
            self.navigationItem.rightBarButtonItem!.enabled = true
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


