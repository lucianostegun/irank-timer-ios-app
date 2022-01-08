//
//  BlindLevelCell.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 05/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit;
import Foundation

class BlindLevelCell : UITableViewCell {
    
    @IBOutlet var lblLevelNumber : UILabel!;
    @IBOutlet var lblSmallBlind : UILabel!;
    @IBOutlet var lblBigBlind : UILabel!;
    @IBOutlet var lblAnte : UILabel!;
    @IBOutlet var lblDuration : UILabel!;
    @IBOutlet var lblElapsedTime : UILabel!;
}