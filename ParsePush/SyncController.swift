//
//  SyncController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 1/3/16.
//  Copyright © 2016 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import CircleProgressBar

class SyncController : UIViewController {

    @IBOutlet var circleProgressBar: CircleProgressBar!
    
    //MARK: - view controller
    override func viewDidLoad() {
        circleProgressBar.setProgress(0, animated: true)
    }
    
}