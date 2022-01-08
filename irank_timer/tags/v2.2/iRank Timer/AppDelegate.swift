//
//  AppDelegate.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 04/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MPCManagerDelegate, iRateDelegate, UIAlertViewDelegate {

    let device = UIDevice.currentDevice();
    
    let kCurrentBlindSetIndex          = "currentBlindSetIndex"
    let kSavedSettings                 = "savedSettings";
    let kSettingsBlindChangeSound      = "settings.blindChangeSound"
    let kSettingsBlindChangeSoundName  = "settings.blindChangeSoundName"
    let kSettingsLastMinuteSound       = "settings.lastMinuteSound"
    let kSettingsLastMinuteSoundName   = "settings.lastMinuteSoundName"
    let kSettingsFirstAnteSound        = "settings.firstAnteSound"
    let kSettingsPlaySounds            = "settings.playSounds"
    let kSettingsBackgroundRun         = "settings.backgroundRun"
    let kSettingsBackgroundMode        = "settings.backgroundMode"
    let kSettingsBackgroundImageName   = "settings.backgroundImageName"
    let kSettingsBackgroundCustomImage = "settings.backgroundCustomImage"
    let kSettingsPreventSleep          = "settings.preventSleep"
    let kSettingsFiveSecondsClock      = "settings.fiveSecondsClock"
    let kSettingsShortBlindNumber      = "settings.shortBlindNumber"
    let kSettingsNotifyFirstAnte       = "settings.notifyFirstAnte"
    let kSettingsLongPauseAlert        = "settings.longPauseAlert"
    let kSettingsLongPauseMinutes      = "settings.longPauseMinutes"
    let kSettingsLanguage              = "settings.language"
    let kSettingsConvertedBlindSet     = "settings.convertedBlindSet"
    let kSettingsLastAppVersion        = "settings.lastAppVersion"
    let kSettingsEnableMultipeer       = "settings.enableMultipeer"
    let kSettingsEnableBackup          = "settings.enableBackup"
    let kNotificationBlindLevelChange  = "notification.blindLevelChange";
    let kSettingsInverseTextColor      = "settings.inverseTextColor"
    let kSettingsHideStatusBar         = "settings.hideStatusBar"
    
    var window: UIWindow?
    var timerViewController : TimerViewController!;
    var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults();
    var blindSetList : Array<BlindSet>! = [];
    var currentBlindSetIndex : Int = 0;
    var bgTask : UIBackgroundTaskIdentifier!;
    var localNotification : UILocalNotification!;
    var mpcManager: MPCManager!
    
    var firstExecution : Bool = false;
    var blindChangeSound : String = "blind-change-9";
    var lastMinuteSoundName : String = "Airport";
    var lastMinuteSound : String = "minute-alert-1";
    var blindChangeSoundName : String = "Morse";
    var firstAnteSound : String = "first-ante-4";
    var playSounds : Bool = true;
    var backgroundRun : Bool = true;
    var backgroundMode : String = "dynamic";
    var backgroundImageName : String = "background-1.jpg";
    var backgroundCustomImage : UIImage = UIImage(named: "background-1.3.jpg")!;
    var preventSleep : Bool = true;
    var shortBlindNumber : Bool = true;
    var notifyFirstAnte : Bool = true;
    var fiveSecondsClock : Bool = true;
    var longPauseAlert : Bool = true;
    var longPauseMinutes : Int = 2;
    var convertedBlindSet : Bool = false;
    var lastAppVersion : Double!;
    var enableMultipeer : Bool = false;
    var enableBackup : Bool = false;
    var inverseTextColor : Bool = false;
    var hideStatusBar : Bool = true;
    var multipeerDeviceName : String = NSLocalizedString("No device", comment: "");
    var multipeerDeviceID : String = "";
    var lastMultipeerDeviceID : String = "";
    var language : String = "english";
    var needBackup : Bool = false;
    var isAdvertising : Bool = true; // Utilizado apenas por iPhones

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var savedSettings = userDefaults.boolForKey(kSavedSettings);
        
        if( !savedSettings ){
            
            firstExecution = true;
            createUserDefaults();
        }
        
        loadSettings();
        
        if( !convertedBlindSet ){
            
            BlindSet.convertArchivedBlindSetList();
            convertedBlindSet = true;
        }
        
        if( Constants.LITE_VERSION ){
            
            enableBackup = false;
            
            if( Constants.DeviceIdiom.IS_IPHONE ){
                
                hideStatusBar = true;
            }
        }
        
        blindSetList = BlindSet.loadArchivedBlindSetList(true);
        
        // Instanciar isso apenas quando a conexão estiver habilitada
        if( enableMultipeer ){
            
            enableMultipeerConnection();
        }
        
        if( Constants.DeviceIdiom.IS_IPHONE ){

            self.timerViewController = (self.window?.rootViewController as! UINavigationController).viewControllers.first as! iPhone_TimerViewController;
        }else{
    
            timerViewController = (window?.rootViewController as! iPad_TimerViewController);
        }
    
        timerViewController.blindSetList         = blindSetList;
        timerViewController.currentBlindSetIndex = currentBlindSetIndex;
        
        iRate.sharedInstance().applicationBundleID = "com.stegun.iRank-Timer"
        iRate.sharedInstance().onlyPromptIfLatestVersion = false
        
        //enable preview mode
        iRate.sharedInstance().previewMode = false
        
        return true;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as! an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        saveData();
        
        if( backgroundRun ){
            
            bgTask = application.beginBackgroundTaskWithExpirationHandler({ () -> Void in
                application.endBackgroundTask(self.bgTask);
                self.bgTask = UIBackgroundTaskInvalid;
            });
            
            localNotification = UILocalNotification();
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyBlindLevelChange:", name: kNotificationBlindLevelChange, object: nil);
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as! part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationBlindLevelChange, object: nil);
        
        localNotification.applicationIconBadgeNumber = 0;
        application.applicationIconBadgeNumber = 0;
        
        application.endBackgroundTask(bgTask);
        bgTask = UIBackgroundTaskInvalid;
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveData();
    }
    
    func notifyBlindLevelChange(notification : NSNotification){
        
        var blindLevel : BlindLevel = notification.object as! BlindLevel;

        UIApplication.sharedApplication().cancelAllLocalNotifications();
        localNotification.fireDate = NSDate().dateByAddingTimeInterval(1);
        localNotification.alertAction = nil;

        if( playSounds ){
            
            localNotification.soundName = blindChangeSound;//UILocalNotificationDefaultSoundName;
        }
        
        localNotification.repeatInterval = NSCalendarUnit.allZeros;
        localNotification.alertAction = "notification";

        if( blindLevel.isBreak ){

            localNotification.alertBody = NSLocalizedString("Blind levels are now on break", comment: "");
        }else{

            var ante : String = blindLevel.ante > 0 ? " ante \(blindLevel.ante)" : "";
            localNotification.alertBody = NSLocalizedString("New blind level: #", comment: "") + "\(blindLevel.levelNumber) - \(blindLevel.smallBlind) / \(blindLevel.bigBlind)\(ante)";
            localNotification.applicationIconBadgeNumber = blindLevel.levelNumber;
            
        }

        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

    func createUserDefaults(){
        
        currentBlindSetIndex = 0;
        needBackup           = true;
        lastAppVersion       = (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! NSString).doubleValue;
        
        var appleLanguages : NSArray = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as! NSArray;

        userDefaults.setObject(appleLanguages.objectAtIndex(0), forKey: kSettingsLanguage);
        userDefaults.setObject("blind-change-1", forKey:kSettingsBlindChangeSound);
        userDefaults.setObject("Airport", forKey:kSettingsBlindChangeSoundName);
        userDefaults.setObject("minute-alert-1", forKey:kSettingsLastMinuteSound);
        userDefaults.setObject("Morse", forKey:kSettingsLastMinuteSoundName);
        userDefaults.setObject("first-ante-1", forKey:kSettingsFirstAnteSound);
        userDefaults.setObject(backgroundMode, forKey: kSettingsBackgroundMode);
        userDefaults.setObject(backgroundImageName, forKey: kSettingsBackgroundImageName);
        
        enableBackup = BlindSet.checkiCloudBackupAvailability();
        
        userDefaults.setInteger(currentBlindSetIndex, forKey: kCurrentBlindSetIndex);
        userDefaults.setBool(true, forKey: kSettingsPlaySounds);
        userDefaults.setBool(true, forKey: kSettingsBackgroundRun);
        userDefaults.setBool(true, forKey: kSettingsPreventSleep);
        userDefaults.setBool(true, forKey: kSettingsFiveSecondsClock);
        userDefaults.setBool(true, forKey: kSettingsLongPauseAlert);
        userDefaults.setBool(true, forKey: kSettingsShortBlindNumber);
        userDefaults.setBool(false, forKey: kSettingsNotifyFirstAnte);
        userDefaults.setBool(false, forKey: kSettingsConvertedBlindSet);
        userDefaults.setBool(false, forKey: kSettingsEnableMultipeer);
        userDefaults.setBool(enableBackup, forKey: kSettingsEnableBackup);
        userDefaults.setBool(inverseTextColor, forKey: kSettingsInverseTextColor);
        userDefaults.setBool(hideStatusBar, forKey: kSettingsHideStatusBar);
        userDefaults.setDouble(lastAppVersion, forKey: kSettingsLastAppVersion);
        userDefaults.setInteger(2, forKey: kSettingsLongPauseMinutes);
        userDefaults.setBool(true, forKey: kSavedSettings);
        
        UIApplication.sharedApplication().idleTimerDisabled = preventSleep;

        userDefaults.synchronize();
    }
    
    func loadSettings(){
        
        language             = userDefaults.objectForKey(kSettingsLanguage) as! String;
        currentBlindSetIndex = userDefaults.integerForKey(kCurrentBlindSetIndex);
        lastAppVersion       = (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! NSString).doubleValue;
        
        blindChangeSound      = userDefaults.objectForKey(kSettingsBlindChangeSound) as! String;
        lastMinuteSoundName   = userDefaults.objectForKey(kSettingsLastMinuteSoundName) as! String;
        lastMinuteSound       = userDefaults.objectForKey(kSettingsLastMinuteSound) as! String;
        blindChangeSoundName  = userDefaults.objectForKey(kSettingsBlindChangeSoundName) as! String;
        firstAnteSound        = userDefaults.objectForKey(kSettingsFirstAnteSound) as! String;
        backgroundMode        = userDefaults.objectForKey(kSettingsBackgroundMode) as! String;
        backgroundImageName   = userDefaults.objectForKey(kSettingsBackgroundImageName) as! String;
        
        if( backgroundImageName == "custom" ){
            
//            backgroundCustomImage = userDefaults.objectForKey(kSettingsBackgroundImageName) as! UIImage;
            
            var paths : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as! Array;
            var documentsDirectory : String = paths[0] as! String;
            
            // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
            var imagePath = "\(documentsDirectory)/backgroundCustomImage.data";
            
            backgroundCustomImage = UIImage(data: NSData(contentsOfFile: imagePath)!)!;
        }
        
        playSounds        = userDefaults.boolForKey(kSettingsPlaySounds);
        backgroundRun     = userDefaults.boolForKey(kSettingsBackgroundRun);
        preventSleep      = userDefaults.boolForKey(kSettingsPreventSleep);
        shortBlindNumber  = userDefaults.boolForKey(kSettingsShortBlindNumber);
        notifyFirstAnte   = userDefaults.boolForKey(kSettingsNotifyFirstAnte);
        fiveSecondsClock  = userDefaults.boolForKey(kSettingsFiveSecondsClock);
        enableMultipeer   = userDefaults.boolForKey(kSettingsEnableMultipeer);
        enableBackup      = userDefaults.boolForKey(kSettingsEnableBackup);
        inverseTextColor  = userDefaults.boolForKey(kSettingsInverseTextColor);
        hideStatusBar     = userDefaults.boolForKey(kSettingsHideStatusBar);
        longPauseAlert    = userDefaults.boolForKey(kSettingsLongPauseAlert);
        longPauseMinutes  = userDefaults.integerForKey(kSettingsLongPauseMinutes);
        convertedBlindSet = userDefaults.boolForKey(kSettingsConvertedBlindSet);
        
        userDefaults.setObject([language], forKey: "AppleLanguages");
        
        userDefaults.synchronize();
        
        UIApplication.sharedApplication().idleTimerDisabled = preventSleep;
    }
    
    func saveUserDefaults(){

        currentBlindSetIndex = timerViewController.currentBlindSetIndex;
        
        userDefaults.setObject(language, forKey:kSettingsLanguage);
        
        userDefaults.setObject(blindChangeSound, forKey:kSettingsBlindChangeSound);
        userDefaults.setObject(blindChangeSoundName, forKey:kSettingsBlindChangeSoundName);
        userDefaults.setObject(lastMinuteSound, forKey:kSettingsLastMinuteSound);
        userDefaults.setObject(lastMinuteSoundName, forKey:kSettingsLastMinuteSoundName);
        userDefaults.setObject(firstAnteSound, forKey:kSettingsFirstAnteSound);
        userDefaults.setObject(backgroundMode, forKey:kSettingsBackgroundMode);
        userDefaults.setObject(backgroundImageName, forKey:kSettingsBackgroundImageName);
        
        if( backgroundImageName == "custom" ){
            
            var imageData : NSData = UIImageJPEGRepresentation(self.backgroundCustomImage, 1);
            
            var paths : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as! Array;
            var documentsDirectory : String = paths[0] as! String;
            
            // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
            var imagePath = "\(documentsDirectory)/backgroundCustomImage.data";
            
            // Write image data to user's folder
            imageData.writeToFile(imagePath, atomically: true);
            
            userDefaults.setObject(imageData, forKey:kSettingsBackgroundCustomImage);
        }
        
        userDefaults.setInteger(currentBlindSetIndex, forKey: kCurrentBlindSetIndex);
        userDefaults.setBool(playSounds, forKey:kSettingsPlaySounds);
        userDefaults.setBool(backgroundRun, forKey:kSettingsBackgroundRun);
        userDefaults.setBool(preventSleep, forKey:kSettingsPreventSleep);
        userDefaults.setBool(fiveSecondsClock, forKey:kSettingsFiveSecondsClock);
        userDefaults.setBool(longPauseAlert, forKey:kSettingsLongPauseAlert);
        userDefaults.setBool(shortBlindNumber, forKey:kSettingsShortBlindNumber);
        userDefaults.setBool(notifyFirstAnte, forKey:kSettingsNotifyFirstAnte);
        userDefaults.setInteger(longPauseMinutes, forKey:kSettingsLongPauseMinutes);
        userDefaults.setBool(convertedBlindSet, forKey:kSettingsConvertedBlindSet);
        userDefaults.setBool(enableMultipeer, forKey:kSettingsEnableMultipeer);
        userDefaults.setBool(enableBackup, forKey:kSettingsEnableBackup);
        userDefaults.setBool(inverseTextColor, forKey:kSettingsInverseTextColor);
        userDefaults.setBool(hideStatusBar, forKey:kSettingsHideStatusBar);
        userDefaults.setDouble(lastAppVersion, forKey: kSettingsLastAppVersion);
        
        NSUserDefaults.standardUserDefaults().setObject(NSArray(object: language), forKey: "AppleLanguages");
        
        UIApplication.sharedApplication().idleTimerDisabled = preventSleep;

        userDefaults.synchronize();
    }
    
    func saveData(){
        
        blindSetList = timerViewController.blindSetList;
        
        (timerViewController as! TimerViewController).blindSet.currentElapsedSeconds     = (timerViewController as! TimerViewController).currentElapsedSeconds;
        blindSetList[timerViewController.currentBlindSetIndex] = (timerViewController as! TimerViewController).blindSet;
        
        BlindSet.archiveBlindSetList(blindSetList);
        saveUserDefaults();
    }
    
    
    func enableMultipeerConnection(){
        
        mpcManager = MPCManager();
        mpcManager.delegate = self;
        
        // Só vai ficar visível se for um iPhone. Um iPad não controlará outro iPad
        if( Constants.DeviceIdiom.IS_IPHONE ){
            
            mpcManager.advertiser.startAdvertisingPeer();
        }else{
            
            // E só vai procurar por outros dispositivos se for um iPad
            mpcManager.browser.startBrowsingForPeers();
        }
        
        //            mpcManager.advertiser.stopAdvertisingPeer();
    }
    
    func foundPeer() {

        if( Constants.DeviceIdiom.IS_IPAD ){
            
            dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName("MPCManagerFoundPeer", object:nil);
            })
        }
    }
    
    
    func lostPeer() {

        if( Constants.DeviceIdiom.IS_IPAD ){
            
            dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName("MPCManagerLostPeer", object:nil);
            })
        }
    }
    
    func invitationWasReceived(fromPeer: String) {

//        let alert = UIAlertController(title: "", message: "\(fromPeer) "+NSLocalizedString("wants to connect with you", comment:""), preferredStyle: UIAlertControllerStyle.Alert)
        
//        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
        
            (self.timerViewController as! iPhone_TimerViewController).showActivityIndicatorView(fromPeer);
            self.mpcManager.invitationHandler(true, self.mpcManager.session)
//        }
        
//        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
//            self.mpcManager.invitationHandler(false, nil)
//        }
//        
//        alert.addAction(acceptAction)
//        alert.addAction(declineAction)
//        
//        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
//            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {

//        print("connectedWithPeer, ");
        
        if( Constants.DeviceIdiom.IS_IPHONE ){
            
            (timerViewController as! iPhone_TimerViewController).loadRemoteControl();
            
            // Se um iPhone for conectado por um iPad ele para de aceitar conexões
//            mpcManager.advertiser.stopAdvertisingPeer();
            isAdvertising = false;
            
//            println("I'm an iPhone");
        }else if( Constants.DeviceIdiom.IS_IPAD ){
            
//            println("I'm an iPad");
            dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName("MPCManagerConnectedWithPeer", object:peerID);
            })
        }
    }
    
    func disconnectedFromPeer(){
        
//        println("disconnectedFromPeer");
        
        lastMultipeerDeviceID = multipeerDeviceID;
        
        multipeerDeviceName = NSLocalizedString("No device", comment: "");
        multipeerDeviceID   = "";
        
        if( Constants.DeviceIdiom.IS_IPHONE ){
  
            (timerViewController as! iPhone_TimerViewController).unloadRemoteControl();
            
//             Se for um iPhone e desconectar de um iPad, volta a aceitar conexões
//            mpcManager.advertiser.startAdvertisingPeer();
            isAdvertising = true;
        }
        
        if( Constants.DeviceIdiom.IS_IPAD ){

            dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName("MPCManagerDisconnectedFromPeer", object:nil);
            })
        }
    }
    
    func isLandscape() -> Bool {
        
        var orientation = UIApplication.sharedApplication().statusBarOrientation;
        return UIInterfaceOrientationIsLandscape(orientation);
    }
    
    func isPortrait() -> Bool {
        
        var orientation = UIApplication.sharedApplication().statusBarOrientation;
        return UIInterfaceOrientationIsPortrait(orientation);
    }
    
    
    
    func checkLiteVersion(message: String) -> Bool {
        
        if( Constants.LITE_VERSION ){
            
            var alertView = UIAlertView(title: NSLocalizedString("Feature unavailable", comment: ""), message: message, delegate: self, cancelButtonTitle: NSLocalizedString("Not now", comment: ""), otherButtonTitles: NSLocalizedString("Upgrade", comment: ""));
            
            alertView.show();
            
            return false;
        }
        
        return true;
    }
    
    func checkLiteVersion() -> Bool {
        
        return checkLiteVersion(NSLocalizedString("This feature is only available in the full version of the app.\nWould you like to upgrade now?", comment:""));
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if( buttonIndex == 1 ){
            
            let appUrl = String(format: "\(Constants.APP_URL)", language);
            
            UIApplication.sharedApplication().openURL(NSURL(string: appUrl)!);
        }else{
            
            
        }
    }
}

