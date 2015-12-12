//
//  BaseFormController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/12/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class BaseFormController : UITableViewController, CustomCellDelegate {

    var clearTable = true
    var watchForChanges = false
    var formHelper : FormHelper!
    private var editingCell : UITableViewCell?
    
    var parent : BaseObject?
    var primaryObject : BaseObject! {
        didSet {
            initializeFormHelper()
        }
    }
    var savedChildIndexPath : NSIndexPath?
    var parentForm : CustomCellDelegate?

    // MARK: - Static
    class func create(objectType : ObjectType) -> BaseFormController {
        var vc : BaseFormController?
        switch objectType {
        case .Procedure:
            vc = Misc.getViewController("Procedure", viewIdentifier: "ProcedureFormController") as ProcedureFormController
        case .Issue:
            vc = Misc.getViewController("Issue", viewIdentifier: "IssueFormController") as IssueFormController
        case .Workpaper:
            vc = Misc.getViewController("Workpaper", viewIdentifier: "WorkpaperFormController") as WorkpaperFormController
        default:
            vc = nil
        }
        return vc!
    }
    
    // MARK: ViewController
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
        self.navigationController?.navigationBarHidden = false
    }

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

    //MARK: - Form setup
    private func initializeFormHelper() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Procedure"
        
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
    
    func setupForm() {
        preconditionFailure("This method must be overridden")
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
    
    //MARK: - TableViewController methods
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

    func enableSave() {
        if watchForChanges {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }

    func childSaved(child : BaseObject) {
        formHelper.repaintObjectRow(self.savedChildIndexPath!, baseObject: child)
    }
    
    func childCancelled(child : BaseObject) {
        formHelper.revertObject(self.savedChildIndexPath!, baseObject: child)
    }
    
    private func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navbarCancelClicked() {
        parentForm?.childCancelled(self.primaryObject)
        dismiss()
    }
    
    func navbarSaveClicked() {
        Services.saveObject(self.primaryObject, log: true)
        parentForm?.childSaved(self.primaryObject)
        dismiss()
    }
    
}