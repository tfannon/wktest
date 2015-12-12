//
//  IssueFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import DTFoundation

extension IssueFormController : CustomCellDelegate {
    func getViewController() -> UIViewController {
        return self
    }
    func changed(cell: UITableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let cellData = formHelper.getCellData(indexPath)
            cellData.changed(cell)
        }
    }
    func beganEditing(cell: UITableViewCell) {
        self.editingCell = cell
    }
    func finishedEditing(cell: UITableViewCell) {
        // make sure we only set to nil if we're finishing the start we started on
        // don't know the order if you select another cell (if finished fires before start)
        if cell == self.editingCell {
            self.editingCell = nil
        }
    }
}

class IssueFormController: UITableViewController, SaveableFormControllerDelegate {
    
    var parent : BaseObject?
    var primaryObject : BaseObject { return self.issue }
    var savedChildIndexPath : NSIndexPath?
    var parentForm : SaveableFormControllerDelegate?
    
    private var clearTable = true
    private var watchForChanges = false
    private var formHelper : FormHelper!
    
    private var editingCell : UITableViewCell?
    
    private var toolbarLabel: UIBarButtonItem!
    
    var issue : Issue! {
        didSet {
            initializeFormHelper()
        }
    }
    
    private func initializeFormHelper() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Issue"
        
        tableView.estimatedRowHeight = 200.0 // Replace with your actual estimation
        // Automatic dimensions to tell the table view to use dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        clearTable = true
        self.tableView.reloadData()
        clearTable = false
        
