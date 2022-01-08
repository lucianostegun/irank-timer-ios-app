//
//  ConfigDetailsLanguageViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 24/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigDetailsLanguageViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var languageList : NSArray!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.title = NSLocalizedString("Language settings", comment: "");
        
        languageList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("languages", ofType: "plist")!);
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
        
        return languageList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "SOUND_SETTING_CELL")
        
        var culture : String = (languageList[indexPath.row]["culture"] as! String)
        
        cell.textLabel?.text = (languageList[indexPath.row]["language"] as! String);
        cell.accessoryType   = appDelegate.language == culture ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
        
        return cell;
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return NSLocalizedString("You may need to restart application in order to load a new language", comment: "");
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        appDelegate.language = (languageList[indexPath.row]["culture"] as! String);
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
        
        self.tableView.reloadData();
    }
}