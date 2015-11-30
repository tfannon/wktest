//
//  FormHelper.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/12/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import DTFoundation

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
    var sectionsToHide : [Int]?
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
        sectionsToHide : [Int]? = nil,
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
        self.sectionsToHide = sectionsToHide
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
    
    private var hiddenSections = Set<Int>()
    private func getActualVisibleSectionDataIndex(requestedSection : Int) -> Int {
        var counter = 0
        for i in 0..<sections.count {
            if !hiddenSections.contains(i) {
                if counter++ == requestedSection {
                    return i
                }
            }
        }
        fatalError("getActualSectionDataIndex could not obtain index")
    }

    func hideSections(sections : [Int], animation: UITableViewRowAnimation = .None) {
        var sectionsToDelete = [Int]()
        var actualIndexes = [Int]()
        for section in sections {
            let actualIndex = self.getActualVisibleSectionDataIndex(section)
            if !self.hiddenSections.contains(actualIndex) {
                actualIndexes.append(actualIndex)
                sectionsToDelete.append(section)
            }
        }
        actualIndexes.forEach{ x in hiddenSections.insert(x) }

        controller.tableView.beginUpdates()
        controller.tableView.deleteSections(NSIndexSet.fromArray(sectionsToDelete), withRowAnimation: animation)
        controller.tableView.endUpdates()
    }

    func showSections(sections : [Int], animation: UITableViewRowAnimation = .None, scrollDelta : Int = 0) {

        if sections.any {
            let firstSectionToShow = sections.first!
            let preceedingVisibleSectionActualIndex = self.getActualVisibleSectionDataIndex(firstSectionToShow - 1)
            let delta = preceedingVisibleSectionActualIndex - firstSectionToShow + 1
            var sectionsToShow = [Int]()
            for section in sections {
                let recalced = section + delta
                if hiddenSections.contains(recalced) {
                    hiddenSections.remove(recalced)
                    sectionsToShow.append(section)
                }
            }
            
            controller.tableView.beginUpdates()
            controller.tableView.insertSections(NSIndexSet.fromArray(sectionsToShow), withRowAnimation: animation)
            controller.tableView.endUpdates()
            
            let firstIndexPath = NSIndexPath(forRow: 0, inSection: sectionsToShow.first!)
            let cell = self.tableView.cellForRowAtIndexPath(firstIndexPath)
            let scrollToIndexPath = firstIndexPath.getFirstRowAtRelativeSection(scrollDelta)
            
            // check the first html view every .1 seconds - when loaded, then scroll to it
            // we don't do it immediately because we want the true height of the loaded html to be considered
            //  for the scroll
            if let htmlCell = cell as? HtmlCell {
                var abc : UIActivityIndicatorView?
                abc = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                self.tableView.addSubview(abc!)
                self.tableView.bringSubviewToFront(abc!)
                abc!.center = self.tableView.center
                abc!.hidesWhenStopped = true
                abc!.hidden = false
                abc!.startAnimating()
                self.tableView.userInteractionEnabled = false
                self.tableView.alpha = 0.9
                
                NSTimer.schedule(repeatInterval: 0.1, handler: { timer in
                    if htmlCell.isResized {
                        timer.invalidate()
                        self.tableView.scrollToRowAtIndexPath(scrollToIndexPath,
                            atScrollPosition: .Top, animated: true)
                        abc?.removeFromSuperview()
                        self.tableView.alpha = 1
                        self.tableView.userInteractionEnabled = true
                    }
                })
            }
        }
    }

    func getNumberOfSections() -> Int {
        // Return the number of sections.
        let total = data.count
        let hidden = hiddenSections.count
        let n = total - hidden
        return n
    }
    
    func getNumberOfRowsInSection(section : Int) -> Int {
        let index = getActualVisibleSectionDataIndex(section)
        let n = data[index].filter { x in x.visible }.count
        return n
    }
    
    func getSectionTitle(section : Int) -> String {
        let index = getActualVisibleSectionDataIndex(section)
        let t = sections[index]
        return t
    }
    
    func getCellData(indexPath: NSIndexPath) -> CellData
    {
        let index = getActualVisibleSectionDataIndex(indexPath.section)
        let filtered = data[index].filter { d in return d.visible }
        return filtered[indexPath.row]
    }
    
    var tableView : UITableView {
        get { return controller.tableView }
    }
    
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
    
    lazy var hideSectionWillDisplay : ((UITableViewCell, CellData) -> Void) =
        { cell, data in
            cell.selectionStyle = .None
            if data.toggled {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Down)
            }
            else {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Up)
            }
        }
    
    lazy var hideSectionSelected : ((UITableViewCell, CellData, NSIndexPath) -> Void) =
        { cell, data, indexPath in
            
            let htmlIndexPaths = data.sectionsToHide!.map { x in
                indexPath.getFirstRowAtRelativeSection(x) }
            
            data.toggled = !data.toggled
            let show = data.toggled
            if show {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.grayColor(), type: .Down)
            }
            else {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.grayColor(), type: .Up)
            }

            let sections = htmlIndexPaths.map { x in x.section }
            if (show) {
                self.showSections(sections, animation: .Top, scrollDelta: -1)
            }
            else {
                self.hideSections(sections, animation: .Top)
            }
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
    

}
