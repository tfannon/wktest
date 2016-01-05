//
//  SyncController.swift
//  TeamMate
//
//  Created by Adam Rothberg on 1/3/16.
//  Copyright © 2016 Crazy8Dev. All rights reserved.
//

import Foundation
import UIKit
import CircleProgressBar
import SwiftR

class SyncController : UIViewController, ProgressDelegate {

    @IBOutlet var circleProgressBar: CircleProgressBar!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var hub: Hub!
    private var hubConnection: SignalR!

    //MARK: - view controller
    override func viewDidLoad() {
        //SwiftR (signalR support)
        //i'd like to move this to services and establish it at the start
        hubConnection = SwiftR.connect("http://\(Services.ipAddress)/Offline") { [weak self] connection in
            connection.headers = ["userName":"joe.tester"]
            self!.hub = connection.createHubProxy("progressHub")
            self!.hub.on("sendProgress", parameters: ["message", "current", "total"]) { args in
                let message = args!["message"] as! String
                let current = args!["current"] as! Int
                let total = args!["total"] as! Int
                dispatch_async(dispatch_get_main_queue()) {
                    self!.setProgress(message, current: Float(current), total: Float(total))
                }
            }
            connection.connected = {
                print("SignalR Connected with ID: \(connection.connectionID!)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setState(0)
    }
    
    override func viewDidLayoutSubviews() {
        circleProgressBar.setNeedsDisplay()
        super.viewDidLayoutSubviews()
    }
    
    func setState(flag : Int) {
        let syncing = (flag != 0)
        circleProgressBar.setProgress(0, animated: true)
        progressLabel.text = ""

        syncButton.hidden = syncing
        circleProgressBar.hidden = !syncing
        progressLabel.hidden = !syncing
    }
    
    @IBAction func syncButtonClicked(sender: AnyObject) {
        setState(1)
        showMessage("Sync started...")
        Services.sync2(self) { result in
            self.finalizeProgress(result!.description)
        }
    }
     
    //MARK: - ProgressDelegate
    func setProgress(message: String? = nil, current: Float, total: Float) {
        dispatch_async(dispatch_get_main_queue()) {
            let progress = ProgressCalculator.get1(current, total: total)
            print(progress)
            self.circleProgressBar.setProgress(CGFloat(progress), animated: true)
            self.showMessage(message)
        }
    }
    
    func initializeProgress() {
        dispatch_async(dispatch_get_main_queue()) {
            self.circleProgressBar.setProgress(0, animated: false)
        }
    }
    
    func finalizeProgress(message: String? = nil) {
        showMessage(message)
    }
    
    func showMessage(message : String?) {
        if message != nil {
            print ("\t\(message!)")
            progressLabel.text = message
        }
    }
}