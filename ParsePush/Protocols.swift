//
//  Protocols.swift
//  TeamMate
//
//  Created by Tommy Fannon on 12/10/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import ObjectMapper

/*what i really want to be able to do is ad id to Mappable but i'll try this for now
protocol Saveable {
    var id: Int? { get }
}
*/

//the workpaper chooser needs to know about its owner and viewcontroller so it can present and save
protocol WorkpaperChooserDelegate {
    var workpaperOwner: Procedure { get }
    var owningViewController: UIViewController { get }
    func workpaperAddedCallback(wasAdded: Bool)
}