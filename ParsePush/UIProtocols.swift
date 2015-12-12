//
//  UIProtocols.swift
//  TeamMate
//
//  Created by Tommy Fannon on 12/12/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

protocol SaveableFormController {
    func enableSave()
    func childSaved(child : BaseObject)
    func childCancelled(child : BaseObject)
    var savedChildIndexPath : NSIndexPath? { get set }
    var parentForm : SaveableFormController? { get set }
}
