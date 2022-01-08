//
//  ConfigDetailsLongPauseViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 11/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigDetailsLongPauseViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var longPauseAlertOptionList = [1,2,3,5,10,15,20,0];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = NSLocalizedString("Long pause alert settings", comment: "");
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
        
        return longPauseAlertOptionList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "LONG_PAUSE_ALERT_CELL")
        
        var minutes : Int = longPauseAlertOptionList[indexPath.row] as Int;
        var pluralMinutes = minutes == 1 ? NSLocalizedString("minute", comment: "") : NSLocalizedString("minutes", comment: "");
            
        cell.textLabel?.text = minutes == 0 ? NSLocalizedString("Disabled", comment: "") : "\(minutes) \(pluralMinutes)";
        cell.accessoryType = appDelegate.longPauseMinutes == minutes ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        appDelegate.longPauseMinutes = longPauseAlertOptionList[indexPath.row];
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
        
        self.tableView.reloadData();
    }
}