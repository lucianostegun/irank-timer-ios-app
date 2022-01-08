//
//  ConfigMasterViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 11/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigMasterViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var firstAppear = true;
    
    @IBOutlet var swcPlaySounds : UISwitch!;
    @IBOutlet var swcFiveSecondsClock : UISwitch!;
    @IBOutlet var swcPreventSleep : UISwitch!;
    @IBOutlet weak var swcEnableMultipeer: UISwitch!
    @IBOutlet weak var swcBackgroundRun: UISwitch!
    @IBOutlet weak var swcShortBlindNumber: UISwitch!
    @IBOutlet weak var swcInverseTextColor: UISwitch!
    @IBOutlet weak var swcHideStatusBar: UISwitch!
    @IBOutlet weak var lblSoundsName: UILabel!
    @IBOutlet weak var lblLongPauseMinutes: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblEnableBackup: UILabel!
    @IBOutlet weak var lblBackgroundMode: UILabel!
    @IBOutlet weak var lblMultipeerDevice: UILabel!
    
    var configDetailsMultipeerViewController : UITableViewController!;
    
    override func viewDidLoad() {

        updateLabels();

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateLabels"), name: "changeSubOptionValue", object: nil);
        
        swcPlaySounds.on       = appDelegate.playSounds;
        swcFiveSecondsClock.on = appDelegate.fiveSecondsClock;
        swcPreventSleep.on     = appDelegate.preventSleep;
        swcShortBlindNumber.on = appDelegate.shortBlindNumber;
        swcInverseTextColor.on = appDelegate.inverseTextColor;
        swcHideStatusBar.on    = appDelegate.hideStatusBar;
        swcEnableMultipeer.on  = appDelegate.enableMultipeer;
        lblEnableBackup.text   = appDelegate.enableBackup ? NSLocalizedString("Enabled", comment: "") : NSLocalizedString("Disabled", comment: "");
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }
        
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated);
        
        if( firstAppear && Constants.DeviceIdiom.IS_IPAD ){
            
            firstAppear = false;
        }
    }
    
