//
//  FirebaseHelper.swift
//  ParsePush
//
//  Created by Tommy Fannon on 9/14/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import Firebase

class FirebaseHelper {
    static var Root = Firebase(url:"https://SHINING-TORCH-5343.firebaseio.com")
    static var Devices = Root.childByAppendingPath("devices")
}