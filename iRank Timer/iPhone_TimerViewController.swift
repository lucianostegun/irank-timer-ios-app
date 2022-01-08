//
//  iPhone_TimerViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 28/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_TimerViewController: TimerViewController {
    
    @IBOutlet var portraitView: UIView!
    @IBOutlet var landscapeView: UIView!
    
    var timerMenuViewController : iPhone_TimerMenuViewController!;
    var remoteControlViewController : iPhone_RemoteControlViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        backgroundWidth  = 928
        backgroundHeight = 522;
        
        startBackgroundTransition();
        
        switchOptionalLabels();
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDeviceOrientationDidChange:"), name: UIDeviceOrientationDidChangeNotification, object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.navigationBarHidden = true;
        self.navigationController?.toolbarHidden = true;
        
        switchOptionalLabels();
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
    }
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return appDelegate.hideStatusBar;
    }
    
    func onDeviceOrientationDidChange(notifiction : NSNotification){
        
        switchOptionalLabels();
//
//        println("appDelegate.isPortrait(): \(appDelegate.isPortrait())");
//        println("appDelegate.isLandscape(): \(appDelegate.isLandscape())");
//        
        portraitView.hidden = appDelegate.isLandscape();
//        landscapeView.hidden = appDelegate.isPortrait();
//        
//        println("portraitView.hidden: \(portraitView.hidden) : \(portraitView.frame)");
//        println("landscapeView.hidden: \(landscapeView.hidden) : \(landscapeView.frame)");
    }
    
