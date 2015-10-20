//
//  MyWorkController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class MyWorkController: UIViewController, SDataGridDataSourceHelperDelegate {
    
    var items: [Procedure] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 10, 50))
        self.view.addSubview(grid)
        
        self.addColumns()
        self.createDataSource()
        getProcedures {
            self.dataSourceHelper.data = self.items
            //self.grid.reload()
        }
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
            gridColumnsOrder = ["title","parent","workflowState","testResults","dueDate"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Procedure.terminology[key]!
            switch key {
            case "title": addColumnWithTitle(key, title: title, width: 285, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: 150, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
            
        }
        
    }
    
    func addColumnWithTitle(key: String, title: String, width: Float, textAlignment: NSTextAlignment, edgeInsets: UIEdgeInsets) {
        let column = SDataGridColumn(title: title, forProperty: key)
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


    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, displayValueForProperty propertyKey: String!, withSourceObject object: AnyObject!) -> AnyObject! {
        return nil
        
//        let procedure = object as! Procedure
//        switch (propertyKey) {
//            
//        case "workflowState" :
//            let workflowState = WorkflowState(rawValue: procedure.workflowState)!
//            return workflowState.imageName
//            
//        case "testResults" :
//            let testResult = TestResultsType(rawValue: procedure.testResults!)
//            return testResult!.imageName
//            

    }

    /*
    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, populateCell cell: SDataGridCell!, withValue value: AnyObject!, forProperty propertyKey: String!, sourceObject object: AnyObject!) -> Bool {
        let procedure = object as! Procedure
        switch (propertyKey) {
            
        case "workflowState" :
            let workflowState = WorkflowState(rawValue: procedure.workflowState)!
            return workflowState.imageName
            
        case "testResults" :
            let resultsCell = cell as! SDataGridTextCell
            resultsCell.text = procedure.testResults! == 1 ? "Fail" : "Pass"
            return true;
//            let passFailCell = cell as! PassFailCell
            
        default: return false
        }
    }*/
}
