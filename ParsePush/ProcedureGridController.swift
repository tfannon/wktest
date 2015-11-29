//
//  MyWorkController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class ProcedureGridController: BaseGridController {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        getProcedures {
            self.dataSourceHelper.data = self.items
        }
    }

    func getProcedures(completed: ()->()) {
        self.items = []
        self.sortedItems = []
        Services.getMyData { result in
            if result?.procedures.count > 0 {
                result?.procedures.each {
                    self.items.append($0)
                }
                self.sortedItems = self.items
                completed()
            }
        }
    }
    
    //can probably push this up
    override func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["sync","title","parentType","parentTitle","workflowState","workflowStateTitle", "tester","testResults","dueDate","reviewer","reviewDueDate"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Procedure.getTerminology(key)
            switch key {

            case "sync": addColumnWithTitle(key, title: "Sync", width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5))
                
            case "title": addColumnWithTitle(key, title: title, width: 220, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

            case "parentType": addColumnWithTitle(key, title: "", width: 50, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "parentTitle": addColumnWithTitle(key, title: "Parent", width: 125, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                

            case "workflowState": addColumnWithTitle(key, title: "", width: 63, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "workflowStateTitle": addColumnWithTitle(key, title: "State", width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "testResults": addColumnWithTitle(key, title: title, width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "dueDate": addColumnWithTitle(key, title: "Due", width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), sortMode: SDataGridColumnSortModeTriState)
                
            case "reviewDueDate": addColumnWithTitle(key, title: "Review Due", width: 160, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: 125, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
        }
    }
    
    
    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, populateCell cell: SDataGridCell!, withValue value: AnyObject!, forProperty propertyKey: String!, sourceObject object: AnyObject!) -> Bool {
        let procedure = object as! Procedure

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
            
            case "workflowState" :
                let wCell = cell as! DataGridImageCell
                wCell.state = WorkflowState(rawValue: procedure.workflowState)!
                return true
                
            case "parentType" :
                let wCell = cell as! DataGridImageCell
                wCell.parentType = ObjectType(rawValue: procedure.parentType)!
                //wCell.imageProvider = ObjectType(rawValue: procedure.parentType)!
                return true
                
            case "testResults" :
                let wCell = cell as! SDataGridTextCell
                wCell.text = TestResults(rawValue: procedure.testResults)?.displayName
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

    //can probably push this up when form support comes in for all
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let procedure = items[row.rowIndex] as! Procedure
        let controller = ProcedureFormController(procedure: procedure)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
        Services.sync { result in
            self.items = result!.procedures
            self.dataSourceHelper.data = self.items
            self.grid.pullToAction.actionCompleted()
        }
    }
    
    /*
    func shinobiDataGrid(grid: ShinobiDataGrid!, didChangeSortOrderForColumn column: SDataGridColumn!, to newSortOrder: SDataGridColumnSortOrder) {
        if newSortOrder == SDataGridColumnSortOrderNone {
            self.sortedItems = items
        }
        else {
            switch (column.title) {
            case "dueDate" :
                self.sortedItems = items.sort {
                    $0.0.dueDate?.timeIntervalSinceNow > $0.1.dueDate?.timeIntervalSinceNow
                }
                self.grid.reload()
            default:""
            }
        }

    }
    */
}
