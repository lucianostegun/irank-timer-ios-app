//
//  iPhone_TimerNavigationController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 01/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_TimerNavigationController: UINavigationController {

    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
}