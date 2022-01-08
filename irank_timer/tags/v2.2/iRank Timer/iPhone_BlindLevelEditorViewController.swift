//
//  iPhone_BlindLevelEditorViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 07/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_BlindLevelEditorViewController : BlindLevelEditorViewController {
    
    @IBOutlet weak var cellSuggestedStructure: UITableViewCell!
    
    override func loadSuggestions(){
        
        super.loadSuggestions();
        
        cellSuggestedStructure.hidden = btnSuggestion1.hidden && btnSuggestion2.hidden && btnSuggestion3.hidden && btnSuggestion4.hidden;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        super.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath);
        
//        cellSmallBlind.hidden         = (swcIsBreak.on == true);
//        cellBigBlind.hidden           = (swcIsBreak.on == true);
//        cellAnte.hidden               = (swcIsBreak.on == true);
        cellSuggestedStructure.hidden = (swcIsBreak.on == true);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if( blindSet.blindLevelList[currentLevelIndex].isBreak == true ){
            
            if( indexPath.row > 0 && indexPath.row > 1 ){
                
                return 0;
            }
        }
        
        if( indexPath.row == 2 && btnSuggestion1.hidden && btnSuggestion2.hidden && btnSuggestion3.hidden && btnSuggestion4.hidden ){
            return 0;
        }
        
        if( indexPath.row == 0 ){
            
            return 40;
        }
        
        return 34;
    }
    
    override func replicateDuration(sender: AnyObject) {
        super.replicateDuration(sender);
        
        (sender as! UIButton).setTitle("", forState: UIControlState.Normal);
        (sender as! UIButton).setImage(imgReplicatedDuration.image, forState: UIControlState.Normal)
    }
    
    override func loadBlindLevelFields() {
        super.loadBlindLevelFields();
        
        btnReplicateDuration.setTitle(NSLocalizedString("replicate", comment: ""), forState: UIControlState.Normal);
        btnReplicateDuration.setImage(nil, forState: UIControlState.Normal);
    }
}
