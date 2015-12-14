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
    func getWorkflowCellData(viewController : UIViewController, workflowObject : BaseObject) -> CellData {
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
                        self.controllerAsDelegate.enableSave()
                        workflowObject.workflowState = WorkflowState.getFromDisplayName(alertAction.title!).rawValue
                        cell.detailTextLabel?.text = alertAction.title
                        cell.imageView?.image = UIImage(named: WorkflowState(rawValue: workflowObject.workflowState)!.imageName)
                    })
                    alertController.addAction(action)
                }
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                if let popover = alertController.popoverPresentationController {
                    popover.sourceView = cell;
                    popover.sourceRect = cell.bounds;
                    popover.permittedArrowDirections = UIPopoverArrowDirection.Any;
                }
                
                viewController.presentViewController(alertController, animated: true, completion: nil)
        })
        
        return data
    }
    
    func addChildCells(parent : BaseObject, objectType : ObjectType) {
        var datas = [CellData]()
        let children = parent.getChildren(objectType)!
        datas.append(CellData(
            identifier: "_" + String(objectType),
            style: UITableViewCellStyle.Value1,
            label: String(objectType) + "s",
            imageName:  objectType.imageName,
            toggled: false,
            selectedIfAccessoryButtonTapped: true,
            willDisplay: self.hideSectionWillDisplay,
            selected: { cell, data, indexPath in
                self.showOrHideRows(cell, data: data, indexPath: indexPath, rowCount: children.count + 1)
        }))
        for child in children {
            let cellData = createObjectCellData(child, visible: false)
            datas.append(cellData)
        }
        datas.append(CellData(
            identifier: "_NavigationCell",
            objectType: .Issue,
            label: "Add",
            isAddCell: true,
            visible: false,
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = true
                cell.textLabel?.textAlignment = NSTextAlignment.Right
            },
            selected: { cell, data, indexPath in
                if (objectType == .Workpaper) {
                    self.controllerAsDelegate.savedChildIndexPath = indexPath
                    WorkpaperChooser.choose(self)
                }
                else {
                    let vc = BaseFormController.create(objectType)
                    vc.parentForm = self.controllerAsDelegate
                    vc.parent = self.controllerAsDelegate.primaryObject
                    vc.primaryObject = BaseObject.create(objectType, parent: vc.parent)
                    self.controllerAsDelegate.savedChildIndexPath = indexPath
                    self.controller.navigationController?.pushViewController(vc, animated: true)
                }
            }
            ))
        addSection(" ", data: datas)
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
    
    private func createObjectCellData<T : BaseObject>(baseObject : T, visible : Bool) -> CellData {
        
        // image name is handled differently for workpapers
        let workpaper = baseObject as? Workpaper
        
        let data = CellData(identifier: "_NavigationCell", label: baseObject.title,
            imageName: (workpaper != nil) ?
                (workpaper!.documentType?.imageName ?? "icon-document") :
                baseObject.objectType.imageName,
            willDisplay: { cell, data in
                cell.accessoryType = .DisclosureIndicator
                cell.userInteractionEnabled = true
            },
            visible: visible,
            selected: { cell, data, indexPath in
                let vc = BaseFormController.create(baseObject.objectType)
                vc.parentForm = self.controllerAsDelegate
                vc.parent = self.controllerAsDelegate.primaryObject
                vc.primaryObject = baseObject
                self.controllerAsDelegate.savedChildIndexPath = indexPath
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
        )
        return data
    }
    
    func repaintObjectRow<T : BaseObject>(indexPath : NSIndexPath, baseObject : T) {
 
        let newData = createObjectCellData(baseObject, visible: true)
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
    
    func revertObject<T : BaseObject> (indexPath : NSIndexPath, baseObject : T) {
        if let reloaded = Services.getObject(baseObject) {
            let newData = createObjectCellData(reloaded, visible: true)
            let sectionIndex = getActualVisibleSectionDataIndex(indexPath.section)
            self.data[sectionIndex][indexPath.row] = newData
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            tableView.endUpdates()
        }
    }
}

extension FormHelper : WorkpaperChooserDelegate {
    var workpaperOwner: Procedure { get {
        return self.controllerAsDelegate.primaryObject as! Procedure
    }}
        
    var owningViewController: UIViewController { get {
        return self.controller
    }}
        
    func workpaperAddedCallback(wasAdded: Bool) {
        let controller = self.controller as! BaseFormController
        controller.childSaved(controller.primaryObject)
    }
}