//    func autoSelectMasterRow(){
//        
//        var indexPath : NSIndexPath!;
//        
//        if( swcPlaySounds.on ){
//            
//            indexPath = NSIndexPath(forRow: 1, inSection: 0);
//        }else{
//            
//            indexPath = NSIndexPath(forRow: 2, inSection: 1);
//        }
//        
//        self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath);
//        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None);
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch( section ){
        case 0:
            return 4;
        case 1:
            return (Constants.DeviceIdiom.IS_IPHONE && Constants.LITE_VERSION ? 4 : 5);
        case 2:
            return (appDelegate.enableMultipeer && Constants.DeviceIdiom.IS_IPAD ? 5 : 4);
        default:
            return 0;
        }
    }
    
    @IBAction func togglePlaySounds(sender: AnyObject) {
        
        appDelegate.playSounds = swcPlaySounds.on;
        self.tableView.reloadData();
    }
    
    @IBAction func toggleFiveSecondsClock(sender: AnyObject) {
        
        appDelegate.fiveSecondsClock = swcFiveSecondsClock.on;
    }
    
    @IBAction func togglePreventSleep(sender: AnyObject) {

        appDelegate.preventSleep = swcPreventSleep.on;
    }
    
    @IBAction func toggleBackgroundRun(sender: AnyObject) {
        
        appDelegate.backgroundRun = swcBackgroundRun.on;
    }
    
    @IBAction func toggleShortBlindNumber(sender: AnyObject) {
        
        appDelegate.shortBlindNumber = swcShortBlindNumber.on;
    }
    
    @IBAction func toggleEnableMultipeer(sender: AnyObject) {
        
        if( !appDelegate.checkLiteVersion() ){
        
            appDelegate.enableMultipeer = false;
            swcEnableMultipeer.on       = false;
        }
        
        appDelegate.enableMultipeer = swcEnableMultipeer.on;
        self.tableView.reloadData();
        
        if( swcEnableMultipeer.on ){
            
            if( appDelegate.mpcManager == nil ){
                
                appDelegate.enableMultipeerConnection()
            }
            
            appDelegate.timerViewController.checkMultipeerMode();
        }else{
            
            appDelegate.mpcManager = nil;
        }
    }
    
    @IBAction func toggleInverseTextColor(sender: AnyObject) {
        
        appDelegate.inverseTextColor = swcInverseTextColor.on;
    }
    
    @IBAction func toggleHideStatusBar(sender: AnyObject) {
        
        appDelegate.hideStatusBar = swcHideStatusBar.on;
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        
        appDelegate.saveUserDefaults();
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch( indexPath.section ){
        case 0:
            switch( indexPath.row ){
            case 1 ... 3:
                return swcPlaySounds.on ? 44: 0;
            default:
                break;
            }
            break;
        case 1:
            break;
        case 2:
            switch( indexPath.row ){
            case 4:
                return swcEnableMultipeer.on ? 44: 0;
            default:
                break;
            }
            break;
        default:
            break;
        }
        
        return 44;
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch( indexPath.section ){
        case 0:
            switch( indexPath.row ){
            case 1 ... 3:
                return cell.hidden = !swcPlaySounds.on;
            default:
                break;
            }
            break;
        case 2:
            switch( indexPath.row ){
            case 4:
                return cell.hidden = !swcEnableMultipeer.on;
            default:
                break;
            }
            break;
        default:
            break;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if( Constants.DeviceIdiom.IS_IPHONE ){
            
            return;
        }
        
        let storyboard = UIStoryboard(name: "iPad_Config", bundle: nil);
        
        switch( indexPath.section ){
        case 0:
            switch( indexPath.row ){
            case 1:
                let vc         = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsSoundViewController") as! UITableViewController;
                self.changeDetailViewController(vc);
            case 3:
                let vc         = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsLongPauseViewController") as! UITableViewController;
                self.changeDetailViewController(vc);
            default:
                break;
            }
            break;
        case 1:
            switch( indexPath.row ){
            case 0:
                let vc         = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsLanguageViewController") as! UITableViewController;
                self.changeDetailViewController(vc);
            case 2:
                let vc         = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsBackgroundViewController") as! UITableViewController;
                self.changeDetailViewController(vc);
            default:
                break;
            }
            break;
        case 2:
            switch( indexPath.row ){
            case 0:
                let vc         = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsBackupViewController") as! UITableViewController;
                self.changeDetailViewController(vc);
            case 4:
                if( configDetailsMultipeerViewController == nil ){
                    
                    configDetailsMultipeerViewController = storyboard.instantiateViewControllerWithIdentifier("ConfigDetailsMultipeerViewController") as! UITableViewController;
                }
                
                self.changeDetailViewController(configDetailsMultipeerViewController);
            default:
                break;
            }
            break;
        default:
            break;
        }
        
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None);
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if( section == 2 ){
            
            return "www.irank.com.br\n\n© stegun.com";
        }
        
        return "";
    }
    
    func changeDetailViewController(viewController : UIViewController){
     
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            var splitViewController = self.parentViewController?.parentViewController as! UISplitViewController;
            
            (splitViewController.viewControllers.last as! UINavigationController).setViewControllers([viewController], animated: false);
        }
    }
    
    func updateLabels(){
        
        var pluralMinutes = appDelegate.longPauseMinutes == 1 ? NSLocalizedString("minute", comment: "") : NSLocalizedString("minutes", comment: "");
            
        lblSoundsName.text = "\(appDelegate.blindChangeSoundName)/\(appDelegate.lastMinuteSoundName)";
        lblLongPauseMinutes.text = appDelegate.longPauseMinutes == 0 ? NSLocalizedString("Disabled", comment: "") : "\(appDelegate.longPauseMinutes) \(pluralMinutes)";
        lblBackgroundMode.text = appDelegate.backgroundMode == "static" ? NSLocalizedString("Static", comment: "") : NSLocalizedString("Dynamic", comment: "");

        var languageList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("languages", ofType: "plist")!);
        for language : NSDictionary in languageList as! Array<NSDictionary> {
            
            if( (language["culture"] as! String) == appDelegate.language ){
                
                lblLanguage.text = (language["language"] as! String);
                break;
            }
        }
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            println("appDelegate.multipeerDeviceName: \(appDelegate.multipeerDeviceName)");
            lblMultipeerDevice.text = appDelegate.multipeerDeviceName;
        }
        
        tableView.reloadData();
    }
}