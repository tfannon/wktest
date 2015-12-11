//
//  FormHelper.swift
//  ParsePush
//
//  Created by Adam Rothberg on 11/12/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import DTFoundation

protocol SaveableFormControllerDelegate {
    func enableSave()
}

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
        visible: Bool = true,
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
        self.visible = visible && !identifier.startsWith("DatePicker")
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
    
    let controller : UITableViewController!
    let controllerAsDelegate : CustomCellDelegate!
    var data = [[CellData]]()
    
    private var hiddenSectionActualIndexes = Set<Int>()
    private func getActualVisibleSectionDataIndex(requestedSection : Int) -> Int {
        var counter = 0
        for i in 0..<sections.count {
            if !hiddenSectionActualIndexes.contains(i) {
                if counter++ == requestedSection {
                    return i
                }
            }
        }
        fatalError("getActualSectionDataIndex could not obtain index")
    }

    //
    // hides the provided sections from the table
    //  sections: is the array of sections to show in the tableview
    //  but we need to calculate the "actual" data[] index of these sections to hide
    //  so we can keep our internal record keeping straight.  For example, if 
    //  sections 6-9 and 11-14 are hidden, and we SHOW 7-10 - those positions are
    //  actually 11-14 in our internal data[] because 6-9 are missing from the table at this point.
    //
    func hideSections(sections : [Int], animation: UITableViewRowAnimation = .None) {
        // sections we send to deleteSections
        var sectionsToDelete = [Int]()
        // the corresponding index in data[] for the section we're hiding (see above)
        var actualIndexes = [Int]()
        // for each one to hide
        for section in sections {
            // get the actual index for data[]
            let actualIndex = self.getActualVisibleSectionDataIndex(section)
            // if it's not already hidden
            if !self.hiddenSectionActualIndexes.contains(actualIndex) {
                // add the actual to actualIndexes (so we can add them to hiddenSectionActualIndexes later)
                actualIndexes.append(actualIndex)
                // add the relative ones to sectionsToDelete for tableView.deleteSections
                sectionsToDelete.append(section)
            }
        }
        // internal record keeping of hiddenSectionActualIndexes
        actualIndexes.forEach{ x in hiddenSectionActualIndexes.insert(x) }

        // make magic in the table
        controller.tableView.beginUpdates()
        controller.tableView.deleteSections(NSIndexSet.fromArray(sectionsToDelete), withRowAnimation: animation)
        controller.tableView.endUpdates()
    }

    func hideRows(cell : UITableViewCell, data : CellData, indexPath: NSIndexPath, rowCount : Int) {
        self.tableView.beginUpdates()
        data.toggled = !data.toggled
        let section = indexPath.section
        var indexPaths = [NSIndexPath]()
        for i in 1...rowCount {
            self.getRelativeCellData(data, delta: i).visible = data.toggled
            indexPaths.append(NSIndexPath(forRow: i, inSection: section))
        }
        if data.toggled {
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
            cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Down)
        } else {
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
            cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Up)
        }
        self.tableView.endUpdates()
        if (data.toggled) {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    //
    // shows hidden rows in the table
    //  scrollDelta denotes which section to scroll to after they are made visible.  relative to the
    //  FIRST section shown (e.g. -1 would scroll to the last row in the prior section that is visible before this call)
    //
    func showSections(sections : [Int], animation: UITableViewRowAnimation = .None, scrollDelta : Int = 0) {

        // if we have any sections to show
        if sections.any() {
            // grab the first section - we do this so we know what kind of cell is being hidden
            let firstSectionToShow = sections.first!
            // this is the preceeding section that started visible when this function was called 
            //  (usu. the table row which initiated the show)
            let preceedingVisibleSectionActualIndex = self.getActualVisibleSectionDataIndex(firstSectionToShow - 1)
            // difference between the actual index in data[] and the sections to show
            let delta = preceedingVisibleSectionActualIndex - firstSectionToShow + 1
            // this is for tableView insertSections
            var sectionsToShow = [Int]()
            // for each one
            for section in sections {
                // we recalc to get the actual data[] index for the section
                let recalced = section + delta
                // if it's hidden
                if hiddenSectionActualIndexes.contains(recalced) {
                    // remove it from the hidden list
                    hiddenSectionActualIndexes.remove(recalced)
                    // this is passed to tableView.insertSections
                    sectionsToShow.append(section)
                }
            }
            
            // iOS magic
            controller.tableView.beginUpdates()
            controller.tableView.insertSections(NSIndexSet.fromArray(sectionsToShow), withRowAnimation: animation)
            controller.tableView.endUpdates()
            
            // this is the first indexPath of the first section to show
            let firstIndexPath = NSIndexPath(forRow: 0, inSection: sectionsToShow.first!)
            // this is the cell in that position
            let cell = self.tableView.cellForRowAtIndexPath(firstIndexPath)
            // which section to scroll to after sections are made visible
            let scrollToSection = firstIndexPath.section + scrollDelta
            let scrollToIndexPath = NSIndexPath(forRow: self.getNumberOfRowsInSection(scrollToSection) - 1, inSection: scrollToSection)
            
            let scroll = {
                self.tableView.scrollToRowAtIndexPath(scrollToIndexPath,
                    atScrollPosition: .Top, animated: true)
                self.tableView.alpha = 1
                self.tableView.userInteractionEnabled = true
            }
            
            // if HtmlCell - pain!
            // check the first html view every .1 seconds - when loaded, then scroll to it
            // we don't do it immediately because we want the true height of the loaded html to be considered
            //  for the scroll
            if let htmlCell = cell as? HtmlCell {
                let abc = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                self.tableView.addSubview(abc)
                self.tableView.bringSubviewToFront(abc)
                abc.center = self.tableView.center
                abc.hidesWhenStopped = true
                abc.hidden = false
                abc.startAnimating()
                self.tableView.userInteractionEnabled = false
                self.tableView.alpha = 0.9
                
                NSTimer.schedule(repeatInterval: 0.1, handler: { timer in
                    if htmlCell.isResized {
                        timer.invalidate()
                        abc.removeFromSuperview()
                        scroll()
                    }
                })
            }
            else {
                // NOT html - scroll immediately
                scroll()
            }
        }
    }

    func getNumberOfSections() -> Int {
        // Return the number of sections.
        let total = data.count
        let hidden = hiddenSectionActualIndexes.count
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
    
    func getRelativeCellData(data : CellData, delta : Int) -> CellData {
        let index = data.tag + delta
        return self.dataLookup[index]!
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
    
    lazy var numericCellWillDisplay : ((UITableViewCell, CellData) -> Void) =
    { cell, data in
        let textCell = cell as! TextCell
        textCell.delegate = self.controllerAsDelegate
        textCell.textField.placeholder = data.placeHolder
        textCell.textField.text = data.value as! String?
    }
    
    func getTextCellWillDisplay(
        keyboardType : UIKeyboardType = UIKeyboardType.Default,
        label : String? = nil) -> ((UITableViewCell, CellData) -> Void) {
        return { cell, data in
            let textCell = cell as! TextCell
            textCell.delegate = self.controllerAsDelegate
            textCell.textField.placeholder = data.placeHolder
            textCell.textField.text = nil
            if let v = data.value as? Double {
                let nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                nf.groupingSeparator = ""
                textCell.textField.text = nf.stringFromNumber(v)
            }
            else {
                textCell.textField.text = data.value as! String?
            }
            textCell.textField.keyboardType = keyboardType
            
            if let tcwl = textCell as? TextCellWithLabel {
                tcwl.label.text = label
            }
        }
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
                indexPath.getRelativeSection(x) }
            
            data.toggled = !data.toggled
            let show = data.toggled
            if show {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Down)
            }
            else {
                cell.accessoryView = DTCustomColoredAccessory(color: UIColor.lightGrayColor(), type: .Up)
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
        let dpData = self.getRelativeCellData(data, delta: 1)
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