        watchForChanges = false
        formHelper = FormHelper(controller: self)
        setupForm()
        watchForChanges = true
    }
    
    private func t(key : String) -> String {
        return Issue.getTerminology(key)
    }
    
    class func create() -> IssueFormController {
        let vc : IssueFormController = Misc.getViewController("Issue", viewIdentifier: "IssueFormController")
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = false
    }
    
    private func setupNavbar() {
        if let _ = self.navigationController?.navigationBar {
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
                CellData(identifier: "TextCell", value: issue.title, placeHolder: self.t("title"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.issue.title = textCell.textField.text
                        self.enableSave()
                }),
                CellData(identifier: "TextCell", value: issue.code, placeHolder: self.t("code"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.issue.code = textCell.textField.text
                        self.enableSave()
                }),
                
                CellData(identifier: "_BasicCell", value: issue.manager, label: self.t("manager"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                CellData(identifier: "_BasicCell", value: issue.businessContact,
                    label: self.t("businessContact"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                
                CellData(identifier: "_BasicCell", value: issue.dueDate?.ToLongDateStyle(),
                    label: self.t("dueDate"),
                    style: UITableViewCellStyle.Value1,
                    willDisplay: formHelper.dateCellWillDisplay,
                    selected: formHelper.dateCellSelected),
                CellData(identifier: "DatePickerNullableCell",
                    willDisplay: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        dateCell.value = self.issue.dueDate
                        dateCell.delegate = self
                    },
                    changed: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        self.issue.dueDate = dateCell.value
                        let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                        let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                        let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                        displayCell.detailTextLabel!.text = self.issue.dueDate?.ToLongDateStyle()
                        self.enableSave()
                }),
            ])
        
        formHelper.addSection("Workflow",
            data: [formHelper.getWorkflowCellData(self, workflowObject: issue)])
        
        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: issue.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                willDisplay: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: issue.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                willDisplay: formHelper.dateCellWillDisplay,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerNullableCell",
                willDisplay: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    dateCell.value = self.issue.reviewDueDate
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    self.issue.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.issue.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
            })
            ])
        
        formHelper.addSection("Properties", data: [
            CellData(identifier: "TextCellWithLabel", value: self.issue.numericValue1,                 willDisplay: formHelper.getTextCellWillDisplay(
                UIKeyboardType.DecimalPad,
                label: self.t("numericValue1")),
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    if let v = textCell.textField?.text {
                        self.issue.numericValue1 = v.toDouble()
                    }
                    else {
                        self.issue.numericValue1 = 0
                    }
                    self.enableSave()
            }),
            CellData(identifier: "TextCellWithLabel",
                value: self.issue.numericValue2,
                willDisplay: formHelper.getTextCellWillDisplay(
                    UIKeyboardType.DecimalPad,
                    label: self.t("numericValue2")),
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    if let v = textCell.textField?.text {
                        self.issue.numericValue2 = v.toDouble()
                    }
                    else {
                        self.issue.numericValue2 = 0
                    }
                    self.enableSave()
            }),
            CellData(identifier: "SwitchCell",
                willDisplay: { cell, data in
                    let sc = cell as! SwitchCell
                    sc.value = self.issue.yesNo1 ?? false
                    sc.label.text = self.t("yesNo1")
                    sc.delegate = self
                },
                changed: { cell, data in
                    self.issue.yesNo1 = (cell as! SwitchCell).value
                    self.enableSave()
            }),
            CellData(identifier: "SwitchCell",
                willDisplay: { cell, data in
                    let sc = cell as! SwitchCell
                    sc.value = self.issue.yesNo2 ?? false
                    sc.label.text = self.t("yesNo2")
                    sc.delegate = self
                },
                changed: { cell, data in
                    self.issue.yesNo2 = (cell as! SwitchCell).value
                    self.enableSave()
            }),
            ])
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields1",
                style: UITableViewCellStyle.Value1,
                label: "Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4, 5],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("text1"), data: [CellData(identifier: "HtmlCell",
            value: issue.text1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.issue.text1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text2"), data: [CellData(identifier: "HtmlCell",
            value: issue.text2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.issue.text2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text3"), data: [CellData(identifier: "HtmlCell",
            value: issue.text3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text3 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text4"), data: [CellData(identifier: "HtmlCell",
            value: issue.text4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text4 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text5"), data: [CellData(identifier: "HtmlCell",
            value: issue.text5,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text5 = textCell.textString
                self.enableSave()
        })])
        
        ///////////////////
        // workpapers
        ///////////////////
        formHelper.addWorkpaperCells(self.issue.workpapers)
        
        ///////////////////
        // Change Tracking
        ///////////////////
        formHelper.addChangeTracking(self.issue.changes)
        
        ///////////////////
        // now that our data is wired up - reload
        ///////////////////
        tableView.reloadData()
        
        ///////////////////
        // hide html
        ///////////////////
        formHelper.hideHtmlSections()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formHelper.getSectionTitle(section)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return clearTable ? 0 : formHelper.getNumberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clearTable ? 0 : formHelper.getNumberOfRowsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        let data = formHelper.getCellData(indexPath)
        
        if let nibName = data.nibIdentifier {
            if nibName == "HtmlCell" {
                cell = self.tableView.dequeueReusableCellWithIdentifier(data.uuid, forIndexPath: indexPath)
            }
            else {
                cell = self.tableView.dequeueReusableCellWithNibName(nibName)!
            }
        }
        else if let identifier = data.identifier {
            if let c = tableView.dequeueReusableCellWithIdentifier(identifier) {
                cell = c
            }
            else {
                cell = data.initialize()
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
    
    // need this so we can detect the tapping of an accessory view, which is otherwise independant of the UITableViewCell
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let data = formHelper.getCellData(indexPath)
        if data.selectedIfAccessoryButtonTapped {
            data.selected(cell, indexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellData = formHelper.getCellData(indexPath)
        
        // so that the separator appears under the image
        cell.separatorInset = UIEdgeInsetsZero
        // other initialization to clear previous usage of the cell
        cell.accessoryType = .None
        
        cell.textLabel?.text = cellData.label
        cell.detailTextLabel?.text = cellData.value as! String?
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        
        if let imageName = cellData.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        else {
            cell.imageView?.image = nil
        }
        
        cellData.willDisplay(cell)
    }
    
    func enableSave()
    {
        if watchForChanges {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func childSaved(child : BaseObject) {
    }
    func childCancelled(child : BaseObject) {
    }
    
    private func dismiss()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navbarCancelClicked()
    {
        self.parentForm?.childCancelled(self.issue)
        dismiss()
    }
    
    func navbarSaveClicked()
    {
        Services.saveObject(self.issue, parent: self.parent!, log: true)
        self.parentForm?.childSaved(self.issue)
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


