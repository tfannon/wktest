//
//  SplitMasterViewController.swift
//  TeamMate
//
//  Created by Tommy Fannon on 11/30/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class SplitMasterViewController: UITableViewController {
    
    var procedures = [Procedure]()
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        Services.getMyData {
            self.procedures = $0!.procedures
            self.tableView.reloadData()
            
            if self.selectedIndex == nil {
                if self.procedures.any {
                    self.tableView.selectRowAtIndexPath(NSIndexPath.firstElement, animated: false, scrollPosition: .None)
                    self.tableView(self.tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                }
            }
            else {
                self.tableView.selectRowAtIndexPath(self.selectedIndex, animated: false, scrollPosition: .None)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return procedures.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = procedures[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print (self.splitViewController?.viewControllers.count)
        let nav = self.splitViewController?.viewControllers.last as! UINavigationController
        //nav.navigationBar.t = procedures[indexPath.row].title
        let detail = nav.topViewController as! ProcedureFormController
        selectedIndex = indexPath
        detail.procedure = procedures[indexPath.row]
    }
    
       /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    /* In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
