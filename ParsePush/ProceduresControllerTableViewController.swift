//
//  ProceduresControllerTableViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/14/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class ProceduresControllerTableViewController: UITableViewController {

    var procedures:[Procedure] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // http://stackoverflow.com/questions/24150723/ios-xcode-6-tableviewcontroller-adding-margin
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        tableView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0.0, 0.0, 0.0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        procedures = Mock.getProcedures()
    }
    
    override func viewDidAppear(animated: Bool) {
        //tableView.setContentOffset(CGPointZero, animated:true)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath,
            atScrollPosition: UITableViewScrollPosition.Top,
            animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return procedures.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProcedureCell", forIndexPath: indexPath)
            
            let procedure = procedures[indexPath.row] as Procedure
            cell.textLabel?.text = procedure.title
            cell.detailTextLabel?.text = procedure.text1
            return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
