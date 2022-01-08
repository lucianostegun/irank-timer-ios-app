//
//  PresetBlindSetsViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 20/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BlindSetSearch {
    
    var blindSetId : Int!
    var blindSetName : String!
    var stack : String!
    var speed : String!
    var levels: Int!
    var breaks: Int!
    var hasAnte: Bool!
    var blindDuration: Int!
    var blindDurationLabel : String!
    var totalDuration: Int!
    var totalDurationLabel : String!
    var players: String!
    var chips : String!
    var startStack: Int!
}

class PresetBlindSetsViewController : BackgroundViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet weak var tableViewFilter: UITableView!
    @IBOutlet weak var tableViewResult: UITableView!
    
    var sourceViewController : TimerViewController!;
    
    var blindSetSearchList : Array<BlindSetSearch> = [];
    var microStackList : Array<BlindSetSearch>!;
    var regularStackList : Array<BlindSetSearch>!;
    var deepStackList : Array<BlindSetSearch>!;
    
    var stackMicro : Bool = true;
    var stackRegular : Bool = true;
    var stackDeep : Bool = true;
    
    var speedHyper : Bool = false;
    var speedTurbo : Bool = true;
    var speedNormal : Bool = false;
    var speedSlow : Bool = false;
    
    var players2_7 : Bool = true;
    var players8_13 : Bool = false;
    var players14_21 : Bool = false;
    
    var chips_1_2_5_10 : Bool = false;
    var chips_5_10_25_50 : Bool = false;
    var chips_10_25_50_100 : Bool = false;
    var chips_25_50_100_500 : Bool = true;
    var chips_50_100_1000 : Bool = false;
    var chips_50_500_1000_5000 : Bool = false;
    var chips_100_500_1000_5000 : Bool = false;
    var chips_100_500_1000_5000_10000 : Bool = false;
    
    var optionWithBreaks : Bool = true;
    var optionWithAnte : Bool = true;
    
    @IBAction func dismissViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        startBackgroundTransition();
        
        microStackList   = [];
        regularStackList = [];
        deepStackList    = [];
        
        var presetBlindSetList : NSArray! = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("preset-blindSets", ofType: "plist")!);
        
        for dict in presetBlindSetList {

            var blindSetSearch = BlindSetSearch();
            blindSetSearch.blindSetId         = (dict["blindSetId"] as! String).toInt()!;
            blindSetSearch.blindSetName       = (dict["blindSetName"] as! String);
            blindSetSearch.stack              = (dict["stack"] as! String);
            blindSetSearch.speed              = (dict["speed"] as! String);
            blindSetSearch.levels             = (dict["levels"] as! String).toInt();
            blindSetSearch.breaks             = (dict["breaks"] as! String).toInt();
            blindSetSearch.hasAnte            = (dict["hasAnte"] as! String) == "1" ? true : false;
            blindSetSearch.blindDuration      = (dict["blindDuration"] as! String).toInt();
            blindSetSearch.blindDurationLabel = (dict["blindDurationLabel"] as! String);
            blindSetSearch.totalDuration      = (dict["totalDuration"] as! String).toInt();
            blindSetSearch.totalDurationLabel = (dict["totalDurationLabel"] as! String);
            blindSetSearch.players            = (dict["players"] as! String);
            blindSetSearch.chips              = (dict["chips"] as! String);
            blindSetSearch.startStack         = (dict["startStack"] as! String).toInt();
            
            blindSetSearchList.append(blindSetSearch);
        }
        
        updateSearchFilter();
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        switch( tableView.tag ){
        case 0:
            return 5;
        default:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch( tableView.tag ){
        case 0:
            switch( section ){
            case 0:
                return 3;
            case 1:
                return 4;
            case 2:
                return 3;
            case 3:
                return 8;
            case 4:
                return 2;
            default:
                return 0;
            }
        case 1:
            switch( section ){
            case 0:
                return microStackList.count;
            case 1:
                return regularStackList.count;
            case 2:
                return deepStackList.count;
            default:
                return 0;
            }
        default:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if( tableView.tag == 0 ){
            
            var cell = UITableViewCell(
                style: UITableViewCellStyle.Default,
                reuseIdentifier: nil);
            switch( indexPath.section ){
            case 0:
                switch( indexPath.row ){
                case 0:
                    cell.textLabel?.text = NSLocalizedString("Micro stack", comment: "");
                    cell.accessoryType = stackMicro ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 1:
                    cell.textLabel?.text = NSLocalizedString("Regular stack", comment: "");
                    cell.accessoryType = stackRegular ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 2:
                    cell.textLabel?.text = NSLocalizedString("Deep stack", comment: "");
                    cell.accessoryType = stackDeep ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                default:
                    break;
                }
                break;
            case 1:
                switch( indexPath.row ){
                case 0:
                    cell.textLabel?.text = NSLocalizedString("Hyper turbo", comment: "");
                    cell.accessoryType = speedHyper ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 1:
                    cell.textLabel?.text = NSLocalizedString("Turbo", comment: "");
                    cell.accessoryType = speedTurbo ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 2:
                    cell.textLabel?.text = NSLocalizedString("Normal", comment: "");
                    cell.accessoryType = speedNormal ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 3:
                    cell.textLabel?.text = NSLocalizedString("Slow", comment: "");
                    cell.accessoryType = speedSlow ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                default:
                    break;
                }
                break;
            case 2:
                switch( indexPath.row ){
                case 0:
                    cell.textLabel?.text = NSLocalizedString("2 to 7 players", comment: "");
                    cell.accessoryType = players2_7 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    
                    break;
                case 1:
                    cell.textLabel?.text = NSLocalizedString("8 to 13 players", comment: "");
                    cell.accessoryType = players8_13 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 2:
                    cell.textLabel?.text = NSLocalizedString("14 to 21 players", comment: "");
                    cell.accessoryType = players14_21 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                default:
                    break;
                }
                break;
            case 3:
                switch( indexPath.row ){
                case 0:
                    cell.textLabel?.text = "1 / 2 / 5 / 10";
                    cell.accessoryType = chips_1_2_5_10 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 1:
                    cell.textLabel?.text = "5 / 10 / 25 / 50";
                    cell.accessoryType = chips_5_10_25_50 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 2:
                    cell.textLabel?.text = "10 / 25 / 50 / 100";
                    cell.accessoryType = chips_10_25_50_100 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 3:
                    cell.textLabel?.text = "25 / 50 / 100 / 500";
                    cell.accessoryType = chips_25_50_100_500 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 4:
                    cell.textLabel?.text = "50 / 100 / 1000";
                    cell.accessoryType = chips_50_100_1000 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 5:
                    cell.textLabel?.text = "50 / 500 / 1000 / 5000";
                    cell.accessoryType = chips_50_500_1000_5000 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 6:
                    cell.textLabel?.text = "100 / 500 / 1000 / 5000";
                    cell.accessoryType = chips_100_500_1000_5000 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 7:
                    cell.textLabel?.text = "100 / 500 / 1000 / 5000 / 10000";
                    cell.accessoryType = chips_100_500_1000_5000_10000 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                default:
                    break;
                }
                break;
            case 4:
                switch( indexPath.row ){
                case 0:
                    cell.textLabel?.text = NSLocalizedString("With breaks", comment: "");
                    cell.accessoryType = optionWithBreaks ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                case 1:
                    cell.textLabel?.text = NSLocalizedString("With ante", comment: "");
                    cell.accessoryType = optionWithAnte ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                    break;
                default:
                    break;
                }
                break;
            default:
                break;
            }
            return cell;
        }else{
            
            var cell = tableView.dequeueReusableCellWithIdentifier("PRESET_BLIND_SET_CELL", forIndexPath: indexPath) as! PresetBlindSetCell;
            
            switch( indexPath.section ){
            case 0:
                var pluralBreaks = microStackList[indexPath.row].breaks == 1 ? NSLocalizedString("break", comment: "") : NSLocalizedString("breaks", comment: "");
                
                var breaks : String = microStackList[indexPath.row].breaks == 0 ? NSLocalizedString("No breaks", comment: "") : "\(microStackList[indexPath.row].breaks) \(pluralBreaks)";
                
                cell.lblBlindSetName?.text  = microStackList[indexPath.row].blindSetName
                cell.lblLevels?.text        = "\(microStackList[indexPath.row].levels) "+NSLocalizedString("levels", comment: "")
                cell.lblBreaks?.text        = breaks
                cell.lblLevelDuration?.text = NSLocalizedString("Blinds: ", comment: "") + "\(microStackList[indexPath.row].blindDuration) " + NSLocalizedString("min.", comment: "")
                cell.lblTotalDuration?.text = NSLocalizedString("Duration: ", comment: "") + "\(microStackList[indexPath.row].totalDurationLabel)"
                cell.lblChips?.text         = NSLocalizedString("Chips: ", comment: "") + "\(microStackList[indexPath.row].chips)"
                cell.lblPlayers?.text       = "\(microStackList[indexPath.row].players) " + NSLocalizedString("players", comment: "")
                cell.lblStack?.text         = NSLocalizedString("Stack: ", comment: "") + "\(microStackList[indexPath.row].startStack)"
                break;
            case 1:
                var pluralBreaks = regularStackList[indexPath.row].breaks == 1 ? NSLocalizedString("break", comment: "") : NSLocalizedString("breaks", comment: "");
                
                var breaks : String = regularStackList[indexPath.row].breaks == 0 ? NSLocalizedString("No breaks", comment: "") : "\(regularStackList[indexPath.row].breaks) \(pluralBreaks)";
                
                cell.lblBlindSetName?.text  = regularStackList[indexPath.row].blindSetName
                cell.lblLevels?.text        = "\(regularStackList[indexPath.row].levels) "+NSLocalizedString("levels", comment: "")
                cell.lblBreaks?.text        = breaks
                cell.lblLevelDuration?.text = NSLocalizedString("Blinds: ", comment: "") + "\(regularStackList[indexPath.row].blindDuration) " + NSLocalizedString("min.", comment: "")
                cell.lblTotalDuration?.text = NSLocalizedString("Duration: ", comment: "") + "\(regularStackList[indexPath.row].totalDurationLabel)"
                cell.lblChips?.text         = NSLocalizedString("Chips: ", comment: "") + "\(regularStackList[indexPath.row].chips)"
                cell.lblPlayers?.text       = "\(regularStackList[indexPath.row].players) " + NSLocalizedString("players", comment: "")
                cell.lblStack?.text         = NSLocalizedString("Stack: ", comment: "") + "\(regularStackList[indexPath.row].startStack)"
                break;
            case 2:
                var pluralBreaks = deepStackList[indexPath.row].breaks == 1 ? NSLocalizedString("break", comment: "") : NSLocalizedString("breaks", comment: "");
                
                var breaks : String = deepStackList[indexPath.row].breaks == 0 ? NSLocalizedString("No breaks", comment: "") : "\(deepStackList[indexPath.row].breaks) \(pluralBreaks)";
                
                cell.lblBlindSetName?.text  = deepStackList[indexPath.row].blindSetName
                cell.lblLevels?.text        = "\(deepStackList[indexPath.row].levels) "+NSLocalizedString("levels", comment: "")
                cell.lblBreaks?.text        = breaks
                cell.lblLevelDuration?.text = NSLocalizedString("Blinds: ", comment: "") + "\(deepStackList[indexPath.row].blindDuration) " + NSLocalizedString("min.", comment: "")
                cell.lblTotalDuration?.text = NSLocalizedString("Duration: ", comment: "") + "\(deepStackList[indexPath.row].totalDurationLabel)"
                cell.lblChips?.text         = NSLocalizedString("Chips: ", comment: "") + "\(deepStackList[indexPath.row].chips)"
                cell.lblPlayers?.text       = "\(deepStackList[indexPath.row].players) " + NSLocalizedString("players", comment: "")
                cell.lblStack?.text         = NSLocalizedString("Stack: ", comment: "") + "\(deepStackList[indexPath.row].startStack)"
                break;
            default:
                break;
            }
            
            return cell;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return Constants.DeviceIdiom.IS_IPAD || tableViewFilter.tag == 0 ? 44 : 66;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if( tableView.tag == 0 ){
            
            switch( indexPath.section ){
            case 0:
                switch( indexPath.row ){
                case 0:
                    stackMicro = !stackMicro;
                    break;
                case 1:
                    stackRegular = !stackRegular;
                    break;
                case 2:
                    stackDeep = !stackDeep;
                    break;
                default:
                    break;
                }
                break;
            case 1:
                switch( indexPath.row ){
                case 0:
                    speedHyper = !speedHyper;
                    break;
                case 1:
                    speedTurbo = !speedTurbo;
                    break;
                case 2:
                    speedNormal = !speedNormal;
                    break;
                case 3:
                    speedSlow = !speedSlow;
                    break;
                default:
                    break;
                }
                break;
            case 2:
                switch( indexPath.row ){
                case 0:
                    players2_7 = !players2_7
                    break;
                case 1:
                    players8_13 = !players8_13
                    break;
                case 2:
                    players14_21 = !players14_21;
                    break;
                default:
                    break;
                }
                break;
            case 3:
                switch( indexPath.row ){
                case 0:
                    chips_1_2_5_10 = !chips_1_2_5_10;
                    break;
                case 1:
                    chips_5_10_25_50 = !chips_5_10_25_50;
                    break;
                case 2:
                    chips_10_25_50_100 = !chips_10_25_50_100;
                    break;
                case 3:
                    chips_25_50_100_500 = !chips_25_50_100_500;
                    break;
                case 4:
                    chips_50_100_1000 = !chips_50_100_1000;
                    break;
                case 5:
                    chips_50_500_1000_5000 = !chips_50_500_1000_5000;
                    break;
                case 6:
                    chips_100_500_1000_5000 = !chips_100_500_1000_5000;
                    break;
                case 7:
                    chips_100_500_1000_5000_10000 = !chips_100_500_1000_5000_10000;
                    break;
                default:
                    break;
                }
                break;
            case 4:
                switch( indexPath.row ){
                case 0:
                    optionWithBreaks = !optionWithBreaks;
                    break;
                case 1:
                    optionWithAnte = !optionWithAnte;
                    break;
                default:
                    break;
                }
                break;
            default:
                break;
            }
            
            updateSearchFilter()
            
            tableViewFilter.reloadData();
            tableViewResult.reloadData();
            
            return;
        }else{
        
            var blindSetSearch : BlindSetSearch!;
            
            switch( indexPath.section ){
            case 0:
                blindSetSearch = microStackList[indexPath.row];
                break;
            case 1:
                blindSetSearch = regularStackList[indexPath.row];
                break;
            case 2:
                blindSetSearch = deepStackList[indexPath.row];
                break;
            default:
                break;
            }
            
            var blindSet : BlindSet = BlindSet.findBlindSetListByXml("preset-\(blindSetSearch.stack)-\(blindSetSearch.speed)", blindSetId: blindSetSearch.blindSetId);
            
            blindSet.isNew = true;
            
            let iDevice    = Constants.DeviceIdiom.IS_IPAD ? "iPad" : "iPhone";
            let storyboard = UIStoryboard(name: "\(iDevice)_BlindSetEditor", bundle: nil)
            
            if( Constants.DeviceIdiom.IS_IPAD ){
                
                let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
                let svc        = vc.viewControllers.first as! iPad_BlindSetEditorViewController;
                svc.sourceViewController = self.sourceViewController;
                svc.blindSet = blindSet;
                svc.tripleDismiss = true;
                
                self.presentViewController(vc, animated: true, completion: nil);
            }else{
                
                let vc         = storyboard.instantiateInitialViewController() as! iPhone_BlindSetEditorViewController;
//                let svc        = vc.viewControllers.first as! iPhone_BlindSetEditorViewController;
                vc.sourceViewController = self.sourceViewController;
                vc.blindSet = blindSet;
                vc.tripleDismiss = true;
                
                self.presentViewController(vc, animated: true, completion: nil);
            }
        }
    }
    
    func updateSearchFilter(){
        
        microStackList   = [];
        regularStackList = [];
        deepStackList    = [];
        
        for blindSetSearch in blindSetSearchList {
            
            switch( blindSetSearch.stack ){
            case "micro":
                if( stackMicro ){
                    
                    if( blindSetSearch.speed == "hyper" && speedHyper || blindSetSearch.speed == "turbo" && speedTurbo || blindSetSearch.speed == "normal" && speedNormal || blindSetSearch.speed == "slow" && speedSlow ){
                        
                        if( blindSetSearch.breaks > 0 && optionWithBreaks || blindSetSearch.breaks == 0 && !optionWithBreaks ){
                            
                            if( blindSetSearch.hasAnte == true && optionWithAnte || blindSetSearch.hasAnte == false && !optionWithAnte ){
                                
                                if( blindSetSearch.players == "2-7" && players2_7 || blindSetSearch.players == "8-13" && players8_13 || blindSetSearch.players == "14-21" && players14_21 ){
                                
                                    if( blindSetSearch.chips == "1 / 2 / 5 / 10" &&  chips_1_2_5_10 || blindSetSearch.chips == "5 / 10 / 25 / 50" &&  chips_5_10_25_50 || blindSetSearch.chips == "10 / 25 / 50 / 100" &&  chips_10_25_50_100 || blindSetSearch.chips == "25 / 50 / 100 / 500" &&  chips_25_50_100_500 || blindSetSearch.chips == "50 / 100 / 1000" &&  chips_50_100_1000 || blindSetSearch.chips == "50 / 500 / 1000 / 5000" &&  chips_50_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000" &&  chips_100_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000 / 10000" &&  chips_100_500_1000_5000_10000 ){
                                        
                                        microStackList.append(blindSetSearch);
                                    }
                                }
                            }
                        }
                    }
                }
                break;
            case "regular":
                if( stackRegular ){
                    
                    if( blindSetSearch.speed == "hyper" && speedHyper || blindSetSearch.speed == "turbo" && speedTurbo || blindSetSearch.speed == "normal" && speedNormal || blindSetSearch.speed == "slow" && speedSlow ){
                        
                        if( blindSetSearch.breaks > 0 && optionWithBreaks || blindSetSearch.breaks == 0 && !optionWithBreaks ){
                        
                            if( blindSetSearch.hasAnte == true && optionWithAnte || blindSetSearch.hasAnte == false && !optionWithAnte ){
                                
                                if( blindSetSearch.players == "2-7" && players2_7 || blindSetSearch.players == "8-13" && players8_13 || blindSetSearch.players == "14-21" && players14_21 ){
                                
                                    if( blindSetSearch.chips == "1 / 2 / 5 / 10" &&  chips_1_2_5_10 || blindSetSearch.chips == "5 / 10 / 25 / 50" &&  chips_5_10_25_50 || blindSetSearch.chips == "10 / 25 / 50 / 100" &&  chips_10_25_50_100 || blindSetSearch.chips == "25 / 50 / 100 / 500" &&  chips_25_50_100_500 || blindSetSearch.chips == "50 / 100 / 1000" &&  chips_50_100_1000 || blindSetSearch.chips == "50 / 500 / 1000 / 5000" &&  chips_50_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000" &&  chips_100_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000 / 10000" &&  chips_100_500_1000_5000_10000 ){

                                        regularStackList.append(blindSetSearch);
                                    }
                                }
                            }
                        }
                    }
                }
                break;
            case "deep":
                if( stackDeep ){
                    
                    if( blindSetSearch.speed == "hyper" && speedHyper || blindSetSearch.speed == "turbo" && speedTurbo || blindSetSearch.speed == "normal" && speedNormal || blindSetSearch.speed == "slow" && speedSlow ){
                        
                        if( blindSetSearch.breaks > 0 && optionWithBreaks || blindSetSearch.breaks == 0 && !optionWithBreaks ){
                            
                            if( blindSetSearch.hasAnte == true && optionWithAnte || blindSetSearch.hasAnte == false && !optionWithAnte ){
                                
                                if( blindSetSearch.players == "2-7" && players2_7 || blindSetSearch.players == "8-13" && players8_13 || blindSetSearch.players == "14-21" && players14_21 ){
                                
                                    if( blindSetSearch.chips == "1 / 2 / 5 / 10" &&  chips_1_2_5_10 || blindSetSearch.chips == "5 / 10 / 25 / 50" &&  chips_5_10_25_50 || blindSetSearch.chips == "10 / 25 / 50 / 100" &&  chips_10_25_50_100 || blindSetSearch.chips == "25 / 50 / 100 / 500" &&  chips_25_50_100_500 || blindSetSearch.chips == "50 / 100 / 1000" &&  chips_50_100_1000 || blindSetSearch.chips == "50 / 500 / 1000 / 5000" &&  chips_50_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000" &&  chips_100_500_1000_5000 || blindSetSearch.chips == "100 / 500 / 1000 / 5000 / 10000" &&  chips_100_500_1000_5000_10000 ){
                                        
                                        deepStackList.append(blindSetSearch);
                                    }
                                }
                            }
                        }
                    }
                }
                break;
            default:
                break;
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch( tableView.tag ){
        case 0:
            switch( section ){
            case 0:
                return NSLocalizedString("Stack", comment: "");
            case 1:
                return NSLocalizedString("Speed", comment: "");
            case 2:
                return NSLocalizedString("Players", comment: "");
            case 3:
                return NSLocalizedString("Available chips", comment: "");
            case 4:
                return NSLocalizedString("Other", comment: "");
            default:
                return "";
            }
        case 1:
            switch( section ){
            case 0:
                return NSLocalizedString("Micro stack", comment: "");
            case 1:
                return NSLocalizedString("Regular stack", comment: "");
            case 2:
                return NSLocalizedString("Deep stack", comment: "");
            default:
                return "";
            }
        default:
            return "";
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        switch( tableView.tag ){
        case 0:
            return "";
        case 1:
            switch( section ){
            case 0:
                var blindSetPlural = microStackList.count > 1 ? NSLocalizedString("blind sets", comment: "") : NSLocalizedString("blind set", comment: "");
                var foundPlural = microStackList.count == 1 ? NSLocalizedString("found", comment: "") : NSLocalizedString("foundPlural", comment: "")
                return "\(microStackList.count) \(blindSetPlural) " + foundPlural;
            case 1:
                var blindSetPlural = regularStackList.count > 1 ? NSLocalizedString("blind sets", comment: "") : NSLocalizedString("blind set", comment: "");
                var foundPlural = regularStackList.count == 1 ? NSLocalizedString("found", comment: "") : NSLocalizedString("foundPlural", comment: "");
                return "\(regularStackList.count) \(blindSetPlural) " + foundPlural;
            case 2:
                var blindSetPlural = deepStackList.count > 1 ? NSLocalizedString("blind sets", comment: "") : NSLocalizedString("blind set", comment: "");
                var foundPlural = deepStackList.count == 1 ? NSLocalizedString("found", comment: "") : NSLocalizedString("foundPlural", comment: "");
                return "\(deepStackList.count) \(blindSetPlural) " + foundPlural;
            default:
                return "";
            }
        default:
            return "";
        }
    }
    
    @IBAction func loadBlindSetEditorStoryboard(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPad_BlindSetEditor", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        
        var blindSet = BlindSet();

        if( Constants.DeviceIdiom.IS_IPAD ){
        
            let svc = vc.viewControllers.first as! iPad_BlindSetEditorViewController;
            
            svc.sourceViewController = self.sourceViewController;
            svc.blindSet = blindSet;
            svc.doubleDismiss = true;
        }else{
            
            let svc = vc.viewControllers.first as! iPhone_BlindSetEditorViewController;
            
            svc.sourceViewController = self.sourceViewController;
            svc.blindSet = blindSet;
            svc.doubleDismiss = true;
        }

        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func loadPresetFilter(sender: AnyObject) {
        
        if( self.tableViewFilter.tag == 0 ){

            self.tableViewFilter.tag = 1;
            
            (sender as! UIBarButtonItem).title = NSLocalizedString("Filter", comment: "");
        }else{
            
            self.tableViewFilter.tag = 0;
            
            (sender as! UIBarButtonItem).title = NSLocalizedString("Back", comment: "");
        }
        
        self.tableViewFilter.reloadData();
    }
}