import Foundation
import UIKit



class ChangeGridController: UIViewController, SDataGridDataSourceHelperDelegate, SDataGridDelegate {

    private var items: [Change] = []
    var grid: ShinobiDataGrid!
    var gridColumnSortOrder = [String:String]()
    var gridColumnsOrder: [String]!
    var dataSourceHelper: SDataGridDataSourceHelper!
    
    var changes : [Change] {
        get { return items }
        set {
            items = newValue.sort(
                { c1, c2 in
                    if c1.date! == c1.date! {
                        return (c1.id > c2.id)
                    }
                    return c1.date!.isLaterThanDate(c2.date!)
            })
        }
    }
    
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
        let f = self.view.frame
        self.grid.frame = f
    }
    
    var detailWidth : CGFloat = 100
    private var cWidth : Float {
        get {
            let w = Float((self.grid.frame.width - detailWidth) / 3.0)
            return w
        }
    }
    
    func didFinishLayingOutShinobiDataGrid(grid : ShinobiDataGrid) {
        for i in 0...2 {
            let c = grid.columns[i] as! SDataGridColumn
            c.width = cWidth
        }
        grid.reload()
    }
    
    func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["title","user","date","details"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            switch key {
                
            case "title": addColumnWithTitle(key, title: "Action", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "user": addColumnWithTitle(key, title: "User", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "date": addColumnWithTitle(key, title: "Date", width: cWidth, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "details": addColumnWithTitle(key, title: "", width: Float(detailWidth), textAlignment: NSTextAlignment.Right, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))

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
        if key == "details" {
            let style = SDataGridCellStyle()
            let f = grid.defaultCellStyleForRows.font
            let f2 = UIFont.boldSystemFontOfSize(f.pointSize * 1.25)
            style.font = f2
            column.cellStyle.textColor = UIColor.lightGrayColor()
            column.cellStyle.font = style.font
        }
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
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            formatter.timeStyle = .MediumStyle
            
            let wCell = cell as! SDataGridTextCell
            wCell.text =  (change.date == nil) ? "" : formatter.stringFromDate(change.date!)
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
            vc.details = change.details!
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            grid.clearSelectionWithAnimation(false)
        }
    }
}
