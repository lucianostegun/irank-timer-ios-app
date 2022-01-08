//
//  iPhone_BlindSetEditorViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 07/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_BlindSetEditorViewController : UINavigationController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    var blindSet : BlindSet!;
    var sourceViewController : TimerViewController!;
    var doubleDismiss = false;
    var tripleDismiss = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        println("prefersStatusBarHidden()");
        return appDelegate.hideStatusBar;
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    func updateSourceViewController(blindSetTmp : BlindSet){
        
        if( sourceViewController != nil ){

            println("blindSetTmp.isNew: \(blindSetTmp.isNew)");
            sourceViewController.updateBlindSet(blindSetTmp);
        }
    }
}