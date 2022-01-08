//
//  ConfigViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 11/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigViewController : UISplitViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
}