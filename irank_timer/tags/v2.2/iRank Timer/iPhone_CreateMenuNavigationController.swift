//
//  iPhone_CreateMenuNavigationController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_CreateMenuNavigationController: UINavigationController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
}