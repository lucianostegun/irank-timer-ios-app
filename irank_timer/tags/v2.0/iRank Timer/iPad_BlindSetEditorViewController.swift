//
//  iPad_BlindSetEditorViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 07/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPad_BlindSetEditorViewController : UISplitViewController {
    
    var blindSet : BlindSet!;
    var sourceViewController : TimerViewController!;
    var doubleDismiss = false;
    var tripleDismiss = false;
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    func updateSourceViewController(blindSetTmp : BlindSet){
        
        if( sourceViewController != nil ){

            sourceViewController.updateBlindSet(blindSetTmp);
        }
    }
}