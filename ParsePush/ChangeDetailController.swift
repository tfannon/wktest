import Foundation
import UIKit



class ChangeDetailGridController: UIViewController, SDataGridDataSourceHelperDelegate, SDataGridDelegate {
    
    private var items: [ChangeDetail] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    var details : [ChangeDetail] {
        get { return items }
        set {
            items = newValue.sort(
                { c1, c2 in c1.label ?? "" < c2.label ?? "" })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Tracking Detail"
        self.setupGrid()
        self.addColumns()
        self.createDataSource()
        self.styleGrid()
        
        self.grid.selectionMode = SDataGridSelectionModeNone
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSourceHelper.data = items
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        
        let size = self.view.bounds
        let cWidth = Float(size.width / CGFloat(self.grid.columns.count))
        for c in grid.columns.map({ x in x as! SDataGridColumn }) {
            c.width = cWidth
        }
        grid.frame = size
        grid.reload()
    }
    
    func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["label","priorValue","currentValue"]
        }
        let cWidth = Float(grid.frame.width / 3.0)
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            switch key {
                
            case "label": addColumnWithTitle(key, title: "Label", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "priorValue": addColumnWithTitle(key, title: "Previous Value", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
                
            case "currentValue": addColumnWithTitle(key, title: "Current Value", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
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
        let detail = object as! ChangeDetail
        
        switch (propertyKey) {
            
        case "label" :
            let wCell = cell as! SDataGridTextCell
            wCell.text = detail.label
            return true
            
        case "priorValue" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  detail.priorValue
            return true
            
        case "currentValue" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  detail.currentValue
            return true
            
        default: return false
        }
    }
}
