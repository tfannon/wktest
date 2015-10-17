//
//  MyWorkController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit


class MyWorkController: UIViewController, SDataGridDataSource/*, SDataGridDataSourceHelperDelegate*/ {
    
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
        
        let titleColumn = SDataGridColumn(title: "Title", forProperty: "title")
        titleColumn.sortMode = SDataGridColumnSortModeBiState
        grid.addColumn(titleColumn)
        
        let dueDateColumn = SDataGridColumn(title: "Due Date")
        grid.addColumn(dueDateColumn)
        
        let text1 = SDataGridColumn(title: "Text1")
        grid.addColumn(text1)
        
        let result = SDataGridColumn(title: "Result")
        grid.addColumn(result)
        
        self.view.addSubview(grid)
        self.grid = grid
        
        //self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        //self.dataSourceHelper.delegate = self
        getProcedures()
    }
    
    func getProcedures() {
        self.items = []
        Services.GetProcedures { result in
            if result?.count > 0 {
                result?.each {
                    self.items.append($0)
                }

                self.grid.reload()
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
            case "Result": text = procedure.testResults! == 0 ? "Fail" : "Pass"
            default: text = ""
        }
        textCell.textField.text = text
    }
}
