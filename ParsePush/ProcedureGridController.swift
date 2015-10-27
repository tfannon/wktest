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
            gridColumnsOrder = ["sync","title","parentType","parentTitle","workflowState",/*"workflowStateTitle",*/ "testResults","dueDate","reviewer","reviewDueDate"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Procedure.getTerminology(key)
            switch key {

            case "sync": addColumnWithTitle(key, title: "Sync", width: 10, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "title": addColumnWithTitle(key, title: title, width: 220, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))

            case "parentType": addColumnWithTitle(key, title: "", width: 50, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), cellClass:DataGridImageCell.self)

            case "workflowState": addColumnWithTitle(key, title: title, width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), cellClass:DataGridImageCell.self)
                
            case "testResults": addColumnWithTitle(key, title: title, width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "dueDate": addColumnWithTitle(key, title: title, width: 120, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "reviewDueDate": addColumnWithTitle(key, title: "Review Due", width: 160, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: 125, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
        }
    }
    
    func addColumnWithTitle(key: String?, title: String, width: Float, textAlignment: NSTextAlignment, edgeInsets: UIEdgeInsets, cellClass: AnyClass? = nil) {
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
        self.grid.addColumn(column)
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
        case "title" :
            let wCell = cell as! SDataGridTextCell
            
            if procedure.syncState == .Modified {
                wCell.backgroundColor = UIColor.orangeColor()
            }
            else if procedure.syncState == .New {
                wCell.backgroundColor = UIColor.lightGrayColor()
            }
            else {
                wCell.backgroundColor = UIColor.clearColor()
            }
            
            return false

        case "sync" :
            let wCell = cell as! SDataGridTextCell
            wCell.text = String(procedure.syncState)
//            switch value {
//                case "M"
//            }
            return true
            
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
        let controller = ProcedureFormControllerViewController()
        controller.procedure = items[row.rowIndex]
        //when we navigate to detail view we clear any sync status
        controller.procedure.syncState = .Unchanged
        Services.save(controller.procedure)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
        Services.sync { result in
            self.items = result!
            self.dataSourceHelper.data = self.items
            self.grid.pullToAction.actionCompleted()
        }
    }
}
