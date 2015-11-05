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
        super.setup()
        height = { 60 }
        selectionStyle = .Default
        accessoryType = .DisclosureIndicator
    }
}

public final class NavigationRow: Row<String, NavigationCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<NavigationCell>(nibName: "NavigationCell")
    }
}