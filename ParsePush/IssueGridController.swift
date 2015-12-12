//
//  IssueController.swift
//  ParsePush
//
//  Created by Tommy Fannon on 11/23/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit

class IssueGridController: BaseGridController {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        getIssues {
            self.dataSourceHelper.data = self.items
        }
    }
    
    func getIssues(completed: ()->()) {
        self.items = []
        self.sortedItems = []
        Services.getMyData { result in
            if result?.issues.count > 0 {
                result?.issues.each {
                    self.items.append($0)
                }
                self.sortedItems = self.items
                completed()
            }
        }
    }
    
    //can probably push this up
    override func addColumns() {
        if gridColumnsOrder == nil {
            gridColumnsOrder = ["sync","title","parentType","parentTitle","workflowState","workflowStateTitle","released", "createdDate", "createdUser", "manager","businessContact","reviewer"]
        }
        for (var i=0;i<gridColumnsOrder.count;i++) {
            let key = gridColumnsOrder[i]
            let title = Issue.getTerminology(key)
            switch key {
                
            case "sync": addColumnWithTitle(key, title: "Sync", width: 75, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5))
                
            case "title": addColumnWithTitle(key, title: title, width: 220, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "parentType": addColumnWithTitle(key, title: "", width: 50, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "parentTitle": addColumnWithTitle(key, title: title, width: 175, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "workflowState": addColumnWithTitle(key, title: "", width: 63, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), cellClass:DataGridImageCell.self)
                
            case "workflowStateTitle": addColumnWithTitle(key, title: "Workflow State", width: 150, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
                
            case "released": addColumnWithTitle(key, title: "State", width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            case "createdDate": addColumnWithTitle(key, title: title, width: 100, textAlignment: NSTextAlignment.Left, edgeInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
                
            default: addColumnWithTitle(key, title: title, width: 125, textAlignment: .Left, edgeInsets: UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10))
            }
        }
    }
    
    //can probably push this up when form support comes in for all
    func shinobiDataGrid(grid: ShinobiDataGrid!, didSelectRow row: SDataGridRow!) {
        let issue = items[row.rowIndex] as! Issue
        let controller = IssueFormController.create()
        controller.primaryObject = issue
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func dataGridDataSourceHelper(helper: SDataGridDataSourceHelper!, populateCell cell: SDataGridCell!, withValue value: AnyObject!, forProperty propertyKey: String!, sourceObject object: AnyObject!) -> Bool {
        let issue = object as! Issue
        
        switch (propertyKey) {
        case "sync" :
            let wCell = cell as! SDataGridTextCell
            wCell.textField.text = issue.syncState.displayName
            switch issue.syncState {
            case .New :
                wCell.backgroundColor = UIColor.lightGrayColor()
            case .Modified :
                wCell.backgroundColor = UIColor.lightGrayColor()
            case .Dirty:""
            case .Unchanged:
                wCell.textField.text = ""
            }
            return true
            
        case "workflowState" :
            let wCell = cell as! DataGridImageCell
            wCell.state = WorkflowState(rawValue: issue.workflowState)!
            return true
            
        case "released" :
            let wCell = cell as! SDataGridTextCell
            if issue.released {
                wCell.text = "Released"
            }
            return true
            
        case "parentType" :
            let wCell = cell as! DataGridImageCell
            wCell.parentType = ObjectType(rawValue: issue.parentType)!
            return true
            
        case "createdDate" :
            let wCell = cell as! SDataGridTextCell
            wCell.text =  issue.createdDate?.toShortString()
            return true
            
        default: return false
        }
    }
}