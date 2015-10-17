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
    
    var items: [[Notification]] = [[],[]]  //0 - workflow,  1 - assignment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getNotifications", forControlEvents: .ValueChanged)
        
        getNotifications()
    }
    
    func getNotifications() {
        self.items = [[],[]]
        Services.getUnreadNotifications() { (notifications:[Notification]?) in
            if notifications?.count > 0 {
                notifications?.each {
                    let type = NotificationType(rawValue: $0.eventType!)!
                    switch type {
                        case .Assignment: self.items[0].append($0)
                        case .Workflow: self.items[1].append($0)
                    }
                }
                self.tableView.separatorStyle = .SingleLine;
            }
            else {
                self.items.removeAll()
                self.tableView.separatorStyle = .None
                self.displayEmptyMessage()
            }
            self.tableView.reloadData()

            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            let title = "Last update: \(formatter.stringFromDate(NSDate()))"
            let attrs = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            let attributedString = NSAttributedString(string: title, attributes: attrs)
            self.refreshControl?.attributedTitle = attributedString
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationHeaderCell") as! NotificationHeaderCell
        var image: UIImage
        var title: String = ""
        switch section {
            case 0: image = UIImage(named: "icons_workflow")!
                title = "Workflow"
            case 1: image = UIImage(named: "icons_users")!
                title = "Assignments"
            default: image = UIImage(named: "bad")!
        }
        cell.imageNotificationType.image = image
        cell.labelNotificationType.text = title
        return cell
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
        return items[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell
        let item = self.items[indexPath.section][indexPath.row]
        cell.labelTitle.text = item.title
        cell.labelDescription.text = item.description
        var image: UIImage
        let objectType = ObjectType(rawValue: item.objectType!)!
        //handle the icons
        switch objectType {
            case .Procedure: image = UIImage(named: "icons_procedure")!
            case .Control: image = UIImage(named: "icons_control")!
            default: image = UIImage(named: "icons_xxx")!
        }
        cell.imageObjectType.image = image
        //handle workflow state if workflow
        var imageName: String?
        if let state = item.workflowState {
            let workflowState = WorkflowState(rawValue: state)!
            switch workflowState {
                case .NotStarted: imageName = "icons_notstarted"
                case .InProgress: imageName =  "icons_inprogress"
                case .Completed: imageName = "icons_completed"
                case .Reviewed: imageName = "icons_reviewed"
            default: "icons_notstarted"
            }
        }
        if imageName != nil {
            cell.imageWorkflowState.image = UIImage(named: imageName!)
        }
        else {
            cell.imageWorkflowState.image = nil
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .Normal, title: "Mark as read") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
//            let firstActivityItem = self.items[indexPath.row]
//            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
//            self.presentViewController(activityViewController, animated: true, completion: nil)
//            
            
            Services.markRead([self.items[indexPath.section][indexPath.row].id!]) { _ in
                self.getNotifications()
            }
        }
        shareAction.backgroundColor = UIColor.blueColor()
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let firstActivityItem = self.items[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        editAction.backgroundColor = UIColor.greenColor()
        return [shareAction, editAction]
    }
    
//    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0) //make the background color light blue
//        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
//        header.alpha = 0.5 //make the header transparent
//    }
    
}
