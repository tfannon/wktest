import Foundation
import UIKit



class ChangeGridController: UIViewController, SDataGridDataSourceHelperDelegate, SDataGridDelegate {
    
    var items: [Change] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    var detailWidth : CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Tracking"
        self.setupGrid()
        self.addColumns()
        self.createDataSource()
        self.styleGrid()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSourceHelper.data = items
    }
    
    override func viewDidLayoutSubviews() {

        let size = self.view.bounds
        let cWidth = Float((size.width - detailWidth) / 3.0)
        for i in 0...2 {
            let c = grid.columns[i] as! SDataGridColumn
            c.width = cWidth
        }
        grid.frame = size
        grid.reload()
    }
    
    func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["title","user","date","details"]
        }
        let cWidth = Float((grid.frame.width - detailWidth) / 3.0)
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            switch key {
                
            case "title": addColumnWithTitle(key, title: "Action", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "user": addColumnWithTitle(key, title: "User", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "date": addColumnWithTitle(key, title: "Date", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "details": addColumnWithTitle(key, title: "", width: Float(detailWidth), textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

            default:
                fatalError("addColumns has not been handled")
                
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
    
    func createDataSource() {
        self.dataSourceHelper = SDataGridDataSourceHelper(dataGrid: grid)
        self.dataSourceHelper.delegate = self
    }
    
    func setupGrid() {
        self.grid = ShinobiDataGrid(frame: CGRectInset(self.view.bounds, 5, 52))
        self.view.addSubview(grid)
        let views : [String : AnyObject] = ["grid" : grid]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[grid]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[grid]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))
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
        let change = object as! Change
        
        switch (propertyKey) {

        case "title" :
            let wCell = cell as! SDataGridTextCell
            wCell.text = change.title
            return true
            
        case "user" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  change.user
            return true
            
        case "date" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  change.date?.ToLongDateStyle()
            return true
            
        case "details":
            let wCell = cell as! SDataGridTextCell
            wCell.text = (change.details?.count > 0) ? ">" : ""
            return true
            
        default: return false
        }
    }
    
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let change = items[row.rowIndex]
        if (change.details?.count > 0)
        {
            let vc : ChangeDetailGridController = Misc.getViewController("ChangeTracking", viewIdentifier: "ChangeDetailGridController")
            vc.items = change.details!
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            grid.clearSelectionWithAnimation(false)
        }
    }
}
