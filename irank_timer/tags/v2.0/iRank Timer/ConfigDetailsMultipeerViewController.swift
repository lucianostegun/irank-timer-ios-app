//
//  ConfigDetailsMultipeerViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 18/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class ConfigDetailsMultipeerViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = NSLocalizedString("Multipeer connection settings", comment: "");
        
        if( appDelegate.mpcManager == nil ){
            
            appDelegate.enableMultipeerConnection();
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("foundPeer:"), name: "MPCManagerFoundPeer", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("lostPeer:"), name: "MPCManagerLostPeer", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectedWithPeer:"), name: "MPCManagerConnectedWithPeer", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("disconnectedFromPeer:"), name: "MPCManagerDisconnectedFromPeer", object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.mpcManager.foundPeers.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "MULTIPEER_DEVICE_CELL");
        
        cell.textLabel?.text = appDelegate.mpcManager.foundPeers[indexPath.row].displayName;
        cell.accessoryView   = nil;
        cell.accessoryType   = appDelegate.mpcManager.foundPeers[indexPath.row].description == appDelegate.multipeerDeviceID ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let selectedPeer = appDelegate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        appDelegate.mpcManager.browser.invitePeer(selectedPeer, toSession: appDelegate.mpcManager.session, withContext: nil, timeout: 0);
        
//        var cell = tableView.cellForRowAtIndexPath(indexPath);
//        let indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
//        cell?.accessoryView = indicatorView;
//        indicatorView.startAnimating();
//        
//        cell?.setNeedsLayout()
//        cell?.layoutSubviews()
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = NSLocalizedString("Connecting to", comment: "")+selectedPeer.displayName;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if( appDelegate.mpcManager.foundPeers.count == 0 ){
            
            return NSLocalizedString("No device found, still searching...", comment: "");
        }
        
        let pluralDevices = appDelegate.mpcManager.foundPeers.count == 1 ? NSLocalizedString("device", comment: "") : NSLocalizedString("devices", comment: "");
        
        return "\(appDelegate.mpcManager.foundPeers.count) \(pluralDevices)";
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return NSLocalizedString("ConfigDetailsMultipeerViewController.help", comment: "");
    }
    
    func foundPeer(notification : NSNotification) {
        tableView.reloadData()
    }
    
    func lostPeer(notification : NSNotification) {
        tableView.reloadData()
    }
    
    func connectedWithPeer(notification : NSNotification) {
        
        let peerID = notification.object as! MCPeerID;
        println("connectedWithPeer: \(peerID)");
        println("description: \(peerID.description)");
        
        appDelegate.multipeerDeviceName = peerID.displayName;
        appDelegate.multipeerDeviceID   = peerID.description;
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
        
        self.tableView.reloadData();
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
    }
    
    func disconnectedFromPeer(notification : NSNotification){
        
        println("disconnectedFromPeer");
        
        appDelegate.multipeerDeviceName = NSLocalizedString("No device", comment: "");
        appDelegate.multipeerDeviceID   = "";
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
        
        tableView.reloadData()
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
    }
}
