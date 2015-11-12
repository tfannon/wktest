//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import Eureka

class CellData {
    static var tagCount = 0
    
    var label : String?
    var value : Any?
    var nibIdentifier : String?
    var imageName : String?
    var placeHolder : String?
    var identifier : String?
    var style : UITableViewCellStyle?
    var visible : Bool = true
    private var initFunction : (() -> UITableViewCell)?
    private var setupFunction : ((UITableViewCell, CellData) -> Void)?
    private var selectedFunction : ((UITableViewCell, CellData, NSIndexPath) -> Void)?
    private var changedFunction : ((UITableViewCell, CellData) -> Void)?
    let tag = tagCount++
    
    init (
        identifier : String,
        value : Any? = nil,
        label : String? = nil,
        imageName : String? = nil,
        placeHolder: String? = nil,
        style : UITableViewCellStyle? = nil,
        initialize : (() -> UITableViewCell)? = nil,
        setup : ((UITableViewCell, CellData) -> Void)? = nil,
        selected: ((UITableViewCell, CellData, NSIndexPath) -> Void)? = nil,
        changed: ((UITableViewCell, CellData) -> Void)? = nil
    )
    {
        if identifier.substring(1) == "_" {
            self.identifier = identifier.substringFrom(1)
        }
        else {
            self.nibIdentifier = identifier
        }
        self.label = label
        self.value = value
        self.style = style
        self.imageName = imageName
        self.placeHolder = placeHolder
        self.initFunction = initialize
        self.setupFunction = setup
        self.selectedFunction = selected
        self.changedFunction = changed
        self.visible = identifier != "DatePickerCell"
    }
    func initialize() -> UITableViewCell {
        if let f = initFunction {
            return f()
        }
        return UITableViewCell(style: self.style ?? .Default, reuseIdentifier: self.identifier)
    }
    func setup(cell : UITableViewCell) {
        setupFunction?(cell, self)
    }
    func selected(cell : UITableViewCell, indexPath: NSIndexPath) {
        selectedFunction?(cell, self, indexPath)
    }
    func changed(cell : UITableViewCell) {
        changedFunction?(cell, self)
    }
}

class ProcedureFormController: UITableViewController, CustomCellDelegate {
    
    private var procedure : Procedure!
    private var data : [[CellData]] = []
    private var sections : [String] = []
    private var watchForChanges = false
    private var tableViewHelper : TableViewHelper!
    private var dataLookup = [Int : CellData]()
    
    init(procedure : Procedure)
    {
        super.init(style: .Grouped)

        self.procedure = procedure
        tableViewHelper = TableViewHelper(tableView: tableView)
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
        
        tableView.estimatedRowHeight = 44.0 // Replace with your actual estimation
        // Automatic dimensions to tell the table view to use dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.cellLayoutMarginsFollowReadableWidth = false
        
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
    
    private func toggleCell(indexPath : NSIndexPath) {
        
    }
    
    private func setupForm() {
        
        let textCellSetup : ((UITableViewCell, CellData) -> Void) = { cell, data in
            let textCell = cell as! TextCell
            textCell.textField.text = data.value as! String?
            textCell.textField.placeholder = data.placeHolder
            textCell.delegate = self
        }

        let textViewSetup : ((UITableViewCell, CellData) -> Void) = { cell, data in
            let textCell = cell as! TextAutoSizeCell
            textCell.textView.text = data.value as? String ?? ""
            textCell.delegate = self
        }
        
        let dateCellSetup : ((UITableViewCell, CellData) -> Void) = { cell, data in
            cell.selectionStyle = .None
        }
        let dateCellSelected : ((UITableViewCell, CellData, NSIndexPath) -> Void) =
            { cell, data, indexPath in
                let indexPath = self.tableView.indexPathForCell(cell)!
                let dpIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                let dpTag = data.tag + 1
                let dpData = self.dataLookup[dpTag]!
                let currentlyVisible = dpData.visible
                dpData.visible = !dpData.visible
                self.tableView.beginUpdates()
                if currentlyVisible {
                    self.tableView.deleteRowsAtIndexPaths([dpIndexPath], withRowAnimation: .Top)
                }
                else {
                    self.tableView.insertRowsAtIndexPaths([dpIndexPath], withRowAnimation: .Top)
                }
                self.tableView.endUpdates()
                
                // if we're making a picker visible
                // remove any visible datetimepicker cells that aren't this one
                if dpData.visible {
                    for otherCell in self.tableView.visibleCells {
                        if let _ = otherCell as? DatePickerCell {
                            let otherIndexPath = self.tableView.indexPathForCell(otherCell)!
                            if (otherIndexPath != dpIndexPath) {
                                let otherData = self.getCellData(otherIndexPath)
                                otherData.visible = false
                                self.tableView.beginUpdates()
                                self.tableView.deleteRowsAtIndexPaths([otherIndexPath], withRowAnimation: .Top)
                                self.tableView.endUpdates()
                                // there can be only one - so we're done
                                break
                            }
                        }
                    }
                }
            }
        
        data.append([
            CellData(identifier: "TextCell", value: procedure.title, placeHolder: self.t("title"), setup: textCellSetup,
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    self.procedure.title = textCell.textField.text
                    self.enableSave()
            }),
            CellData(identifier: "TextCell", value: procedure.code, placeHolder: self.t("code"), setup: textCellSetup,
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    self.procedure.code = textCell.textField.text
                    self.enableSave()
            })
        ])

