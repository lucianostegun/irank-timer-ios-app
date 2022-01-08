//
//  BlindSetWizardViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 20/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BlindSetWizardViewController : BackgroundViewController {
    
    @IBOutlet weak var imgTablePlayers: UIImageView!
    @IBOutlet weak var btnGenerateBlindSet: UIBarButtonItem!
    @IBOutlet weak var sldrPlayers: UISlider!
    @IBOutlet weak var sldrDuration: UISlider!
    
    @IBOutlet weak var lblPlayers: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var swcPlayWithAnte: UISwitch!
    @IBOutlet weak var swcIncludeBreak: UISwitch!
    
    var sourceViewController : TimerViewController!;

    var selectedChips : Int = 0;
    var players : Int = 5;
    var blindDuration : Int = 15;
    
    var chips1     = false;
    var chips5     = false;
    var chips10    = false;
    var chips25    = false;
    var chips50    = false;
    var chips100   = false;
    var chips500   = false;
    var chips1000  = false;
    var chips5000  = false;
    var chips10000 = false;
    
    @IBAction func dismissViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        sldrPlayers.value  = Float(players);
        sldrDuration.value = Float(blindDuration);
        
        startBackgroundTransition();
        
//        var buttonImage : UIImage = UIImage(named: "blackButton.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(45, 45, 45, 45));
//        var buttonImageHighlight : UIImage = UIImage(named: "blackButtonHighlight.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(45, 45, 45, 45));
        
        // Set the background for any states you plan to use
