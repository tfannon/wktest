//
//  NotificationController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/2/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

class NotificationController: UITableViewController {
    
    var items: [Notification] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getNotifications", forControlEvents: .ValueChanged)
        
        getNotifications()
    }
    
    func getNotifications() {
        Services.getUnreadNotifications() { (notifications:[Notification]?) in
            if notifications?.count > 0 {
                self.items = notifications!
                self.tableView.separatorStyle = .SingleLine;
                self.tableView.reloadData()
            }
            else {
                self.tableView.separatorStyle = .None
                self.displayEmptyMessage()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func displayEmptyMessage() {
        // Display a message when the table is empty
        let messageLabel = UILabel(frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        messageLabel.text = "No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center;
        messageLabel.font = UIFont(name: "Palatino-Italic", size:20)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell
        let item = self.items[indexPath.row]
        cell.labelTitle.text = item.title
        cell.labelDescription.text = item.description
        //handle the icons
        return cell
    }
    
    
}
