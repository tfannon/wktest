//
//  Extensions.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation


    extension Array{
        func each(each: (Element) -> ()){
            for object: Element in self {
                each(object)
            }
        }
    }
