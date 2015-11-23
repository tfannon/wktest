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

extension NSDate {
    func ToLongDateStyle() -> String {
        return self.toString(dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
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
    func substringFrom(startingIndex: Int) -> String
    {
        return (self as NSString).substringFromIndex(startingIndex)
    }
    
    func startsWith(string: String) -> Bool
    {
        let range = (self as NSString).rangeOfString(string, options:.CaseInsensitiveSearch)
        return range.location == 0
    }
}

extension UITableViewCell {
    func enable(on: Bool) {
        self.userInteractionEnabled = on
        self.selectionStyle = .None
        for view in contentView.subviews {
            view.userInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }

    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}

extension Array {
    func any(condition : (Array.Element) -> Bool) -> Bool {
        for x in self {
            if condition(x) {
                return true
            }
        }
        return false
    }
//    func any() -> Bool {
//        return self.count > 0
//    }
}

extension NSIndexPath {
    func getNextRow() -> NSIndexPath {
        return getRelativeRow(1)
    }
    func getRelativeRow(deltaRow : Int) -> NSIndexPath
    {
        let ip = NSIndexPath(forRow: self.row + deltaRow, inSection: self.section)
        return ip
    }
    func getFirstRowNextSection() -> NSIndexPath {
        return getFirstRowAtRelativeSection(1)
    }
    func getFirstRowAtRelativeSection(deltaSection : Int) -> NSIndexPath {
        let ip = NSIndexPath(forRow: 0, inSection: self.section + deltaSection)
        return ip
    }
}

extension UITableView {
    func dequeueReusableCellWithNibName(nibName : String!) -> UITableViewCell? {
        var cell = self.dequeueReusableCellWithIdentifier(nibName)
        if (cell == nil) {
            self.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
            cell = self.dequeueReusableCellWithIdentifier(nibName)
        }
        return cell
    }
}

extension NSTimer {
    /**
     Creates and schedules a one-time `NSTimer` instance.
     
     - Parameters:
     - delay: The delay before execution.
     - handler: A closure to execute after `delay`.
     
     - Returns: The newly-created `NSTimer` instance.
     */
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    /**
     Creates and schedules a repeating `NSTimer` instance.
     
     - Parameters:
     - repeatInterval: The interval (in seconds) between each execution of
     `handler`. Note that individual calls may be delayed; subsequent calls
     to `handler` will be based on the time the timer was created.
     - handler: A closure to execute at each `repeatInterval`.
     
     - Returns: The newly-created `NSTimer` instance.
     */
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}

