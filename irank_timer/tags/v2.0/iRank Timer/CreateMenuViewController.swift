//
//  CreateMenuViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 07/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class CreateMenuViewController : BackgroundViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    var sourceViewController : TimerViewController!;
    
    @IBAction func dismissViewController(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        if( appDelegate.IS_IPHONE ){
            
            backgroundWidth  = 928
            backgroundHeight = 522;
        }
        
        startBackgroundTransition();
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    @IBAction func loadBlindSetEditorStoryboard(sender: AnyObject) {
        
        let iDevice    = appDelegate.IS_IPAD ? "iPad" : "iPhone";
        
        let storyboard = UIStoryboard(name: "\(iDevice)_BlindSetEditor", bundle: nil)

        var blindSet = BlindSet();
        blindSet.isNew = true;
        blindSet.elapsedSeconds = 0;
        blindSet.currentLevelIndex = 0;
        blindSet.nextBreakRemain = 0;
        blindSet.playSound = true;
        blindSet.blindChangeAlert = true;
        blindSet.minuteAlert = true;
        blindSet.breaks = 1;
        blindSet.levels = 0;
        blindSet.seconds = 0;
        blindSet.blindSetName = NSLocalizedString("New blind set", comment: "");
        blindSet.duration = "00:00:00";
        
        var blindLevel : BlindLevel = BlindLevel();
        blindLevel.levelIndex  = 0;
        blindLevel.levelNumber = 1;
        blindLevel.smallBlind  = 0;
        blindLevel.bigBlind    = 0;
        blindLevel.ante        = 0;
        blindLevel.duration    = 0;
        blindLevel.isBreak     = false;
        blindLevel.elapsedTime = "00:00:00";
        
        blindSet.blindLevelList.append(blindLevel);
        
        if( appDelegate.IS_IPAD ){
            
            let vc         = storyboard.instantiateInitialViewController() as! UINavigationController
            let svc = vc.viewControllers.first as! iPad_BlindSetEditorViewController;
            
            svc.sourceViewController = self.sourceViewController;
            svc.blindSet = blindSet;
            svc.doubleDismiss = true;
            
            self.presentViewController(vc, animated: true, completion: nil);
        }else{
            
            let vc = storyboard.instantiateInitialViewController() as! iPhone_BlindSetEditorViewController
            println(self.sourceViewController);
            vc.sourceViewController = self.sourceViewController;
            vc.blindSet = blindSet;
            vc.doubleDismiss = true;
            
            self.presentViewController(vc, animated: true, completion: nil);
        }
    }
    
    @IBAction func loadPresetBlindSetsStoryboard(sender: AnyObject) {
        
        let iDevice    = appDelegate.IS_IPAD ? "iPad" : "iPhone";
        let storyboard = UIStoryboard(name: "\(iDevice)_PresetBlindSets", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController
        let svc        = vc.viewControllers.first as! PresetBlindSetsViewController;
        
        svc.sourceViewController = self.sourceViewController;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func loadBlindSetWizardStoryboard(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPad_BlindSetWizard", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController
        let svc        = vc.viewControllers.first as! BlindSetWizardViewController;
        
        svc.sourceViewController = self.sourceViewController;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
}