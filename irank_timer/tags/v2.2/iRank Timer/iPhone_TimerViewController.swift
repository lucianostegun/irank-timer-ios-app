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
        
        if( Constants.LITE_VERSION ){
            
            iAdBannerView.frame  = CGRectMake(0, 0, self.view.bounds.size.width, 50);
            iAdBannerView.contentMode = UIViewContentMode.Center;
            self.view.addSubview(iAdBannerView)
            
            
            lblTimer.first!.frame.origin.y         = lblTimer.first!.frame.origin.y + 10;
            btnPreviousLevel.first!.frame.origin.y = btnPreviousLevel.first!.frame.origin.y + 10;
            btnNextLevel.first!.frame.origin.y     = btnNextLevel.first!.frame.origin.y + 10;
            
            // -----------------------
            
            lblTimer.last!.frame.size.height    = 60;
            btnTimer.last!.frame.size.height    = 60;
            
            lblTimer.last!.font = UIFont(name: "Helvetica Neue", size: 65.0);
            
            lblTimer.last!.frame.origin.y       = lblTimer.last!.frame.origin.y + 40;
            btnTimer.last!.frame.origin.y       = btnTimer.last!.frame.origin.y + 40;
            sldrTimeSlider.last!.frame.origin.y = sldrTimeSlider.last!.frame.origin.y + 15;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.navigationBarHidden = true;
        self.navigationController?.toolbarHidden = true;
        
        switchOptionalLabels();
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated);
//        
//        if( Constants.LITE_VERSION ){
//            
//            iAdBannerView.frame       = CGRectMake(0, 0, self.view.bounds.width, 50);
//            iAdBannerView.contentMode = UIViewContentMode.Center;
//        }
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

        portraitView.hidden = appDelegate.isLandscape();
    }
    
    func switchOptionalLabels(){
        
        if( !Constants.DeviceType.IS_IPHONE_6 && !Constants.DeviceType.IS_IPHONE_6P ){
            
            imgHorizontalLineLeft.first!.hidden = true;
            imgHorizontalLineLeft.last!.hidden = imgHorizontalLineLeft.first!.hidden
            imgHorizontalLineRight.first!.hidden = true;
            imgHorizontalLineRight.last!.hidden = imgHorizontalLineRight.first!.hidden
            lblNextLevel.first!.hidden = true;
            lblNextLevel.last!.hidden = lblNextLevel.first!.hidden
            
            var hideExtraLabels : Bool = Constants.DeviceType.IS_IPHONE_4_OR_LESS || appDelegate.isLandscape();
            
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