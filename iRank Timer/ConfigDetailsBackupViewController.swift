//
//  ConfigDetailsBackupViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 25/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigDetailsBackupViewController : UITableViewController, UIAlertViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var backupFileList : Array<NSMetadataItem>! = [];
    var query : NSMetadataQuery!;
    
    var swcEnableBackup : UISwitch = UISwitch();
    
    @IBOutlet weak var btnEditBackups: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.title = NSLocalizedString("iCloud backup settings", comment: "");
        
        swcEnableBackup.on = appDelegate.enableBackup;
        swcEnableBackup.addTarget(self, action: Selector("toggleEnableBackup:"), forControlEvents: UIControlEvents.ValueChanged);
        
        if( swcEnableBackup.on ){
            
            searchForBackupFiles();
        }
        
        btnEditBackups.enabled = swcEnableBackup.on;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return appDelegate.enableBackup ? 2 : 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch( section ){
        case 0:
            return 1;
        case 1:
            return backupFileList.count;
        default:
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "BACKUP_SETTINGS_CELL")
        
        switch( indexPath.section ){
        case 0:
            cell.textLabel?.text = NSLocalizedString("Enable iCloud backup", comment: "");
            cell.accessoryView   = swcEnableBackup;
            cell.selectionStyle  = UITableViewCellSelectionStyle.None;
            break;
        case 1:
            
            var documentURL : NSURL = backupFileList[indexPath.row].valueForAttribute(NSMetadataItemURLKey) as! NSURL;
            var fileName : String   = backupFileList[indexPath.row].valueForAttribute(NSMetadataItemDisplayNameKey) as! String;
//            println("fileName: \(fileName)")
            
            fileName = fileName.replace(".data", template: "");
//            println("fileName: \(fileName)")
            
            let decodedData = NSData(base64EncodedString: fileName, options: NSDataBase64DecodingOptions.allZeros);
            
            fileName = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)! as! String;
