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
    
    @IBOutlet weak var button: UIButton!
    
    public override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .None
        
    }
    var i = false
    @IBAction func buttonPressed(sender: UIButton!) {
        sender.backgroundColor = (i) ? UIColor.blueColor() : UIColor.greenColor()
        i = !i
    
        let storyboard = UIStoryboard(name: "Procedure", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ChangesViewController") as! ChangesController
        vc.changes = Mock.getProcedures()[0].changes
        formViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    

}

public final class NavigationRow: Row<String, NavigationCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<NavigationCell>(nibName: "NavigationCell")
    }
}