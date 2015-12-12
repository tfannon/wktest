//
//  CellData.swift
//  TeamMate
//
//  Created by Adam Rothberg on 12/12/15.
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
    var sectionsToHide : [Int]?
    var isAddCell : Bool = false
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
        objectType : ObjectType = ObjectType.None,
        value : Any? = nil,
        label : String? = nil,
        imageName : String? = nil,
        isAddCell : Bool = false,
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
        self.isAddCell = isAddCell
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
