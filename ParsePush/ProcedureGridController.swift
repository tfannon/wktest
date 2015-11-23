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
    var sortedItems: [Procedure] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setupGrid()
        self.addColumns()
        self.createDataSource()
        self.styleGrid()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        getProcedures {
            self.dataSourceHelper.data = self.items
        }
    }

    override func viewDidLayoutSubviews() {
        let f = self.view.frame
        self.grid.frame = f
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
    
    func addColumns() {
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
    
    func addColumnWithTitle(key: String?, title: String, width: Float, textAlignment: NSTextAlignment, edgeInsets: UIEdgeInsets, cellClass: AnyClass? = nil, sortMode: SDataGridColumnSortMode? = nil) {
        var column: SDataGridColumn!
        if key != nil {
            column = SDataGridColumn(title: title, forProperty: key)
        } else {
            column = SDataGridColumn(title: title)
        }
        if cellClass != nil {
            column.cellType = cellClass!
        }
        column.width = width
        column.cellStyle.textAlignment = textAlignment
        column.cellStyle.contentInset = edgeInsets
        column.headerCellStyle.textAlignment = textAlignment
        column.headerCellStyle.contentInset = edgeInsets
        if sortMode != nil {
            column.sortMode = sortMode!
        }
        self.grid.addColumn(column)
    }
    
    //this needs to happen after data has loaded
    func setupSort() {
        let column = self.grid.columns.filter { $0.propertyKey == "dueDate" }.first! as! SDataGridColumn
        column.sortMode = SDataGridColumnSortModeBiState
    }
    
    func createDataSource() {
        self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        self.dataSourceHelper.delegate = self
    }
    
    func setupGrid() {
        self.grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 5, 52))
        self.view.addSubview(grid)
        self.grid.showPullToAction = true
        self.grid.pullToAction.delegate = self
    }
    
    func styleGrid() {
        let theme = SDataGridiOS7Theme()
        
        let headerRowStyle = self.createDataGridCellStyleWithFont(UIFont.boldShinobiFontOfSize(18), textColor:UIColor.whiteColor(),
            backgroundColor:UIColor.shinobiPlayBlueColor().shinobiLightColor())
        headerRowStyle.contentInset = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        theme.headerRowStyle = headerRowStyle

        let selectedCellStyle = self.createDataGridCellStyleWithFont(UIFont.shinobiFontOfSize(13), textColor: UIColor.whiteColor(), backgroundColor: UIColor.shinobiPlayBlueColor())
        theme.selectedCellStyle = selectedCellStyle
        
        let rowStyle = self.createDataGridCellStyleWithFont(UIFont.shinobiFontOfSize(13), textColor: UIColor.shinobiDarkGrayColor(), backgroundColor: UIColor.whiteColor())
        theme.rowStyle = rowStyle
        theme.alternateRowStyle = rowStyle
        
        let gridLineStyle = SDataGridLineStyle(width: 0.5, withColor: UIColor.lightGrayColor())
        theme.gridLineStyle = gridLineStyle
        
        let gridSectionHeaderStyle = SDataGridSectionHeaderStyle()
        gridSectionHeaderStyle.backgroundColor = UIColor.shinobiPlayBlueColor().shinobiBackgroundColor()
        gridSectionHeaderStyle.font = UIFont.boldShinobiFontOfSize(14)
        gridSectionHeaderStyle.textColor = UIColor.shinobiDarkGrayColor()
        theme.sectionHeaderStyle = gridSectionHeaderStyle
        
        self.grid.applyTheme(theme)
    }
    
    func createDataGridCellStyleWithFont(font: UIFont,
                                         textColor:UIColor,
                                         backgroundColor:UIColor) -> (SDataGridCellStyle) {
        
        let dataGridCellStyle = SDataGridCellStyle()
        dataGridCellStyle.textVerticalAlignment = UIControlContentVerticalAlignment.Center;
        dataGridCellStyle.font = font;
        dataGridCellStyle.textColor = textColor;
        dataGridCellStyle.backgroundColor = backgroundColor;
        return dataGridCellStyle;
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
    
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let procedure = items[row.rowIndex]
        let controller = ProcedureFormController(procedure: procedure)
        //let controller = ProcedureFormControllerViewController()
        //controller.procedure = items[row.rowIndex]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
        Services.sync { result in
            self.items = result!
            self.dataSourceHelper.data = self.items
            self.grid.pullToAction.actionCompleted()
        }
    }
    
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
}
