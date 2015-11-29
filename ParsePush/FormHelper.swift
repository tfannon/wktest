//
//  FormHelper.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/12/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class CellData {
    static var tagCount = 0
    
    var label : String?
    var value : Any?
    var nibIdentifier : String?
    var imageName : String?
    var placeHolder : String?
    var identifier : String?
    var style : UITableViewCellStyle?
    var visible : Bool = true
    var toggled : Bool = false
    var selectedIfAccessoryButtonTapped : Bool = false
    private var initFunction : (() -> UITableViewCell)?
    private var willDisplayFunction : ((UITableViewCell, CellData) -> Void)?
    private var selectedFunction : ((UITableViewCell, CellData, NSIndexPath) -> Void)?
    private var changedFunction : ((UITableViewCell, CellData) -> Void)?
    let tag = tagCount++
    var cell : UITableViewCell?

    private let _uuid = NSUUID().UUIDString
    var uuid: String! {
        get {
            return _uuid
        }
    }
    
    init (
        identifier : String,
        value : Any? = nil,
        label : String? = nil,
        imageName : String? = nil,
        placeHolder: String? = nil,
        toggled: Bool = false,
        selectedIfAccessoryButtonTapped: Bool = false,
        style : UITableViewCellStyle? = nil,
        initialize : (() -> UITableViewCell)? = nil,
        willDisplay : ((UITableViewCell, CellData) -> Void)? = nil,
        selected: ((UITableViewCell, CellData, NSIndexPath) -> Void)? = nil,
        changed: ((UITableViewCell, CellData) -> Void)? = nil
        )
    {
        if identifier.substring(1) == "_" {
            self.identifier = identifier.substringFrom(1)
        }
        else {
            self.nibIdentifier = identifier
        }
        self.label = label
        self.value = value
        self.style = style
        self.imageName = imageName
        self.selectedIfAccessoryButtonTapped = selectedIfAccessoryButtonTapped
        self.placeHolder = placeHolder
        self.toggled = toggled
        self.initFunction = initialize
        self.willDisplayFunction = willDisplay
        self.selectedFunction = selected
        self.changedFunction = changed
        self.visible = !identifier.startsWith("DatePicker")
    }
    func initialize() -> UITableViewCell {
        if let f = initFunction {
            return f()
        }
        return UITableViewCell(style: self.style ?? .Default, reuseIdentifier: self.identifier)
    }
    func willDisplay(cell : UITableViewCell) {
        willDisplayFunction?(cell, self)
    }
    func selected(cell : UITableViewCell, indexPath: NSIndexPath) {
        selectedFunction?(cell, self, indexPath)
    }
    func changed(cell : UITableViewCell) {
        changedFunction?(cell, self)
    }
}

class FormHelper {
    
    private let controller : UITableViewController!
    private let controllerAsDelegate : CustomCellDelegate!
    var data = [[CellData]]()
    var hiddenSections = Set<Int>()
    
    private var _sections = [String]()
    var sections : [String] { get { return _sections } }
    func addSections(titles : [String]) {
        _sections = titles
    }
    func addSection(title : String, data cellData: [CellData]) {
        _sections.append(title)
        data.append(cellData)
    }
    
    private lazy var dataLookup : [Int : CellData] = {
        var lookup = [Int : CellData]()
        for i in 0..<self.data.count {
            for j in 0..<self.data[i].count {
                let d = self.data[i][j]
                lookup[d.tag] = d
            }
        }
        return lookup
    }()
    
    
    init (controller : UITableViewController) {
        self.controller = controller
        self.controllerAsDelegate = controller as! CustomCellDelegate
    }
    
    lazy var textCellWillDisplay : ((UITableViewCell, CellData) -> Void) =
        { cell, data in
            let textCell = cell as! TextCell
            textCell.textField.text = data.value as! String?
            textCell.textField.placeholder = data.placeHolder
            textCell.delegate = self.controllerAsDelegate
        }
    
    lazy var textViewWillDisplay : ((UITableViewCell, CellData) -> Void) =
        { cell, data in
            let textCell = cell as! TextAutoSizeCell
            textCell.textString = data.value as? String ?? ""
            textCell.delegate = self.controllerAsDelegate
        }

    lazy var htmlCellWillDisplay : ((UITableViewCell, CellData) -> Void) =
        { cell, data in
            let textCell = cell as! HtmlCell
            textCell.delegate = self.controllerAsDelegate
            textCell.textString = data.value as! String? ?? ""
        }

    lazy var dateCellWillDisplay : ((UITableViewCell, CellData) -> Void) =
        { cell, data in
            cell.selectionStyle = .None
            cell.detailTextLabel?.textColor = cell.textLabel?.textColor
        }
    
    lazy var dateCellSelected : ((UITableViewCell, CellData, NSIndexPath) -> Void) =
        { cell, data, indexPath in
        let indexPath = self.controller.tableView.indexPathForCell(cell)!
        let dpIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        let dpTag = data.tag + 1
        let dpData = self.dataLookup[dpTag]!
        let currentlyVisible = dpData.visible
        dpData.visible = !dpData.visible
        self.controller.tableView.beginUpdates()
        if currentlyVisible {
            self.controller.tableView.deleteRowsAtIndexPaths([dpIndexPath], withRowAnimation: .Top)
        }
        else {
            self.controller.tableView.insertRowsAtIndexPaths([dpIndexPath], withRowAnimation: .Top)
        }
        self.controller.tableView.endUpdates()
        
        // if we're making a picker visible
        // remove any visible datetimepicker cells that aren't this one
        if dpData.visible {
            for otherCell in self.controller.tableView.visibleCells {
                if let _ = otherCell as? DatePickerNullableCell {
                    let otherIndexPath = self.controller.tableView.indexPathForCell(otherCell)!
                    if (otherIndexPath != dpIndexPath) {
                        let otherData = self.getCellData(otherIndexPath)
                        otherData.visible = false
                        self.controller.tableView.beginUpdates()
                        self.controller.tableView.deleteRowsAtIndexPaths([otherIndexPath], withRowAnimation: .Top)
                        self.controller.tableView.endUpdates()
                        // there can be only one - so we're done
                        break
                    }
                }
            }
        }
    }
    
    func getSectionTitle(section : Int) -> String {
        var visibleSections = [String]()
        for i in 0..<sections.count {
            if !hiddenSections.contains(i) {
                visibleSections.append(sections[i])
            }
        }
        return visibleSections[section]
    }
    
    func getCellData(indexPath: NSIndexPath) -> CellData
    {
        var visibleSections = [[CellData]]()
        for i in 0..<data.count {
            if !hiddenSections.contains(i) {
                visibleSections.append(data[i])
            }
        }
        let filtered = visibleSections[indexPath.section].filter { d in return d.visible }
        return filtered[indexPath.row]
    }

}
