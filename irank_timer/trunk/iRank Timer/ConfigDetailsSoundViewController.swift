//
//  ConfigDetailsSoundViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 11/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation

class ConfigDetailsSoundViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var blindChangeSoundList : NSArray!;
    var lastMinuteSoundList : NSArray!;
    var firstAnteSoundList : NSArray!;
    var audioPlayer : AVAudioPlayer!;
    var soundTimer : NSTimer!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        self.title = NSLocalizedString("Sound settings", comment: "");
        
        var filePath : String;
        
        blindChangeSoundList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("blindChangeSoundList", ofType: "plist")!);
        lastMinuteSoundList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("lastMinuteSoundList", ofType: "plist")!);
        firstAnteSoundList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("firstAnteSoundList", ofType: "plist")!);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch( section ){
        case 0:
            return blindChangeSoundList.count;
        case 1:
            return lastMinuteSoundList.count;
        case 2:
            return firstAnteSoundList.count;
        default:
            break;
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Default,
            reuseIdentifier: "SOUND_SETTING_CELL")

        var fileName : String = "";
        
        switch( indexPath.section ){
        case 0:
            fileName = (blindChangeSoundList[indexPath.row]["fileName"] as! String)
            
            cell.textLabel?.text = NSLocalizedString((blindChangeSoundList[indexPath.row]["soundName"] as! String), comment: "");
            cell.accessoryType =
                appDelegate.blindChangeSound == fileName ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
        case 1:
            fileName = (lastMinuteSoundList[indexPath.row]["fileName"] as! String)
            
            cell.textLabel?.text = NSLocalizedString((lastMinuteSoundList[indexPath.row]["soundName"] as! String), comment: "");
            cell.accessoryType =
                appDelegate.lastMinuteSound == fileName ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
        case 2:
            fileName = (firstAnteSoundList[indexPath.row]["fileName"] as! String)
            
            cell.textLabel?.text = NSLocalizedString((firstAnteSoundList[indexPath.row]["soundName"] as! String), comment: "");
            cell.accessoryType =
                appDelegate.firstAnteSound == fileName ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
            break;
        default:
            break;
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch( section ){
        case 0:
            return NSLocalizedString("ConfigDetailsSoundViewController.Blind change alert", comment: "");
        case 1:
            return NSLocalizedString("ConfigDetailsSoundViewController.Last minute alert", comment: "");
        case 2:
            return NSLocalizedString("ConfigDetailsSoundViewController.First level with ante", comment: "");
        default:
            break;
        }
        
        return nil;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch( indexPath.section ){
        case 0:
            appDelegate.blindChangeSound     = (blindChangeSoundList[indexPath.row]["fileName"] as! String);
            appDelegate.blindChangeSoundName = (blindChangeSoundList[indexPath.row]["soundName"] as! String);
            playSound(appDelegate.blindChangeSound);
            break;
        case 1:
            appDelegate.lastMinuteSound     = (lastMinuteSoundList[indexPath.row]["fileName"] as! String);
            appDelegate.lastMinuteSoundName = (lastMinuteSoundList[indexPath.row]["soundName"] as! String);
            playSound(appDelegate.lastMinuteSound);
            break;
        case 2:
            appDelegate.firstAnteSound  = (firstAnteSoundList[indexPath.row]["fileName"] as! String);
            appDelegate.notifyFirstAnte = appDelegate.firstAnteSound != "";
            playSound(appDelegate.firstAnteSound);
            break;
        default:
            break;
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
        
        self.tableView.reloadData();
    }
    
    func playSound(soundName : String){
        
        if( soundName == "" ){
            
            return;
        }
        
        if( audioPlayer != nil ){
            
            audioPlayer.stop();
        }
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers, error: nil); // Usar esse se quiser apenas baixar o som atual
//        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil); // Usar esse se quiser parar o som atual para tocar os sons do timer
        AVAudioSession.sharedInstance() .setActive(false, error: nil);
        
        var filePath : String = NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!;
        audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: filePath), error: nil);

        audioPlayer.numberOfLoops = 0;
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        if( soundTimer != nil ){
            
            soundTimer.invalidate();
        }
        
        soundTimer = NSTimer.scheduledTimerWithTimeInterval(audioPlayer.duration+2, target: self, selector: Selector("stopSound"), userInfo: nil, repeats: false);
    }
    
    func stopSound(){
        
        if( audioPlayer != nil ){
            
            audioPlayer.stop();
            AVAudioSession.sharedInstance().setActive(false, withOptions: AVAudioSessionSetActiveOptions.OptionNotifyOthersOnDeactivation, error: nil);
        }
    }
}