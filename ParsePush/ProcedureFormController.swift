//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import DTFoundation

class ProcedureFormController: BaseFormController {
    
    var procedure : Procedure { return self.primaryObject as! Procedure }
    
    // MARK: - Static
    class func create() -> ProcedureFormController {
        return BaseFormController.create(ObjectType.Procedure) as! ProcedureFormController
    }
    
    //MARK: - Helpers
    private func t(key : String) -> String {
        return Procedure.getTerminology(key)
    }
    
    override func setupForm() {
        formHelper.addSection(" ",
            data: [
                CellData(identifier: "TextCell", value: procedure.title, placeHolder: self.t("title"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.procedure.title = textCell.textField.text
                        self.enableSave()
                }),
                CellData(identifier: "TextCell", value: procedure.code, placeHolder: self.t("code"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.procedure.code = textCell.textField.text
                        self.enableSave()
                }),
                
                CellData(identifier: "_BasicCell", value: procedure.tester, label: self.t("tester"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                
                CellData(identifier: "_BasicCell", value: procedure.dueDate?.ToLongDateStyle(),
                    label: self.t("dueDate"),
                    style: UITableViewCellStyle.Value1,
                    willDisplay: formHelper.dateCellWillDisplay,
                    selected: formHelper.dateCellSelected),
                CellData(identifier: "DatePickerNullableCell",
                    willDisplay: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        dateCell.value = self.procedure.dueDate
                        dateCell.delegate = self
                    },
                    changed: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        self.procedure.dueDate = dateCell.value
                        let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                        let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                        let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                        displayCell.detailTextLabel!.text = self.procedure.dueDate?.ToLongDateStyle()
                        self.enableSave()
                }),
            ])
        
        formHelper.addSection("Workflow",
            data: [formHelper.getWorkflowCellData(self, workflowObject: procedure)])
        
        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: procedure.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                willDisplay: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: procedure.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                willDisplay: formHelper.dateCellWillDisplay,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerNullableCell",
                willDisplay: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    dateCell.value = self.procedure.reviewDueDate
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    self.procedure.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.procedure.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
            })
            ])
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields1",
                style: UITableViewCellStyle.Value1,
                label: "Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("text1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.text2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text3 = textCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("text4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.text4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let textCell = cell as! HtmlCell
                self.procedure.text4 = textCell.textString
                self.enableSave()
        })])
        
        formHelper.addSection("Results", data: [CellData(identifier: "SegmentedCell",
            willDisplay: { cell, data in
                let segmentedCell = cell as! SegmentedCell
                segmentedCell.delegate = self
                segmentedCell.setOptions(TestResults.displayNames)
                //segmentedCell.label.text = self.t("testResults")
                segmentedCell.segmented.selectedSegmentIndex = self.procedure.testResults
            },
            changed: { cell, _ in
                let segmentedCell = cell as! SegmentedCell
                self.procedure.testResults = segmentedCell.segmented.selectedSegmentIndex
                self.enableSave()
        })])
        
        formHelper.addSection(" ", data:
            [CellData(identifier: "_HideTextFields2",
                style: UITableViewCellStyle.Value1,
                label: "Result Text Fields",
                imageName:  "pen",
                toggled: false,
                sectionsToHide: [1, 2, 3, 4],
                selectedIfAccessoryButtonTapped: true,
                willDisplay: formHelper.hideSectionWillDisplay,
                selected: formHelper.hideSectionSelected)
            ])
        
        formHelper.addSection(self.t("resultsText1"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText1,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText1 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText2"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText2,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText2 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText3"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText3,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText3 = htmlCell.textString
                self.enableSave()
        })])
        formHelper.addSection(self.t("resultsText4"), data: [CellData(identifier: "HtmlCell",
            value: procedure.resultsText4,
            willDisplay: formHelper.htmlCellWillDisplay,
            changed: { cell, _ in
                let htmlCell = cell as! HtmlCell
                self.procedure.resultsText4 = htmlCell.textString
                self.enableSave()
        })])

        ///////////////////
        // workpapers
        ///////////////////
        formHelper.addChildCells(self.primaryObject, objectType: .Workpaper)

        ///////////////////
        // issues
        ///////////////////
        formHelper.addChildCells(self.primaryObject, objectType: .Issue)

        ///////////////////
        // Change Tracking
        ///////////////////
        formHelper.addChangeTracking(self.procedure.changes)
        
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

