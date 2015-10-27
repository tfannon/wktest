//
//  NavigationRow.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/26/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class NavigationCell : Cell<String>, CellType {
    
    public override func setup() {
        height = { 60 }
        super.setup()
        selectionStyle = .Default
        accessoryType = .DisclosureIndicator
        formViewController()?.tableView?.style
    }
}

public final class NavigationRow: Row<String, NavigationCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<NavigationCell>(nibName: "NavigationCell")
    }
}