//            println("fileName: \(fileName)")
            
            cell.textLabel?.text = "\(fileName)";
            break;
        default:
            break;
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch( section ){
        case 0:
            if( swcEnableBackup.on && !BlindSet.checkiCloudBackupAvailability() ){
                
                return NSLocalizedString("It seems your iCloud backup is not enabled for this device.\nGo to Settings > iCloud > Storage to enable backups.", comment: "")
            }
            return "";
        case 1:
            
            var pluralFiles = backupFileList.count == 1 ? NSLocalizedString("file found", comment: "") : NSLocalizedString("files found", comment: "")
            return backupFileList.count == 0 ? NSLocalizedString("You have no backup files on your iCloud account", comment: "") : "\(backupFileList.count) \(pluralFiles) ";
        default:
            return "";
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if( indexPath.section == 0 ){
            
            return;
        }
                var title     = NSLocalizedString("Confirm replace blind sets", comment: "");
                var message   = NSLocalizedString("Are you sure you want to replaces all blind sets for those in this backup?", comment: "");
                var yesButton = NSLocalizedString("YES", comment: "");
                var noButton  = NSLocalizedString("NO", comment: "");
                
        var alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: noButton, otherButtonTitles: yesButton);
        
        alert.tag = indexPath.row;
        alert.show();
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if( buttonIndex == 0 ){
            
            return;
        }
        
        var documentURL : NSURL = backupFileList[alertView.tag].valueForAttribute(NSMetadataItemURLKey) as! NSURL;
        var fileName : String   = backupFileList[alertView.tag].valueForAttribute(NSMetadataItemDisplayNameKey) as! String;
        
        var blindSetList : Array<BlindSet>! = BlindSet.loadArchivedBlindSetList(documentURL, archive: true);
        
        if( blindSetList == nil ){
            
            var title    = NSLocalizedString("ERROR", comment: "");
            var message  = NSLocalizedString("An error occurred while loading backup file! Please, try again.", comment: "");
            var okButton = NSLocalizedString("OK", comment: "");
                
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: okButton).show();
        }else{
            
            appDelegate.blindSetList = blindSetList;
            appDelegate.currentBlindSetIndex = 0;
            appDelegate.needBackup = false;

            appDelegate.timerViewController.blindSetList = blindSetList;
            appDelegate.timerViewController.currentBlindSetIndex = 0;
            appDelegate.timerViewController.resetTimer(true, force: true);
            
            var title    = NSLocalizedString("SUCCESS", comment: "");
            var message  = NSLocalizedString("Backup file was successfuly load for this device!", comment: "");
            var okButton = NSLocalizedString("OK", comment: "");
            
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: okButton).show();
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return self.tableView.editing && indexPath.section == 1;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if( editingStyle == UITableViewCellEditingStyle.Delete ){
            
            var documentURL : NSURL = backupFileList[indexPath.row].valueForAttribute(NSMetadataItemURLKey) as! NSURL;
            
//            println("documentURL: \(documentURL)")
            
            var fileExists = NSFileManager.defaultManager().fileExistsAtPath(documentURL.path!);
            
            if( fileExists ){

                NSFileManager.defaultManager().removeItemAtURL(documentURL, error: nil);
            }
            
            backupFileList.removeAtIndex(indexPath.row);
        }
        
        self.tableView.reloadData();
    }
    
    func searchForBackupFiles() {
        
        var baseURL : NSURL!
        baseURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil);
        
        if( baseURL != nil ){
            
            self.query = NSMetadataQuery();
            self.query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope];
            
            var predicate : NSPredicate = NSPredicate(format: "%K LIKE '*'", NSMetadataItemFSNameKey);
            
            self.query.predicate = predicate;
            
            var nc : NSNotificationCenter = NSNotificationCenter.defaultCenter();
            nc.addObserver(self, selector: Selector("queryDidFinish:"), name: NSMetadataQueryDidFinishGatheringNotification, object: self.query);
            
            self.query.startQuery();
        }
    }
    
    func queryDidFinish(notification: NSNotification){
        
        var query : NSMetadataQuery = notification.object as! NSMetadataQuery;
        query.disableUpdates();
        query.stopQuery();
        
        backupFileList = self.query.results as! Array<NSMetadataItem>;
//        println("backupFileList.count: \(backupFileList.count)");
        
        var index : Int = 0;
        
        for item : NSMetadataItem in backupFileList {
            
            var documentURL : NSURL = item.valueForAttribute(NSMetadataItemURLKey) as! NSURL;
            var fileName : String! = item.valueForAttribute(NSMetadataItemDisplayNameKey) as! String;
            var filesize : Int = item.valueForAttribute(NSMetadataItemFSSizeKey) as! Int;
            var updated : NSDate = item.valueForAttribute(NSMetadataItemFSContentChangeDateKey) as! NSDate;
            
            fileName = fileName.replace(".data", template: "");
            let decodedData : NSData! = NSData(base64EncodedString: fileName, options: NSDataBase64DecodingOptions.allZeros);
            
            if( decodedData == nil ){
                
                backupFileList.removeAtIndex(index);
                NSFileManager.defaultManager().removeItemAtURL(documentURL, error: nil);
//                println("backupFileList.count: \(backupFileList.count)");
            }else{
                
//                println("fileName: \(fileName), filesize: \(filesize), updated: \(updated), \(documentURL)");
                
                index++;
            }
        }
        
//        println("backupFileList.count: \(backupFileList.count)");
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
        
        self.tableView.reloadData();
    }
    
    @IBAction func toggleEnableBackup(sender: AnyObject) {
        
        if( !appDelegate.checkLiteVersion() ){
            
            appDelegate.enableBackup = false;
            swcEnableBackup.on       = false;
            appDelegate.needBackup   = false;
            return;
        }
        
        if( !appDelegate.enableBackup && swcEnableBackup.on && !appDelegate.needBackup ){
            
            appDelegate.needBackup = true;
            BlindSet.saveiCloudBackup();
        }
        
        appDelegate.enableBackup = swcEnableBackup.on;
        btnEditBackups.enabled   = swcEnableBackup.on;
        
        searchForBackupFiles();
    }
    
    @IBAction func toggleEditBackups(sender: AnyObject) {
        
        if( tableView.editing ){
            
            btnEditBackups.style = UIBarButtonItemStyle.Plain;
            btnEditBackups.title = NSLocalizedString("Edit", comment: "");
        }else{
            
            btnEditBackups.style = UIBarButtonItemStyle.Done;
            btnEditBackups.title = NSLocalizedString("Done", comment: "");
        }
        
        tableView.editing = !tableView.editing;
    }
}