        data.append([
            CellData(identifier: "_BasicCell",
                value: WorkflowState(rawValue: self.procedure.workflowState)?.displayName,
                style: UITableViewCellStyle.Value1,
                setup: { cell, _ in
                    cell.selectionStyle = .None
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

        data.append([
            CellData(identifier: "_BasicCell", value: procedure.tester, label: self.t("tester"), style: UITableViewCellStyle.Value1, setup: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.dueDate?.ToLongDateStyle(), label: self.t("dueDate"),
                style: UITableViewCellStyle.Value1,
                setup: dateCellSetup,
                selected: dateCellSelected),
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
        
        data.append([
            CellData(identifier: "_BasicCell", value: procedure.reviewer, label: self.t("reviewer"), style: UITableViewCellStyle.Value1, setup: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                setup: dateCellSetup,
                selected: dateCellSelected),
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
        data.append([CellData(identifier: "SegmentedCell",
            setup: { cell, data in
                let segmentedCell = cell as! SegmentedCell
                segmentedCell.delegate = self
                segmentedCell.setOptions(TestResults.displayNames)
                segmentedCell.label.text = self.t("testResults")
                segmentedCell.segmented.selectedSegmentIndex = self.procedure.testResults
            },
            changed: { cell, _ in
                let segmentedCell = cell as! SegmentedCell
                self.procedure.testResults = segmentedCell.segmented.selectedSegmentIndex
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.text1,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.text1 = textCell.textView.text
                self.enableSave()
            })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.text2,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.text2 = textCell.textView.text
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.text3,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.text3 = textCell.textView.text
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.text4,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.text4 = textCell.textView.text
                self.enableSave()
        })])
 
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.resultsText1,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.resultsText1 = textCell.textView.text
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.resultsText2,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.resultsText2 = textCell.textView.text
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.resultsText3,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.resultsText3 = textCell.textView.text
                self.enableSave()
        })])
        data.append([CellData(identifier: "TextAutoSizeCell", value: procedure.resultsText4,
            setup: textViewSetup,
            changed: { cell, _ in
                let textCell = cell as! TextAutoSizeCell
                self.procedure.resultsText4 = textCell.textView.text
                self.enableSave()
        })])
        
        data.append([CellData(identifier: "_NavigationCell", label: "Change Tracking", imageName: "icons_change",
            setup: { cell, data in
                cell.accessoryType = .DisclosureIndicator },
            selected: { cell, data, indexPath in
                let vc : ChangeController = Misc.getTableViewController("Procedure", viewIdentifier: "ChangeViewController")
                vc.changes = self.procedure.changes
                self.navigationController?.pushViewController(vc, animated: true)
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })])
        
        sections = [
            " ",
            "Workflow",
            " ",
            "Review",
            " ",
            self.t("text1"),
            self.t("text2"),
            self.t("text3"),
            self.t("text4"),
            self.t("resultsText1"),
            self.t("resultsText2"),
            self.t("resultsText3"),
            self.t("resultsText4"),
            " "
        ]
        
        if (data.count != sections.count) {
            fatalError("sections != headers")
        }

        for i in 0..<data.count {
            for j in 0..<data[i].count {
                let d = data[i][j]
                dataLookup[d.tag] = d
            }
        }
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        return sections[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].filter { data in return data.visible }.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        let cellData = getCellData(indexPath)
        
        if let nibName = cellData.nibIdentifier {
            cell = self.tableView.dequeueReusableCellWithNibName(nibName)!
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
        
        configureCell(tableView, cell: cell, forRowAtIndexPath: indexPath)

        return cell
    }
    
    private func configureCell(tableView: UITableView,
        cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        let cellData = getCellData(indexPath)
 
        cell.textLabel?.text = cellData.label
        cell.detailTextLabel?.text = cellData.value as! String?

        if let imageName = cellData.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }

        cellData.setup(cell)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let data = getCellData(indexPath)
        data.selected(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    private func getCellData(indexPath: NSIndexPath, filtered : Bool = true) -> CellData
    {
        let filtered = (filtered) ? data[indexPath.section].filter { d in return d.visible } : data[indexPath.section]
        return filtered[indexPath.row]
    }
    
    func changed(cell: UITableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let cellData = getCellData(indexPath!)
        cellData.changed(cell)
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


