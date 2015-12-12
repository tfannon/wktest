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
    
    override func viewWillDisappear(animated: Bool) {
        //rebuild the prefs using column data which has new order and width
        self.gridColumnPrefs = (self.grid.columns as! [SDataGridColumn]).map { ColumnPrefs(key:$0.propertyKey, width:
            Int($0.width)) }
        
        //convert to something we can store
        let prefsData = NSKeyedArchiver.archivedDataWithRootObject(gridColumnPrefs)
        
        //let order = self.grid.columns.map { $0.propertyKey }
        NSUserDefaults.standardUserDefaults().setObject(prefsData, forKey: "procedureColumnPrefs")
    }

    func getProcedures(completed: ()->()) {
        self.items = []
        self.sortedItems = []
        Services.getMyData { result in
            if result?.procedures.count > 0 {
                result?.procedures.each {
                    self.items.append($0)
                    //print($0.issueIds, " : ", $0.workpaperIds)
                }
                self.sortedItems = self.items
                completed()
            }
        }
    }
    
    let defaults = [
        ColumnPrefs(key: "sync", width:75),
        ColumnPrefs(key: "title", width:220),
        ColumnPrefs(key: "parentType", width:50),
        ColumnPrefs(key: "parentTitle", width:125),
        ColumnPrefs(key: "workflowState", width:63),
        ColumnPrefs(key: "workflowStateTitle", width:100),
        ColumnPrefs(key: "tester", width:125),
        ColumnPrefs(key: "testResults", width:100),
        ColumnPrefs(key: "dueDate", width:100),
        ColumnPrefs(key: "reviewer", width:125),
        ColumnPrefs(key: "reviewDueDate", width:60)
    ]
    
    
    //needs to be pushed up to base
    override func addColumns() {
        if let prefsData = NSUserDefaults.standardUserDefaults().objectForKey("procedureColumnPrefs") as? NSData {
            gridColumnPrefs = NSKeyedUnarchiver.unarchiveObjectWithData(prefsData) as? [ColumnPrefs]
        }
        //if not use the defaults
        if gridColumnPrefs == nil {
            gridColumnPrefs = defaults
        }
        for x in gridColumnPrefs {
            let key = x.key
            let width = x.width
            let title = Procedure.getTerminology(key)
            switch key {

            case "sync": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5))
                
            case "title": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

            case "parentType": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "parentTitle": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))

            case "workflowState": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "tester": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
                
            case "workflowStateTitle": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "testResults": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "dueDate": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), sortMode: SDataGridColumnSortModeTriState)
                
            case "reviewDueDate": addColumnWithTitle(key, title: title, width: width, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: width, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
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
    
 

    func shinobiDataGrid(grid: ShinobiDataGrid!, didEndResizingColumn column: SDataGridColumn!, fromWidth oldWidth: CGFloat, toWidth newWidth: CGFloat) {
        //print ("was\(column.width) is\(newWidth)")
        //set this or it wont be remembered when navigating away then back or when persisting
        column.width = newWidth
    }

    //can probably push this up when form support comes in for all
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let procedure = items[row.rowIndex] as! Procedure
        let controller = ProcedureFormController.create()
        controller.primaryObject = procedure
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    override func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
//        Services.sync { result in
//            self.items = result!.procedures
//            self.dataSourceHelper.data = self.items
//            self.grid.pullToAction.actionCompleted()
//        }
//    }
//    
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
