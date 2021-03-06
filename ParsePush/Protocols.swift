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
    var workpaperOwner: BaseObject { get }
    var owningViewController: UIViewController { get }
    func workpaperAddedCallback(wasAdded: Bool, workpaper: Workpaper)
}

protocol ProgressDelegate {
    func setProgress(progress: Float)
    func setMessage(message: String)
}
class ProgressDelegateHelper {
    class func set(delegate : ProgressDelegate, message: String?, progress : Float) {
        if let m = message {
            delegate.setMessage(m)
        }
        delegate.setProgress(progress)
    }
}