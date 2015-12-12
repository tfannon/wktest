//
//  IssueFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import DTFoundation

class IssueFormController: BaseFormController {
    
    private var issue : Issue { get { return self.primaryObject as! Issue } }

    // MARK: - Static
    class func create() -> IssueFormController {
        return BaseFormController.create(ObjectType.Issue) as! IssueFormController
    }
    
    //MARK: - Helpers
    private func t(key : String) -> String {
        return Issue.getTerminology(key)
    }
    
    override func setupForm() {
        formHelper.addSection(" ",
            data: [
                CellData(identifier: "TextCell", value: issue.title, placeHolder: self.t("title"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.issue.title = textCell.textField.text
                        self.enableSave()
                }),
                CellData(identifier: "TextCell", value: issue.code, placeHolder: self.t("code"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.issue.code = textCell.textField.text
                        self.enableSave()
                }),
                
                CellData(identifier: "_BasicCell", value: issue.manager, label: self.t("manager"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                CellData(identifier: "_BasicCell", value: issue.businessContact,
                    label: self.t("businessContact"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                
                CellData(identifier: "_BasicCell", value: issue.dueDate?.ToLongDateStyle(),
                    label: self.t("dueDate"),
                    style: UITableViewCellStyle.Value1,
                    willDisplay: formHelper.dateCellWillDisplay,
                    selected: formHelper.dateCellSelected),
                CellData(identifier: "DatePickerNullableCell",
                    willDisplay: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        dateCell.value = self.issue.dueDate
                        dateCell.delegate = self
                    },
                    changed: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        self.issue.dueDate = dateCell.value
                        let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                        let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                        let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                        displayCell.detailTextLabel!.text = self.issue.dueDate?.ToLongDateStyle()
                        self.enableSave()
                }),
            ])
        
        formHelper.addSection("Workflow",
            data: [formHelper.getWorkflowCellData(self, workflowObject: issue)])
        
        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: issue.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                willDisplay: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: issue.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                willDisplay: formHelper.dateCellWillDisplay,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerNullableCell",
                willDisplay: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    dateCell.value = self.issue.reviewDueDate
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    self.issue.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.issue.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
            })
            ])
        
        formHelper.addSection("Properties", data: [
            CellData(identifier: "TextCellWithLabel", value: self.issue.numericValue1,                 willDisplay: formHelper.getTextCellWillDisplay(
                UIKeyboardType.DecimalPad,
                label: self.t("numericValue1")),
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    if let v = textCell.textField?.text {
                        self.issue.numericValue1 = v.toDouble()
                    }
                    else {
                        self.issue.numericValue1 = 0
                    }
                    self.enableSave()
            }),
            CellData(identifier: "TextCellWithLabel",
                value: self.issue.numericValue2,
                willDisplay: formHelper.getTextCellWillDisplay(
                    UIKeyboardType.DecimalPad,
                    label: self.t("numericValue2")),
                changed: { cell, _ in
                    let textCell = cell as! TextCell
                    if let v = textCell.textField?.text {
                        self.issue.numericValue2 = v.toDouble()
                    }
                    else {
                        self.issue.numericValue2 = 0
                    }
                    self.enableSave()
            }),
            CellData(identifier: "SwitchCell",
                willDisplay: { cell, data in
                    let sc = cell as! SwitchCell
                    sc.value = self.issue.yesNo1 ?? false
                    sc.label.text = self.t("yesNo1")
                    sc.delegate = self
                },
                changed: { cell, data in
                    self.issue.yesNo1 = (cell as! SwitchCell).value
                    self.enableSave()
            }),
            CellData(identifier: "SwitchCell",
                willDisplay: { cell, data in
                    let sc = cell as! SwitchCell
                    sc.value = self.issue.yesNo2 ?? false
                    sc.label.text = self.t("yesNo2")
                    sc.delegate = self
                },
                changed: { cell, data in
                    self.issue.yesNo2 = (cell as! SwitchCell).value
                    self.enableSave()
            }),
            ])
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields1",
                style: UITableViewCellStyle.Value1,
                label: "Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4, 5],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("text1"), data: [CellData(identifier: "HtmlCell",
            value: issue.text1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.issue.text1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text2"), data: [CellData(identifier: "HtmlCell",
            value: issue.text2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.issue.text2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text3"), data: [CellData(identifier: "HtmlCell",
            value: issue.text3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text3 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text4"), data: [CellData(identifier: "HtmlCell",
            value: issue.text4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text4 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text5"), data: [CellData(identifier: "HtmlCell",
            value: issue.text5,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.issue.text5 = textCell.textString
                self.enableSave()
        })])
        
        ///////////////////
        // workpapers
        ///////////////////
        formHelper.addWorkpaperCells(self.issue.workpapers)
        
        ///////////////////
        // Change Tracking
        ///////////////////
        formHelper.addChangeTracking(self.issue.changes)
        
        ///////////////////
        // now that our data is wired up - reload
        ///////////////////
        tableView.reloadData()
        
        ///////////////////
        // hide html
        ///////////////////
        formHelper.hideHtmlSections()
    }
}


