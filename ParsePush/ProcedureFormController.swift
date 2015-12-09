//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import DTFoundation

extension ProcedureFormController : CustomCellDelegate {
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

class ProcedureFormController: UITableViewController, WorkpaperChooserDelegate, SaveableFormControllerDelegate {
    private var bottomConstraint: NSLayoutConstraint!
    
    var procedure : Procedure!

    //this is needed because the storyboard instantiates it this way when starting app
    //may consider removing it from storyboard and setting it in app delegate
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(procedure: Procedure) {
        super.init(style: .Grouped)
        self.procedure = procedure
        initializeFormHelper()
    }
    
    //needed because form controller
    init() {
        super.init(style: .Grouped)
    }
    
    private func initializeFormHelper() {
        watchForChanges = false
        formHelper = FormHelper(controller: self)
        setupForm()
        self.tableView.reloadData()
        watchForChanges = true
    }
    
    private var clearTable = false
    private var watchForChanges = false
    private var formHelper : FormHelper!
    private var webViews = [UIWebView]()
    
    private var editingCell : UITableViewCell?
    
    private var toolbarLabel: UIBarButtonItem!
    
    private func t(key : String) -> String {
        return Procedure.getTerminology(key)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Procedure"
        
        tableView.estimatedRowHeight = 200.0 // Replace with your actual estimation
        // Automatic dimensions to tell the table view to use dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupNavbar()
        setupToolbar()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        if procedure == nil {
            Services.getMyData {
                self.procedure = $0?.procedures.first
                self.initializeFormHelper()
            }
        }
        super.viewWillAppear(animated)
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
    
    private func setupToolbar() {
        if let _ = self.navigationController?.toolbar {
            let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addClicked")
            let lbl = UIBarButtonItem(title: itemsAddedText, style: .Plain, target: nil, action: nil)
            let undo = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "undoClicked")
            let spacer = UIBarButtonItem (barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            self.toolbarItems = [add, spacer, lbl, spacer, undo]
            self.toolbarLabel = lbl
        }
    }
    
    private func setupForm() {
        
        formHelper.addSection(" ",
            data: [
                CellData(identifier: "TextCell", value: procedure.title, placeHolder: self.t("title"),
                    willDisplay: formHelper.textCellWillDisplay,
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.procedure.title = textCell.textField.text
                        self.enableSave()
                }),
                CellData(identifier: "TextCell", value: procedure.code, placeHolder: self.t("code"),
                    willDisplay: formHelper.textCellWillDisplay,
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.procedure.code = textCell.textField.text
                        self.enableSave()
                }),
                
                CellData(identifier: "_BasicCell", value: procedure.tester, label: self.t("tester"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                
                CellData(identifier: "_BasicCell", value: procedure.dueDate?.ToLongDateStyle(),
                    label: self.t("dueDate"),
                    style: UITableViewCellStyle.Value1,
                    willDisplay: formHelper.dateCellWillDisplay,
                    selected: formHelper.dateCellSelected),
                CellData(identifier: "DatePickerNullableCell",
                    willDisplay: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        dateCell.value = self.procedure.dueDate
                        dateCell.delegate = self
                    },
                    changed: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        self.procedure.dueDate = dateCell.value
                        let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                        let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                        let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                        displayCell.detailTextLabel!.text = self.procedure.dueDate?.ToLongDateStyle()
                        self.enableSave()
                }),
            ])
        
        formHelper.addSection("Workflow",
            data: [formHelper.getWorkflowCellData(self, workflowObject: procedure)])
        
        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: procedure.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                willDisplay: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                willDisplay: formHelper.dateCellWillDisplay,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerNullableCell",
                willDisplay: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    dateCell.value = self.procedure.reviewDueDate
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    self.procedure.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.procedure.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
            })
            ])
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields1",
                style: UITableViewCellStyle.Value1,
                label: "Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("text1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text3 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text4 = textCell.textString
                self.enableSave()
        })])
        
        formHelper.addSection("Results", data: [CellData(identifier: "SegmentedCell",
            willDisplay: { cell, data in
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
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields2",
                style: UITableViewCellStyle.Value1,
                label: "Result Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("resultsText1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText3 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText4 = htmlCell.textString
                self.enableSave()
        })])
        
        formHelper.addSection("", data: [CellData(identifier: "_NavigationCell", label: "Change Tracking", imageName: "icons_change",
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = self.procedure.changes?.count > 0
            },
            selected: { cell, data, indexPath in
                let vc : ChangeGridController = Misc.getViewController("ChangeTracking", viewIdentifier: "ChangeGridController")
                vc.changes = self.procedure.changes!
                self.navigationController?.pushViewController(vc, animated: true)
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })])
        
        // register up ALL the html cells - each with their own idenfifier
        //  so we don't reuse html cells
        var hideSections = [Int]()
        for i in 0..<formHelper.data.count {
            let section = formHelper.data[i]
            for data in section {
                if let nib = data.nibIdentifier {
                    if nib == "HtmlCell" {
                        self.tableView.registerNib(UINib(nibName: "HtmlCell", bundle: nil), forCellReuseIdentifier: data.uuid)
                        hideSections.append(i)
                    }
                }
            }
        }
        self.formHelper.hideSections(hideSections)
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
        Services.saveObject(self.procedure, log: true)
        dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Workpaper Chooser
    var workpaperOwner: Procedure { get { return procedure } }
    var owningViewController: UIViewController { get { return self }}
    
    func addClicked() {
        WorkpaperChooser.choose(self)
    }
    
    func undoClicked() {
        procedure.workpapers.removeAll()
        Services.saveObject(procedure, log: true)
        self.toolbarLabel.title = ""
    }
    
    func workpaperAddedCallback(wasAdded: Bool) {
        if wasAdded {
            Services.saveObject(procedure, log: true)
            self.toolbarLabel.title = itemsAddedText
        }
    }
    
    var itemsAddedText: String {
        get { return procedure.workpapers.any ? "\(procedure.workpapers.count) items added" : "" }
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


