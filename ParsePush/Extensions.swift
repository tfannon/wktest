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
    
    /**
    Difference of self and the input arrays.
    
    :param: values Arrays to subtract
    :returns: Difference of self and the input arrays
    */
    func difference <T: Equatable> (values: [T]...) -> [T] {
        
        var result = [T]()
        
        elements: for e in self {
            if let element = e as? T {
                for value in values {
                    //  if a value is in both self and one of the values arrays
                    //  jump to the next iteration of the outer loop
                    if value.contains(element) {
                        continue elements
                    }
                }
                
                //  element it's only in self
                result.append(element)
            }
        }
        
        return result
        
    }
}

extension String {
    var length : Int {
        return self.characters.count
    }
    
    func substring(numberOfChars: Int) -> String
    {
        return (self as NSString).substringToIndex(numberOfChars)
    }
}
