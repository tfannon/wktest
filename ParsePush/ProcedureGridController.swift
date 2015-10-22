//
//  MyWorkController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class ProcedureGridController: UIViewController, SDataGridDataSourceHelperDelegate, SDataGridDelegate, SDataGridPullToActionDelegate {
    
    var items: [Procedure] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 5, 52))
        self.view.addSubview(grid)
        self.grid.showPullToAction = true
        self.grid.pullToAction.delegate = self
        
        self.addColumns()
        self.createDataSource()
        getProcedures {
            self.dataSourceHelper.data = self.items
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }
    
    func getProcedures(completed: ()->()) {
        self.items = []
        Services.getMyProcedures { result in
            if result?.count > 0 {
                result?.each {
                    self.items.append($0)
                }
                completed()
            }
        }
    }
    
    func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["title","parentType","parentTitle","workflowState",/*"workflowStateTitle",*/ "testResults","dueDate","reviewer","reviewDueDate"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Procedure.terminology[key]
            switch key {
            case "title": addColumnWithTitle(key, title: title!, width: 240, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

            case "parentType": addColumnWithTitle(key, title: "", width: 50, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), cellClass:DataGridImageCell.self)

            case "workflowState": addColumnWithTitle(key, title: title!, width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), cellClass:DataGridImageCell.self)
                
//            case "workflowStateTitle": addColumnWithTitle(key, title: "", width: 125, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "testResults": addColumnWithTitle(key, title: title!, width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "dueDate": addColumnWithTitle(key, title: title!, width: 120, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "reviewDueDate": addColumnWithTitle(key, title: "Review Due", width: 160, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title!, width: 125, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
        }
    }
    
    func addColumnWithTitle(key: String, title: String, width: Float, textAlignment: NSTextAlignment, edgeInsets: UIEdgeInsets, cellClass: AnyClass? = nil) {
        let column = SDataGridColumn(title: title, forProperty: key)
        if cellClass != nil {
            column.cellType = cellClass!
        }
        column.width = width
        column.cellStyle.textAlignment = textAlignment
        column.cellStyle.contentInset = edgeInsets
        column.headerCellStyle.textAlignment = textAlignment
        column.headerCellStyle.contentInset = edgeInsets
        self.grid.addColumn(column)
    }
    
    func createDataSource() {
        self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        self.dataSourceHelper.delegate = self
    }
    
    func setupGrid() {
    }


    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, populateCell cell: SDataGridCell!, withValue value: AnyObject!, forProperty propertyKey: String!, sourceObject object: AnyObject!) -> Bool {
        let procedure = object as! Procedure
        switch (propertyKey) {
            
        case "workflowState" :
            let wCell = cell as! DataGridImageCell
            wCell.state = WorkflowState(rawValue: procedure.workflowState)!
            //wCell.imageProvider = WorkflowState(rawValue: procedure.workflowState)!
            return true
            
//        case "workflowStateTitle" :
//            let wCell = cell as! SDataGridTextCell
//            wCell.text = WorkflowState(rawValue: procedure.workflowState)!.displayName
//            return true
            
        case "parentType" :
            let wCell = cell as! DataGridImageCell
            wCell.parentType = ObjectType(rawValue: procedure.parentType)!
            //wCell.imageProvider = ObjectType(rawValue: procedure.parentType)!
            return true
            
        case "testResults" :
            let wCell = cell as! SDataGridTextCell
            wCell.text = TestResults(rawValue: procedure.testResults)?.displayName
            return true
            
        case "dueDate","reviewDueDate" :
            let wCell = cell as! SDataGridTextCell
            wCell.text = procedure.dueDate?.toShortString()
            return true
            
        default: return false
        }
    }
    
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        
        let controller = ProcedureFormControllerViewController()
        controller.procedure = items[row.rowIndex]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
        getProcedures {
            self.dataSourceHelper.data = self.items
            self.grid.pullToAction.actionCompleted()
        }
    }
    

}