//        btnGenerateBlindSet.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
//        btnGenerateBlindSet.setBackgroundImage(buttonImageHighlight, forState: UIControlState.Highlighted)
        
        changePlayers(self);
        changeDuration(self);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }

    @IBAction func toggleChip(sender: AnyObject) {
        
        var chip : UIButton = sender as! UIButton;
        var selected : Bool = chip.alpha != 1;
        
        selectedChips += selected ? 1 : -1;
        
        if( selectedChips >= 4 ){
            
            btnGenerateBlindSet.enabled = true;
        }else if( selectedChips >= 5 ){
            
            selectedChips = 5;
            btnGenerateBlindSet.enabled = true;
            return;
        }else{
            
            btnGenerateBlindSet.enabled = false;
        }
        
        if( chip.alpha==1 ){

            chip.alpha = 0.2;
        }else{
        
            chip.alpha = 1;
        }
        
        switch( chip.tag ){
        case 1:
            chips1 = selected;
            break;
        case 5:
            chips5 = selected;
            break;
        case 10:
            chips10 = selected;
            break;
        case 25:
            chips25 = selected;
            break;
        case 50:
            chips50 = selected;
            break;
        case 100:
            chips100 = selected;
            break;
        case 500:
            chips500 = selected;
            break;
        case 1000:
            chips1000 = selected;
            break;
        case 5000:
            chips5000 = selected;
            break;
        case 10000:
            chips10000 = selected;
            break;
        default:
            break;
        }
    }
    
    @IBAction func changePlayers(sender: AnyObject) {
        
        players = Int(sldrPlayers.value);
        
        switch( players ){
        case 2:
            lblPlayers.text = NSLocalizedString("Heads Up", comment: "");
            imgTablePlayers.image = UIImage(named: "table-\(players)-players.png");
            break;
        case 11:
            lblPlayers.text = NSLocalizedString("Multi table (10+)", comment: "");
            imgTablePlayers.image = UIImage(named: "table-10-players.png");
            break;
        default:
            lblPlayers.text = "\(players) " + NSLocalizedString("players", comment: "");
            imgTablePlayers.image = UIImage(named: "table-\(players)-players.png");
            break;
        }
    }
    
    @IBAction func changeDuration(sender: AnyObject) {
        
        blindDuration = Int(sldrDuration.value);
        var pluralMinutes = blindDuration == 1 ? NSLocalizedString("minute", comment: "") : NSLocalizedString("minutes", comment: "");
        lblDuration.text = "\(blindDuration) \(pluralMinutes)";
    }
    
    
    @IBAction func generateBlindSet(sender: AnyObject) {
        
        
        var smallValue : Int = 0;
        
        if( chips10000 ){
            smallValue = 10000;
        }
        
        if( chips5000 ){
            smallValue = 5000;
        }
        
        if( chips1000 ){
            smallValue = 1000;
        }
        
        if( chips500 ){
            smallValue = 500;
        }
        
        if( chips100 ){
            smallValue = 100;
        }
        
        if( chips50 ){
            smallValue = 50;
        }
        
        if( chips25 ){
            smallValue = 25;
        }
        
        if( chips10 ){
            smallValue = 10;
        }
        
        if( chips5 ){
            smallValue = 5;
        }
        
        if( chips1 ){
            smallValue = 1;
        }
        
        var smallBlind     = smallValue;
        var bigBlind       = smallValue*2;
        var ante           = 0;
        var lastSmallBlind = 0;
        var lastBigBlind   = 0;
        var lastDifference = 0;
        
        var blindSet : BlindSet = BlindSet();
        blindSet.isNew = true;
        blindSet.blindSetName = NSLocalizedString("New blind set", comment: "");
        
        var levelNumber : Int = 0;

        for(var level=1; level <= 20; level++){
            
            var blindLevel : BlindLevel = BlindLevel();
            
            if( (swcIncludeBreak.on == true && level == 7) ||
                (swcIncludeBreak.on == false && players > 6 && level==7) ||
                (players > 7 && level == 15) ){
                    
                    var duration : Int = Int(Float(blindDuration)*0.66);
                    duration  = duration < 15 ? duration : 15;
                    duration  = Int(ceil(Float(duration)/5)*5);
                    
                    blindLevel.isBreak = true;
                    blindLevel.duration = duration*60;
            }else{
                
                levelNumber++;
                
                var percent : Float = 0;
                
                switch( levelNumber ){
                case 1:
                    smallBlind = smallValue;
                    break;
                case 2:
                    percent = 2;
                    break;
                case 3:
                    percent = 1.5;
                    break;
                case 4:
                    percent = 1.4;
                    break;
                case 5:
                    percent = 1.2;
                    ante = smallValue;
                    break;
                case 6:
                    percent = 1.2;
                    break;
                case 7:
                    percent = 1.25;
                    ante += smallValue;
                    break;
                case 8:
                    percent = 1.5;
                    break;
                case 9:
                    percent = 1.7;
                    ante += smallValue*2;
                    break;
                case 10:
                    percent = 1.5;
                    ante += smallValue*2;
                    break;
                case 11:
                    percent = 1.33;
                    ante += smallValue*2;
                    break;
                case 12:
                    percent = 1.5;
                    ante += smallValue*2;
                    break;
                case 13:
                    percent = 1.66;
                    ante *= 2;
                    break;
                case 14:
                    percent = 1.5;
                    break;
                case 15:
                    percent = 1.335;
                    ante += ante/2;
                    break;
                case 16:
                    percent = 1.5;
                    break;
                case 17:
                    percent = 1.334;
                    ante += ante/3;
                    break;
                case 18:
                    percent = 1.5;
                    break;
                default:
                    break;
                }
                
                if( levelNumber != 1 ){
                    
                    smallBlind = Int(round((Float(smallBlind)*percent)/Float(smallValue))) * smallValue;
                }
                
                if( swcPlayWithAnte.on == false ){
                    
                    ante = 0;
                }
                
                bigBlind = smallBlind*2;
                
                blindLevel = BlindLevel();
                blindLevel.levelNumber = levelNumber;
                blindLevel.levelIndex  = blindSet.blindLevelList.count;
                blindLevel.smallBlind  = smallBlind;
                blindLevel.bigBlind    = bigBlind;
                blindLevel.ante        = ante
                blindLevel.duration    = blindDuration*60;
                
                lastDifference = smallBlind-lastSmallBlind;
                
                lastSmallBlind = smallBlind;
                lastBigBlind   = bigBlind;
            }
            
            blindLevel.elapsedTime = Util.formatTimeString(Float(blindSet.getElapsedSeconds(blindLevel.levelIndex)+(blindLevel.duration))) as! String;
            blindSet.addBlindLevel(blindLevel)
        }
        
        blindSet.updateMetadata();
        

        let storyboard = UIStoryboard(name: "iPad_BlindSetEditor", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        let svc        = vc.viewControllers.first as! iPad_BlindSetEditorViewController;
        
        svc.sourceViewController = self.sourceViewController;

        svc.blindSet      = blindSet;
        svc.tripleDismiss = true;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
}