//
//  DocumentPickerViewController.swift
//  TeamMateDoc
//
//  Created by Tommy Fannon on 11/8/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var workpapers : [WorkpaperShared] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func openDocument(sender: AnyObject?) {
        let documentURL = self.documentStorageURL!.URLByAppendingPathComponent("Test.docx")
        print ("opening document \(documentURL.path!)")
      
        // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
        self.dismissGrantingAccessToURL(documentURL)
    }

    override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
        print(mode.rawValue)
        // TODO: present a view controller appropriate for picker mode here
    }

    //MARK: - TableViewController methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workpapers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("workpaper")
        let workpaper = workpapers[indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "workpaper")
        }
        
        cell!.imageView?.image = UIImage(named: workpaper.documentType?.imageName ?? "icon_document")
        cell!.textLabel?.text = workpaper.title
        cell!.detailTextLabel?.text = "Parent: \(workpaper.parentTitle)"

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workpaper = workpapers[indexPath.row]
        let filename = "\(workpaper.attachmentTitle).\(workpaper.attachmentExtension)"
        let documentURL = self.documentStorageURL!.URLByAppendingPathComponent(filename)
        // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
        self.dismissGrantingAccessToURL(documentURL)
    }
    
}
