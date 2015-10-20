//
//  MyWorkController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class MyWorkController: UIViewController, SDataGridDataSource, SDataGridDataSourceHelperDelegate {
    
    var items: [Procedure] = []
    var grid: ShinobiDataGrid!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let grid = ShinobiDataGrid(frame: self.view.bounds)
        let grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 10, 50))
        grid.defaultCellStyleForAlternateRows = SDataGridCellStyle(backgroundColor: UIColor.lightGrayColor(), withTextColor: nil, withFont: nil)
        grid.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        grid.dataSource = self
        
        var col = SDataGridColumn(title: "Title", forProperty: "title")
        col.width = 225
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        col = SDataGridColumn(title: "State", forProperty: "workflowState"/* cellType:WorkflowStateCell.self, headerCellType:nil*/)
        col.width = 150
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)

        col = SDataGridColumn(title: "Test Results", forProperty: "testResults"/*  cellType:PassFailCell.self, headerCellType:nil*/)
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        col = SDataGridColumn(title: "Tester", forProperty: "tester")
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        col = SDataGridColumn(title: "Due Date", forProperty: "dueDate")
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        col = SDataGridColumn(title: "Reviewer", forProperty: "reviewer")
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        col = SDataGridColumn(title: "Review Due Date", forProperty: "reviewDueDate")
        col.sortMode = SDataGridColumnSortModeTriState
        grid.addColumn(col)
        
        self.view.addSubview(grid)
        self.grid = grid
        
        self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        self.dataSourceHelper.delegate = self
        
        getProcedures()
    }
    
    func getProcedures() {
        self.items = []
        Services.getMyProcedures { result in
            if result?.count > 0 {
                result?.each {
                    self.items.append($0)
                }
                //self.grid.reload()
                self.dataSourceHelper.data = result
            }
        }
    }
    

    func shinobiDataGrid(grid: ShinobiDataGrid!, numberOfRowsInSection sectionIndex: Int) -> UInt  {
        return UInt(items.count)
    }
    
    func shinobiDataGrid(grid: ShinobiDataGrid!, prepareCellForDisplay cell: SDataGridCell!) {
        let procedure = items[cell.coordinate.row.rowIndex]
        let textCell = cell as! SDataGridTextCell
        var text: String?
        switch textCell.coordinate.column.title {
            case "Title" : text = procedure.title
            case "Due Date": text = procedure.dueDate
            case "Text1": text = procedure.text1
            case "Text2": text = procedure.text2
            case "Text3": text = procedure.text3
            case "Result": text = procedure.testResults == 1 ? "Fail" : "Pass"
            case "Result 1": text = procedure.resultsText1
            case "Result 2": text = procedure.resultsText2
            case "Result 3": text = procedure.resultsText3
            default: text = ""
        }
        textCell.textField.text = text
    }
    
    /*
    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, displayValueForProperty propertyKey: String!, withSourceObject object: AnyObject!) -> AnyObject! {
        
        let procedure = object as! Procedure
        switch (propertyKey) {
            
        case "workflowState" :
            let workflowState = WorkflowState(rawValue: procedure.workflowState)!
            return workflowState.imageName
            
        case "testResults" :
            let testResult = TestResultsType(rawValue: procedure.testResults!)
            return testResult!.imageName
            
        default: return nil
        }
    }
    */
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
