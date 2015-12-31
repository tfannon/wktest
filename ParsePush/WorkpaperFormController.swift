//
//  WorkpaperFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit
import DTFoundation

class WorkpaperFormController: BaseFormController, WorkpaperPreviewerDelegate {
    private var workpaper : Workpaper { get { return self.primaryObject as! Workpaper } }
    
    lazy var documentInteractionController: UIDocumentInteractionController! = {
        var v = UIDocumentInteractionController()
        v.delegate = self
        return v
    }()
    
    //MARK: - Helpers
    private func t(key : String) -> String {
        return Workpaper.getTerminology(key)
    }
    
    override func setupForm() {
        formHelper.addSection(" ",
            data: [
                CellData(identifier: "TextCell", value: workpaper.title, placeHolder: self.t("title"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.workpaper.title = textCell.textField.text
                        self.enableSave()
                }),
                CellData(identifier: "TextCell", value: workpaper.code, placeHolder: self.t("code"),
                    willDisplay: formHelper.getTextCellWillDisplay(),
                    changed: { cell, _ in
                        let textCell = cell as! TextCell
                        self.workpaper.code = textCell.textField.text
                        self.enableSave()
                }),
                
                CellData(identifier: "_BasicCell", value: workpaper.manager, label: self.t("manager"),
                    style: UITableViewCellStyle.Value1,
                    imageName: "769-male",
                    willDisplay: { cell, _ in cell.selectionStyle = .None }),
                
                CellData(identifier: "_BasicCell", value: workpaper.dueDate?.ToLongDateStyle(),
                    label: self.t("dueDate"),
                    style: UITableViewCellStyle.Value1,
                    willDisplay: formHelper.dateCellWillDisplay,
                    selected: formHelper.dateCellSelected),
                CellData(identifier: "DatePickerNullableCell",
                    willDisplay: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        dateCell.value = self.workpaper.dueDate
                        dateCell.delegate = self
                    },
                    changed: { cell, data in
                        let dateCell = cell as! DatePickerNullableCell
                        self.workpaper.dueDate = dateCell.value
                        let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                        let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                        let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                        displayCell.detailTextLabel!.text = self.workpaper.dueDate?.ToLongDateStyle()
                        self.enableSave()
                }),
            ])

        formHelper.addSection("", data: [
            CellData(identifier: "_PreviewCell", label: "Preview", imageName: "binoculars",
                willDisplay: { cell, data in
                    cell.accessoryType = .None
                },
                selected: { cell, data, indexPath in
                    WorkpaperHelper.preview(self, workpaper: self.workpaper)
            })])
        
        formHelper.addSection("Workflow",
            data: [formHelper.getWorkflowCellData(self, workflowObject: workpaper)])
        
        formHelper.addSection("Review", data: [
            CellData(identifier: "_BasicCell",
                value: workpaper.reviewer,
                label: self.t("reviewer"),
                imageName: "769-male",
                style: UITableViewCellStyle.Value1,
                willDisplay: { cell, _ in cell.selectionStyle = .None }),
            
            CellData(identifier: "_BasicCell", value: workpaper.reviewDueDate?.ToLongDateStyle(), label: self.t("reviewDueDate"),
                style: UITableViewCellStyle.Value1,
                willDisplay: formHelper.dateCellWillDisplay,
                selected: formHelper.dateCellSelected),
            CellData(identifier: "DatePickerNullableCell",
                willDisplay: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    dateCell.value = self.workpaper.reviewDueDate
                    dateCell.delegate = self
                },
                changed: { cell, data in
                    let dateCell = cell as! DatePickerNullableCell
                    self.workpaper.reviewDueDate = dateCell.value
                    let dpIndexPath = self.tableView.indexPathForCell(dateCell)!
                    let displayIndexPath = NSIndexPath(forRow: dpIndexPath.row - 1, inSection: dpIndexPath.section)
                    let displayCell = self.tableView.cellForRowAtIndexPath(displayIndexPath)!
                    displayCell.detailTextLabel!.text = self.workpaper.reviewDueDate?.ToLongDateStyle()
                    self.enableSave()
            })
            ])
    }

    //MARK: - DocumentInteractionController
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerWillBeginPreview(controller: UIDocumentInteractionController) {
        
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(controller: UIDocumentInteractionController) {
    }
}