//    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        
//        switchOptionalLabels();
//        
//        if( appDelegate.isLandscape() && (fromInterfaceOrientation == UIInterfaceOrientation.Portrait || fromInterfaceOrientation == UIInterfaceOrientation.PortraitUpsideDown) ){
//
//            portraitView.hidden  = true;
//        }else if( appDelegate.isPortrait() && (fromInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientation.LandscapeRight) ){
//            
//            portraitView.hidden  = false;
//        }
//    }
    
    func switchOptionalLabels(){
        
        if( !appDelegate.IS_IPHONE_6 && !appDelegate.IS_IPHONE_6P ){
            
            imgHorizontalLineLeft.first!.hidden = true;
            imgHorizontalLineLeft.last!.hidden = imgHorizontalLineLeft.first!.hidden
            imgHorizontalLineRight.first!.hidden = true;
            imgHorizontalLineRight.last!.hidden = imgHorizontalLineRight.first!.hidden
            lblNextLevel.first!.hidden = true;
            lblNextLevel.last!.hidden = lblNextLevel.first!.hidden
            
            var hideExtraLabels : Bool = appDelegate.IS_IPHONE_4_OR_LESS || appDelegate.isLandscape();
            
                lblNextSmallBlind.first!.hidden = hideExtraLabels;
                lblNextSmallBlind.last!.hidden = lblNextSmallBlind.first!.hidden
                lblNextBigBlind.first!.hidden = hideExtraLabels;
                lblNextBigBlind.last!.hidden = lblNextBigBlind.first!.hidden
                lblNextAnte.first!.hidden = hideExtraLabels;
                lblNextAnte.last!.hidden = lblNextAnte.first!.hidden
        }
    }
    
    override func showHandAnimation(){
        
        if( !appDelegate.firstExecution ){
            
            return;
        }
        
        appDelegate.firstExecution = false;
        
        imgHand.first!.frame = CGRectMake(432, 166, 115, 135);
        imgHand.last!.frame = imgHand.first!.frame
        imgHand.first!.hidden = false;
        imgHand.last!.hidden = imgHand.first!.hidden
        imgHand.first!.alpha = 1;
        imgHand.last!.alpha = imgHand.first!.alpha
        
        UIView .animateWithDuration(1.25, animations: {
            self.imgHand.first!.alpha = 0;
            self.imgHand.first!.frame = CGRectMake(232, 166, 115, 135);
        });
        
        NSTimer.scheduledTimerWithTimeInterval(3.25, target: self, selector: Selector("showHandAnimation"), userInfo: nil, repeats: false);
    }
    
    @IBAction func swipeControlsLeft(sender: AnyObject) {
        
        performSegueWithIdentifier("MenuViewSegue", sender: self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "MenuViewSegue" ){
            
            var vc = segue.destinationViewController as! iPhone_TimerMenuViewController;
            
            timerMenuViewController = vc;
            
            var imgBackground = UIImageView(image: imgBackground2.first!.image);
            imgBackground.frame = vc.tableView.frame;
            
            vc.tableView.backgroundColor = UIColor.clearColor();
            vc.tableView.backgroundView = imgBackground;
            vc.timerViewController = self;
        }
        
        if( segue.identifier == "PresentLandscapeViewControllerSegue" ){
            
            var vc = segue.destinationViewController as! iPhone_TimerViewController;
            
            vc.transitionBackground = false;
            
            vc.imgBackground1 = self.imgBackground1
            vc.imgBackground2 = self.imgBackground2
            
            vc.isRunning               = self.isRunning;
            vc.currentLevelIndex       = self.currentLevelIndex;
            vc.currentBlindSetIndex    = self.currentBlindSetIndex;
            vc.editingBlindSetIndex    = self.editingBlindSetIndex;
            vc.timer                   = self.timer;
            vc.longPauseTimer          = self.longPauseTimer;
            vc.blindSet                = self.blindSet;
            vc.blindSetList            = self.blindSetList;
            vc.currentElapsedSeconds   = self.currentElapsedSeconds;
            vc.moveMainViewOnEdit      = self.moveMainViewOnEdit;
            vc.firstAnteNotified       = self.firstAnteNotified;
            
            //            vc.sldrTimeSlider.value     = self.sldrTimeSlider.value
            //            vc.lblTimer.text            = self.lblTimer.text
            //            vc.lblSmallBlind.text       = self.lblSmallBlind.text
            //            vc.lblBigBlind.text         = self.lblBigBlind.text
            //            vc.lblAnte.text             = self.lblAnte.text
            //            vc.lblNextSmallBlind.text   = self.lblNextSmallBlind.text
            //            vc.lblNextBigBlind.text     = self.lblNextBigBlind.text
            //            vc.lblNextAnte.text         = self.lblNextAnte.text
            //            vc.lblElapsedTime.text      = self.lblElapsedTime.text
            //            vc.lblLevel.text            = self.lblLevel.text
            //            vc.lblNextBreak.text        = self.lblNextBreak.text
            //            vc.lblElapsedTimeLabel.text = self.lblElapsedTimeLabel.text
            //            vc.lblLevelLabel.text       = self.lblLevelLabel.text
            //            vc.lblNextBreakLabel.text   = self.lblNextBreakLabel.text
            //            vc.lblNextLevel.text        = self.lblNextLevel.text
            //            vc.lblSmallBlindLabel.text  = self.lblSmallBlindLabel.text
            //            vc.lblBigBlindLabel.text    = self.lblBigBlindLabel.text
            //            vc.lblAnteLabel.text        = self.lblAnteLabel.text
            //            vc.lblCountDown.text        = self.lblCountDown.text
            //
            //            if( isRunning ){
            //
            //                vc.startTimer();
            //            }
        }
    }
    
    override func updateBlindSet(newBlindSet : BlindSet){
        
        super.updateBlindSet(newBlindSet);
        
        timerMenuViewController.tableView.reloadData();
        timerMenuViewController.btnEdit.tag   = 0;
        timerMenuViewController.btnEdit.title = NSLocalizedString("Edit", comment: "");
        timerMenuViewController.tableView.setEditing(false, animated: true);
    }
    
    func showActivityIndicatorView(fromPeer: String){
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDModeIndeterminate
        loadingNotification.labelText = NSLocalizedString("Loading remote control", comment: "");
    }
    
    func loadRemoteControl(){
        
        if( isRunning ){
            
            pauseTimer(false);
            
            if( longPauseTimer != nil ){
                
                longPauseTimer.invalidate();
            }
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedMPCDataNotification", object: nil);
        
        let storyboard = UIStoryboard(name: "iPhone_RemoteControl", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! iPhone_RemoteControlNavigationController;
        
        remoteControlViewController = vc.viewControllers.first as! iPhone_RemoteControlViewController;
        
        remoteControlViewController.isRunning = isRunning;
        
        self.presentViewController(vc, animated: true, completion: nil);
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout();
        vc.view.setNeedsDisplay();
    }
    
    func unloadRemoteControl(){
        
        remoteControlViewController.dismissViewControllerAnimated(true, completion: nil);
    }
}