//
//  BaseGridController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/23/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

protocol ObjectProvider {
    typealias T : BaseObject
    var items: [T] { get set }
    var sortedItems: [T] { get set }
}

class BaseGridController: UIViewController, SDataGridDataSourceHelperDelegate, SDataGridDelegate, SDataGridPullToActionDelegate, ObjectProvider {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var items: [BaseObject] = []
    var sortedItems: [BaseObject] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGrid()
        self.addColumns()
        self.createDataSource()
        self.styleGrid()
    }
    
    
    override func viewDidLayoutSubviews() {
        let f = self.view.frame
        self.grid.frame = f
    }
    
    func setupGrid() {
        self.grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 5, 52))
        self.view.addSubview(grid)
        self.grid.showPullToAction = true
        self.grid.pullToAction.delegate = self
    }
    
    func addColumns() {
        preconditionFailure("This method must be overridden") 
    }
    
    
    func createDataSource() {
        self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        self.dataSourceHelper.delegate = self
    }
    
    
    //MARK: - style grid
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
    
    //MARK: - add columns
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
    
    func pullToActionTriggeredAction(pullToAction: SDataGridPullToAction!) {
        //override this if supports refresh
    }

    
    
    
}