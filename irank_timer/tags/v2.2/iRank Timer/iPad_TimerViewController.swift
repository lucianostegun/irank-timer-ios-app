//
//  iPad_TimerViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 28/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPad_TimerViewController: TimerViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainView : UIView!;
    @IBOutlet var menuView : UIView!;
    
    @IBOutlet var btnResetTimer: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnEdit: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.backgroundColor = UIColor.clearColor();
        menuView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75);
        moveMainViewOnEdit = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated);
        
        self.menuView.frame = CGRectMake((self.menuView.frame.size.width * -1), 0, self.menuView.frame.size.width, self.menuView.frame.size.height);

        self.menuView.hidden = false;
        
        if( Constants.LITE_VERSION ){
            
            iAdBannerView.frame  = CGRectMake(0, 702, 1024, 768);
            iAdBannerView.contentMode = UIViewContentMode.Center;
            self.view.addSubview(iAdBannerView);
            
            lblSmallBlind.first!.frame.origin.y          = lblSmallBlind.first!.frame.origin.y-66;
            lblBigBlind.first!.frame.origin.y            = lblBigBlind.first!.frame.origin.y-66;
            lblAnte.first!.frame.origin.y                = lblAnte.first!.frame.origin.y-66;
            lblNextSmallBlind.first!.frame.origin.y      = lblNextSmallBlind.first!.frame.origin.y-66;
            lblNextBigBlind.first!.frame.origin.y        = lblNextBigBlind.first!.frame.origin.y-66;
            lblNextAnte.first!.frame.origin.y            = lblNextAnte.first!.frame.origin.y-66;
            lblElapsedTime.first!.frame.origin.y         = lblElapsedTime.first!.frame.origin.y-66;
            lblLevel.first!.frame.origin.y               = lblLevel.first!.frame.origin.y-66;
            lblNextBreak.first!.frame.origin.y           = lblNextBreak.first!.frame.origin.y-66;
            lblNextLevel.first!.frame.origin.y           = lblNextLevel.first!.frame.origin.y-66;
            imgHorizontalLineLeft.first!.frame.origin.y  = imgHorizontalLineLeft.first!.frame.origin.y-66;
            imgHorizontalLineRight.first!.frame.origin.y = imgHorizontalLineRight.first!.frame.origin.y-66;
            lblSmallBlindLabel.first!.frame.origin.y     = lblSmallBlindLabel.first!.frame.origin.y-66;
            lblBigBlindLabel.first!.frame.origin.y       = lblBigBlindLabel.first!.frame.origin.y-66;
            lblAnteLabel.first!.frame.origin.y           = lblAnteLabel.first!.frame.origin.y-66;
            lblElapsedTimeLabel.first!.frame.origin.y    = lblElapsedTimeLabel.first!.frame.origin.y-66;
            lblLevelLabel.first!.frame.origin.y          = lblLevelLabel.first!.frame.origin.y-66;
            lblNextBreakLabel.first!.frame.origin.y      = lblNextBreakLabel.first!.frame.origin.y-66;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blindSetList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: nil)
        
        var blindSet : BlindSet = blindSetList[indexPath.row];
        
        var pluralBreaks = blindSet.breaks == 1 ? NSLocalizedString("break", comment: "") : NSLocalizedString("breaks", comment: "");
        
        var breaks : String = blindSet.breaks == 0 ? NSLocalizedString("No breaks", comment: "") : "\(blindSet.breaks) \(pluralBreaks)";
        var levels : String = blindSet.levels == 1 ? NSLocalizedString("level", comment: "") : NSLocalizedString("levels", comment: "")
        cell.textLabel?.text       = blindSet.blindSetName;
        cell.detailTextLabel?.text = "\(blindSet.levels) \(levels), \(breaks), \(blindSet.duration) "+NSLocalizedString("total", comment: "");
        
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton;
        cell.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.85);
        
        cell.textLabel?.textColor       = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        
        cell.textLabel?.highlightedTextColor       = UIColor.blackColor();
        cell.detailTextLabel?.highlightedTextColor = UIColor.blackColor();
        
        if( indexPath.row == currentBlindSetIndex ){
            
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None);
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        currentBlindSetIndex = indexPath.row;
        blindSet = blindSetList[currentBlindSetIndex];
        resetTimer(true, force: false);
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return (blindSetList.count > 1);
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if( editingStyle == UITableViewCellEditingStyle.Delete ){
            
            appDelegate.needBackup = true;
            
            blindSetList.removeAtIndex(indexPath.row);
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath) as! [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade);
            
            var resetTimer = (indexPath.row == currentBlindSetIndex);
            
            // Se o que estiver selecionado estiver depois do que está sendo excluído, mantém ele como selecionado baixando 1 índice
            if( currentBlindSetIndex >= indexPath.row ){
                
                currentBlindSetIndex = currentBlindSetIndex-1;
            }
            
            if( currentBlindSetIndex < 0 ){
                
                currentBlindSetIndex = 0;
            }
            
            if( resetTimer ){
                
                blindSet = blindSetList[currentBlindSetIndex];
                self.resetTimer(true, force: true);
            }
        }
        
        self.tableView.reloadData();
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "iPad_BlindSetEditor", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        let svc        = vc.viewControllers.first as! iPad_BlindSetEditorViewController;
        
        editingBlindSetIndex = indexPath.row;
        
        svc.blindSet = blindSetList[editingBlindSetIndex].copy() as! BlindSet;
        svc.sourceViewController = self;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func switchEditingBlindSetList(sender: AnyObject) {
        
        if( !appDelegate.checkLiteVersion() ){
            
            return;
        }
        
        var btnEdit = sender as! UIBarButtonItem;
        
        if( btnEdit.tag == 0 ){
            
            btnEdit.tag   = 1;
            btnEdit.title = NSLocalizedString("TimerViewController.Done", comment: "TimerViewController");
            btnEdit.style = UIBarButtonItemStyle.Done;
            self.tableView.setEditing(true, animated: true);
        }else{
            
            btnEdit.tag   = 0;
            btnEdit.title = NSLocalizedString("Edit", comment: "");
            btnEdit.style = UIBarButtonItemStyle.Plain;
            self.tableView.setEditing(false, animated: true);
        }
        
        selectCurrentLevel();
    }
    
    @IBAction func loadBlindSetCreateMenuStoryboard(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPad_CreateMenu", bundle: nil);
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        let cmvc       = vc.viewControllers.first as! CreateMenuViewController;
        
        editingBlindSetIndex = -1;
        
        cmvc.sourceViewController = self;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        
        if( isRunning ){
            
            pauseTimer(true);
        }
        
        resetTimer(true, force: false);
    }
    
    override func updateBlindSet(newBlindSet : BlindSet){
        
        super.updateBlindSet(newBlindSet)
        
        self.tableView.reloadData();
        self.btnEdit.tag   = 0;
        self.btnEdit.title = NSLocalizedString("Edit", comment: "");
        self.tableView.setEditing(false, animated: true);
        
    }
    
    func selectCurrentLevel(){
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: currentBlindSetIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None);
    }
    
    override func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        super.alertView(alertView, clickedButtonAtIndex: buttonIndex);
        
        if( buttonIndex == 0 ){
            
            return;
        }
        
        if( blindSetList != nil ){
            
            self.tableView.reloadData();
        }
    }
    
    @IBAction func loadSettings(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPad_Config", bundle: nil);
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        
        self.presentViewController(vc, animated: true, completion: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeBackgroundMode"), name: "changeBackgroundMode", object: nil);
    }
    
    @IBAction func swipeControlsRight(sender: AnyObject) {
        
        UIView.animateWithDuration(0.25, animations: {
            
            if( self.moveMainViewOnEdit ){
                
                self.mainView.frame = CGRectMake(self.menuView.frame.size.width, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
            }
            
            if( !self.enableBackgroundTransition ){
                
                self.imgBackground2.first!.frame = CGRectMake(0, -100, self.imgBackground2.first!.frame.size.width, self.imgBackground2.first!.frame.size.height);
            }
            
            self.menuView.frame = CGRectMake(0, 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            }, completion: nil);
        
        appDelegate.firstExecution = false;
    }
    
    @IBAction func swipeControlsLeft(sender: AnyObject) {
        
        UIView.animateWithDuration(0.25, animations: {
            
            if( self.moveMainViewOnEdit ){
                
                self.mainView.frame = CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
            }
            
            if( !self.enableBackgroundTransition ){
                
                self.imgBackground2.first!.frame = CGRectMake(-100, -100, self.imgBackground2.first!.frame.size.width, self.imgBackground2.first!.frame.size.height);
            }
            
            self.menuView.frame = CGRectMake((self.menuView.frame.size.width * -1), 0, self.menuView.frame.size.width, self.menuView.frame.size.height);
            }, completion: nil);
    }
}
