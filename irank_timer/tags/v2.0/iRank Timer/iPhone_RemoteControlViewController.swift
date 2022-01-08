//
//  iPhone_RemoteControlViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 02/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class iPhone_RemoteControlViewController : UIViewController, UIAlertViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    var countDownSeconds = 15;
    var isRunning : Bool = false;
    var countDownTimer : NSTimer!;
    
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var btnCountDown: UIButton!
    @IBOutlet weak var lblCountDown: UILabel!
    @IBOutlet weak var sldrCountDown: UISlider!
    @IBOutlet weak var btnPreviousLevel: UIButton!
    @IBOutlet weak var btnNextLevel: UIButton!
    @IBOutlet weak var imgBackground : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)
        
        self.navigationController?.navigationBarHidden = true;
        self.navigationController?.toolbarHidden = false;
        
        btnTimer.setTitle(isRunning ? NSLocalizedString("PAUSE TIMER", comment: "") : NSLocalizedString("START TIMER", comment: ""), forState: UIControlState.Normal)
        btnTimer.tag = isRunning ? 1 : 0;
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
    
    @IBAction func stopRemotecontrolMode(sender: AnyObject) {
     
        if( sendMessageFromRemotecontrol("_end_chat_") ){
            
            self.appDelegate.mpcManager.session.disconnect();
            self.dismissViewControllerAnimated(false, completion: nil);
            
            btnTimer.enabled         = false;
            btnCountDown.enabled     = false;
            sldrCountDown.enabled    = false;
            btnPreviousLevel.enabled = false;
            btnNextLevel.enabled     = false;
        }
    }
    
    @IBAction func toggleTimerState(sender: AnyObject) {
        
        if( sendMessageFromRemotecontrol("timer-toggleState") ){
            
            if( self.btnTimer.tag == 1 ){
                
                self.btnTimer.setTitle(NSLocalizedString("START TIMER", comment: ""), forState: UIControlState.Normal)
                self.btnTimer.tag = 0;
            }else{
                
                self.btnTimer.setTitle(NSLocalizedString("PAUSE TIMER", comment: ""), forState: UIControlState.Normal)
                self.btnTimer.tag = 1;
            }
        }
    }
    
    @IBAction func nextLevel(sender: AnyObject) {
        
        sendMessageFromRemotecontrol("timer-level-next")
    }
    
    @IBAction func previousLevel(sender: AnyObject) {
        
        sendMessageFromRemotecontrol("timer-level-previous")
    }
    
    @IBAction func toggleCountdown(sender: AnyObject) {
        
        if( countDownTimer != nil ){
            
            countDownTimer.invalidate()
        }
        
        if( btnCountDown.tag == 0 ){
            
            let messageDictionary: [String: String] = ["countDownSeconds": "\(countDownSeconds)"];
        
            if( appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: getConnectedPeer()) ){
                
                if( sendMessageFromRemotecontrol("countdown-start") ){
                    
                    btnCountDown.tag = 1;
                    btnCountDown.setTitle(NSLocalizedString("STOP COUNTDOWN", comment: ""), forState: UIControlState.Normal)
                    
                    countDownTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(countDownSeconds+5), target: self, selector: Selector("changeBtnCountDown"), userInfo: nil, repeats: false);
                }
            }
        }else{
            
            if( sendMessageFromRemotecontrol("countdown-stop") ){

                btnCountDown.tag = 0;
                btnCountDown.setTitle(NSLocalizedString("START COUNTDOWN", comment: ""), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func changeCountDownTimer(sender: AnyObject) {
        
        sldrCountDown.value = Float(Int(sldrCountDown.value));
        countDownSeconds = Int(sldrCountDown.value);
        
        lblCountDown.text = "\(countDownSeconds) " + NSLocalizedString("seconds", comment: "");
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        
        var title     = NSLocalizedString("Reset timer", comment: "");
        var message   = NSLocalizedString("Do you want to reset timer and load the first level of this blind set?", comment: "");
        var yesButton = NSLocalizedString("YES", comment: "")
        var noButton  = NSLocalizedString("NO", comment: "");
        
        confirmAlertView(title, message: message, noButton: noButton, yesButton: yesButton, tag: 1);
    }
    
    func confirmAlertView(title : String, message : String, noButton : String, yesButton : String, tag : Int){
        
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: noButton, otherButtonTitles: yesButton)
        
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if( buttonIndex == 1 ){
            
            sendMessageFromRemotecontrol("timer-reset")
        }
    }
    
    func changeBtnCountDown(){

        btnCountDown.tag = 0;
        btnCountDown.setTitle(NSLocalizedString("START COUNTDOWN", comment: ""), forState: UIControlState.Normal)
    }
    
    func getConnectedPeer() -> MCPeerID! {
        
        if( appDelegate.mpcManager.session.connectedPeers.count == 0 ){
            
            self.appDelegate.mpcManager.session.disconnect();
            self.dismissViewControllerAnimated(false, completion: nil);
            
            return nil;
        }
        
        return appDelegate.mpcManager.session.connectedPeers[0] as! MCPeerID
    }
    
    func sendMessageFromRemotecontrol(message: String) -> Bool {
        
        if( !appDelegate.enableMultipeer ){

            return false;
        }
        
        if( getConnectedPeer() != nil ){
            
            let messageDictionary: [String: String] = ["message": message];
            return appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: getConnectedPeer())
        }
        
        return false;
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, String>
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            // Make sure that the message is other than "_end_chat_".
            if message != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
                //                var messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                println("message on remote control: \(message)");
                
                switch( message ){
                case "timer-running":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        if( self.btnTimer.tag == 0 ){
                            
                            self.btnTimer.setTitle(NSLocalizedString("PAUSE TIMER", comment: ""), forState: UIControlState.Normal)
                            self.btnTimer.tag = 1;
                        }
                    })
                    break;
                case "timer-notRunning":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        if( self.btnTimer.tag == 1 ){
                            
                            self.btnTimer.setTitle(NSLocalizedString("START TIMER", comment: ""), forState: UIControlState.Normal)
                            self.btnTimer.tag = 0;
                        }
                    })
                    break;
                case "countdown-running":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        if( self.btnCountDown.tag == 0 ){
                            
                            self.btnCountDown.setTitle(NSLocalizedString("STOP COUNTDOWN", comment: ""), forState: UIControlState.Normal)
                            self.btnCountDown.tag = 1;
                        }
                    })
                    break;
                case "countdown-notRunning":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        if( self.btnCountDown.tag == 1 ){
                            
                            self.btnCountDown.setTitle(NSLocalizedString("START COUNTDOWN", comment: ""), forState: UIControlState.Normal)
                            self.btnCountDown.tag = 0;
                        }
                    })
                    break;
                default:
                    break;
                }
            }
            else{
                self.appDelegate.mpcManager.session.disconnect()
            }
        }
    }
}