//
//  iPhone_CreateMenuViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_CreateMenuViewController : CreateMenuViewController {
    
    @IBOutlet weak var btnPresetBlindSet: UIButton!
    @IBOutlet weak var btnManualBlindSet: UIButton!
    @IBOutlet weak var lblPresetBlindSet: UILabel!
    @IBOutlet weak var lblManualBlindSet: UILabel!
    
    var startAsLandscape : Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight;
    }
}