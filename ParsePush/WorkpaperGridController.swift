//
//  WorkpaperGridController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/7/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class WorkpaperGridController: BaseGridController, UIDocumentInteractionControllerDelegate {
    
    var documentInteractionController: UIDocumentInteractionController!
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        getWorkpapers {
            self.dataSourceHelper.data = self.items
        }
    }
    
    func getWorkpapers(completed: ()->()) {
        self.items = []
        self.sortedItems = []
        Services.getMyData { result in
            if result?.workpapers.count > 0 {
                result?.workpapers.each {
                    self.items.append($0)
                }
                self.sortedItems = self.items
                completed()
            }
        }
    }
    
    override func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["sync","title","attachmentExtension","parentType","parentTitle","workflowState","workflowStateTitle","manager","dueDate","reviewer","reviewDueDate"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Workpaper.getTerminology(key)
            switch key {
                
            case "sync": addColumnWithTitle(key, title: "Sync", width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5))
                
            case "title": addColumnWithTitle(key, title: title, width: 220, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "attachmentExtension": addColumnWithTitle(key, title: "Type", width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), cellClass:DataGridImageCell.self)
                
            case "parentType": addColumnWithTitle(key, title: "", width: 50, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "parentTitle": addColumnWithTitle(key, title: "Parent", width: 150, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "workflowState": addColumnWithTitle(key, title: "", width: 63, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
            
            case "workflowStateTitle": addColumnWithTitle(key, title: "State", width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "dueDate": addColumnWithTitle(key, title: "Due", width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), sortMode: SDataGridColumnSortModeTriState)
                
            case "reviewDueDate": addColumnWithTitle(key, title: "Review Due", width: 160, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: 125, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
        }
    }
    
    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, populateCell cell: SDataGridCell!, withValue value: AnyObject!, forProperty propertyKey: String!, sourceObject object: AnyObject!) -> Bool {
        let procedure = object as! Workpaper
        
        switch (propertyKey) {
        case "sync" :
            let wCell = cell as! SDataGridTextCell
            wCell.textField.text = procedure.syncState.displayName
            switch procedure.syncState {
            case .New :
                wCell.backgroundColor = UIColor.lightGrayColor()
            case .Modified :
                wCell.backgroundColor = UIColor.lightGrayColor()
            case .Dirty:""
            case .Unchanged:
                wCell.textField.text = ""
            }
            return true
            
        case "attachmentExtension" :
            let wCell = cell as! DataGridImageCell
            wCell.documentType = DocumentType(rawValue: procedure.attachmentExtension!)!
            return true
            
        case "sync" :
            let wCell = cell as! DataGridImageCell
            wCell.documentType = DocumentType(rawValue: procedure.attachmentExtension!)!
            return true
            
        case "workflowState" :
            let wCell = cell as! DataGridImageCell
            wCell.state = WorkflowState(rawValue: procedure.workflowState)!
            return true
            
        case "parentType" :
            let wCell = cell as! DataGridImageCell
            wCell.parentType = ObjectType(rawValue: procedure.parentType)!
            //wCell.imageProvider = ObjectType(rawValue: procedure.parentType)!
            return true
            
        case "dueDate" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  procedure.dueDate?.toShortString()
            return true
            
        case "reviewDueDate" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  procedure.reviewDueDate?.toShortString()
            return true
            
        default: return false
        }
    }
    
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let id = (items[row.rowIndex] as! Workpaper).attachmentId
        Services.getAttachment(id) { result in
            if self.documentInteractionController == nil {
                self.documentInteractionController = UIDocumentInteractionController()
                self.documentInteractionController.delegate = self
            }
            self.documentInteractionController.URL = NSURL(fileURLWithPath: result)
            self.documentInteractionController.presentPreviewAnimated(true)
        }
    }
    
    //MARK: - DocumentInteractionController
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerWillBeginPreview(controller: UIDocumentInteractionController) {
        
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(controller: UIDocumentInteractionController) {
    }
}
