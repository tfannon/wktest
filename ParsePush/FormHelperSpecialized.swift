//
//  FormHelperBusiness.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/10/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

// specialized FormHelper functions for this app's business objects

extension FormHelper {
    
    // used for creating a Workflow selector cell
    func getWorkflowCellData(viewController : UIViewController, workflowObject : BaseObject) -> CellData
    {
        let saveableFormController = viewController as! SaveableFormControllerDelegate
        
        let data = CellData(identifier: "_BasicCell",
            value: WorkflowState(rawValue: workflowObject.workflowState)?.displayName,
            style: UITableViewCellStyle.Value1,
            willDisplay: { cell, _ in
                cell.selectionStyle = .None
                cell.detailTextLabel?.textColor = cell.textLabel?.textColor
                cell.imageView?.image = UIImage(named: WorkflowState(rawValue: workflowObject.workflowState)!.imageName)
                cell.userInteractionEnabled = workflowObject.allowedStates?.any ?? false
            },
            selected: { cell, data, indexPath in
                let alertController = UIAlertController(title: "Workflow State", message: "Choose the new workflow state", preferredStyle: UIAlertControllerStyle.ActionSheet)
                let choices = WorkflowState.getFilteredDisplayNames(workflowObject.allowedStates, current: workflowObject.workflowState)
                for choice in choices {
                    let action = UIAlertAction(title: choice, style: UIAlertActionStyle.Default, handler: { alertAction in
                        saveableFormController.enableSave()
                        workflowObject.workflowState = WorkflowState.getFromDisplayName(alertAction.title!).rawValue
                        cell.detailTextLabel?.text = alertAction.title
                        cell.imageView?.image = UIImage(named: WorkflowState(rawValue: workflowObject.workflowState)!.imageName)
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
                
                viewController.presentViewController(alertController, animated: true, completion: nil)
        })
        
        return data
    }
    
    // create cell data for each of the workpapers
    func addWorkpaperCells(workpapers : [Workpaper]) {
        var workpaperCellData = [CellData]()
        workpaperCellData.append(CellData(identifier: "_Workpapers",
            style: UITableViewCellStyle.Value1,
            label: "Workpapers",
            imageName:  "icons_workpaper",
            toggled: false,
            selectedIfAccessoryButtonTapped: true,
            willDisplay: self.hideSectionWillDisplay,
            selected: { cell, data, indexPath in
                self.hideRows(cell, data: data, indexPath: indexPath, rowCount: workpapers.count + 1)
        }))
        for w in workpapers {
            let cellData =
            CellData(identifier: "_NavigationCell", label: w.title,
                imageName: w.documentType?.imageName ?? "icon-document",
                willDisplay: { cell, data in
                    cell.accessoryType = .DisclosureIndicator
                    cell.userInteractionEnabled = true
                },
                visible: false,
                selected: { cell, data, indexPath in
                    //                        let vc : [Workpaper form]
                    //                        vc.workpaper = w
                    //                        self.navigationController?.pushViewController(vc, animated: true)
                    self.controller.alert("", message: "Show workpaper form here")
                }
            )
            workpaperCellData.append(cellData)
        }
        workpaperCellData.append(CellData(
            identifier: "_NavigationCell",
            label: "Add",
            visible: false,
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = true
                cell.textLabel?.textAlignment = NSTextAlignment.Right
            },
            selected: { cell, data, indexPath in
                self.controller.alert("", message: "Show wp form here in ADD mode")
            }
            ))
        addSection(" ", data: workpaperCellData)
    }
    
    // create cell data for each of the issues
    func addIssueCells(issues : [Issue]) {
        var issueCellData = [CellData]()
        issueCellData.append(CellData(identifier: "_issues",
            style: UITableViewCellStyle.Value1,
            label: "issues",
            imageName:  "icons_issue",
            toggled: false,
            selectedIfAccessoryButtonTapped: true,
            willDisplay: self.hideSectionWillDisplay,
            selected: { cell, data, indexPath in
                self.hideRows(cell, data: data, indexPath: indexPath, rowCount: issues.count + 1)
        }))
        for iss in issues {
            let cellData = createIssueCellData(iss, visible: false)
            issueCellData.append(cellData)
        }
        issueCellData.append(CellData(
            identifier: "_NavigationCell",
            label: "Add",
            isAddCell: true,
            visible: false,
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = true
                cell.textLabel?.textAlignment = NSTextAlignment.Right
            },
            selected: { cell, data, indexPath in
                let vc = IssueFormController.create()
                vc.issue = Issue.create()
                vc.parent = self.controllerAsDelegate.primaryObject
                var sd = self.controller as! SaveableFormControllerDelegate
                sd.savedChildIndexPath = indexPath
                vc.parentForm = sd
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
            ))
        addSection(" ", data: issueCellData)
    }
    
    private func createIssueCellData(issue : Issue, visible : Bool) -> CellData {
        let data = CellData(identifier: "_NavigationCell", label: issue.title,
            imageName: "icon_issue",
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = true
            },
            visible: visible,
            selected: { cell, data, indexPath in
                let vc = IssueFormController.create()
                vc.issue = issue
                vc.parent = self.controllerAsDelegate.primaryObject
                var sd = self.controller as! SaveableFormControllerDelegate
                sd.savedChildIndexPath = indexPath
                vc.parentForm = sd
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
        )
        return data
    }
    
    func addChangeTracking(changes : [Change]?) {
        self.addSection("", data: [
            CellData(identifier: "_NavigationCell", label: "Change Tracking", imageName: "icons_change",
                willDisplay: { cell, data in
                    cell.accessoryType = .DisclosureIndicator
                    cell.userInteractionEnabled = changes?.count > 0
                },
                selected: { cell, data, indexPath in
                    let vc : ChangeGridController = Misc.getViewController("ChangeTracking", viewIdentifier: "ChangeGridController")
                    vc.changes = changes!
                    self.controller.navigationController?.pushViewController(vc, animated: true)
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })])
    }
    
    // register up ALL the html cells - each with their own idenfifier
    //  so we don't reuse html cells - and hide the sections
    func hideHtmlSections() {
        var hideSections = [Int]()
        for i in 0..<self.data.count {
            let section = self.data[i]
            for data in section {
                if let s = data.sectionsToHide where s.count > 0 {
                    let hideList = s.map{ x in x + i }
                    hideSections.appendContentsOf(hideList)
                }
                if let nib = data.nibIdentifier {
                    if nib == "HtmlCell" {
                        self.tableView.registerNib(UINib(nibName: "HtmlCell", bundle: nil), forCellReuseIdentifier: data.uuid)
                    }
                }
            }
        }
        self.hideSections(hideSections)
    }
    
    func repaintIssueRow(indexPath : NSIndexPath, issue : Issue?) {
 
        let newData = createIssueCellData(issue!, visible: true)
        let currentData = getCellData(indexPath)
        let sectionIndex = getActualVisibleSectionDataIndex(indexPath.section)
        
        tableView.beginUpdates()
        if currentData.isAddCell {
            self.data[sectionIndex].insert(newData, atIndex: indexPath.row)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            let newAddIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: newAddIndexPath)
        }
        else {
            self.data[sectionIndex][indexPath.row] = newData
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        tableView.endUpdates()
    }
    
    func revertIssue(indexPath : NSIndexPath, issue : Issue) {
        if let reloaded = Services.getIssue(issue.id!) {
            let newData = createIssueCellData(reloaded, visible: true)
            let sectionIndex = getActualVisibleSectionDataIndex(indexPath.section)
            let p = self.controllerAsDelegate.primaryObject.issues.indexOf{ x in x.id! == reloaded.id }!
            self.controllerAsDelegate.primaryObject.issues[p] = reloaded
            self.data[sectionIndex][indexPath.row] = newData
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            tableView.endUpdates()
        }
    }
}