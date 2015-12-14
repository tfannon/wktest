//
//  Protocols.swift
//  TeamMate
//
//  Created by Tommy Fannon on 12/10/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper


//the workpaper chooser needs to know about its owner and viewcontroller so it can present and save
protocol WorkpaperChooserDelegate {
    var workpaperOwner: Procedure { get }
    var owningViewController: UIViewController { get }
    func workpaperAddedCallback(wasAdded: Bool)
}