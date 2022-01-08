//
//  iPhone_TimerMenuViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 01/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class iPhone_TimerMenuViewController : UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet var btnResetTimer: UIBarButtonItem!
    @IBOutlet var btnEdit: UIBarButtonItem!
    
    var timerViewController : iPhone_TimerViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        btnEdit.title = NSLocalizedString("Edit", comment: "");
        btnEdit.style = UIBarButtonItemStyle.Bordered;
        
        self.tableView.backgroundColor = UIColor.clearColor();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.navigationBarHidden = false;
        self.navigationController?.toolbarHidden = false;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timerViewController.blindSetList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(
            style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: nil)
        
        var blindSet : BlindSet = timerViewController.blindSetList[indexPath.row];
        
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
        
        if( indexPath.row == timerViewController.currentBlindSetIndex ){
            
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None);
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        timerViewController.currentBlindSetIndex = indexPath.row;
        timerViewController.blindSet = timerViewController.blindSetList[timerViewController.currentBlindSetIndex];
        timerViewController.resetTimer(true, force: false);
        
        self.dismissViewControllerAnimated(true, completion: nil);
        self.navigationController?.presentedViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return (timerViewController.blindSetList.count > 1);
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if( editingStyle == UITableViewCellEditingStyle.Delete ){
            
            timerViewController.appDelegate.needBackup = true;
            
            timerViewController.blindSetList.removeAtIndex(indexPath.row);
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade);
            
            var resetTimer = (indexPath.row == timerViewController.currentBlindSetIndex);
            
            // Se o que estiver selecionado estiver depois do que está sendo excluído, mantém ele como selecionado baixando 1 índice
            if( timerViewController.currentBlindSetIndex >= indexPath.row ){
                
                timerViewController.currentBlindSetIndex = timerViewController.currentBlindSetIndex-1;
            }
            
            if( timerViewController.currentBlindSetIndex < 0 ){
                
                timerViewController.currentBlindSetIndex = 0;
            }
            
            if( resetTimer ){
                
                timerViewController.blindSet = timerViewController.blindSetList[timerViewController.currentBlindSetIndex];
                timerViewController.resetTimer(true, force: true);
            }
        }
        
        self.tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "iPhone_BlindSetEditor", bundle: nil)
        let vc         = storyboard.instantiateInitialViewController() as! iPhone_BlindSetEditorViewController;
        
        timerViewController.editingBlindSetIndex = indexPath.row;
        
        vc.blindSet = timerViewController.blindSetList[timerViewController.editingBlindSetIndex].copy() as! BlindSet;
        vc.sourceViewController = timerViewController;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    func selectCurrentLevel(){
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: timerViewController.currentBlindSetIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None);
    }
    
    @IBAction func switchEditingBlindSetList(sender: AnyObject) {
        
        var btnEdit = sender as! UIBarButtonItem;
        
        if( btnEdit.tag == 0 ){
            
            btnEdit.tag   = 1;
            btnEdit.title = NSLocalizedString("TimerViewController.Done", comment: "TimerViewController");
            btnEdit.style = UIBarButtonItemStyle.Done;
            self.tableView.setEditing(true, animated: true);
        }else{
            
            btnEdit.tag   = 0;
            btnEdit.title = NSLocalizedString("Edit", comment: "");
            btnEdit.style = UIBarButtonItemStyle.Bordered;
            self.tableView.setEditing(false, animated: true);
        }
        
        selectCurrentLevel();
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        
        timerViewController.resetTimer(true, force: false);
    }
    
    @IBAction func loadSettings(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPhone_Config", bundle: nil);
        let vc         = storyboard.instantiateInitialViewController() as! UINavigationController;
        
        self.presentViewController(vc, animated: true, completion: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(timerViewController, selector: Selector("changeBackgroundMode"), name: "changeBackgroundMode", object: nil);
    }
    
    @IBAction func loadCreateMenu(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "iPhone_CreateMenu", bundle: nil);
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController;
        
//        if( appDelegate.isLandscape() ){
//        
//            println("iPhone_CreateMenuLandscape")
//            vc.viewControllers = [storyboard.instantiateViewControllerWithIdentifier("iPhone_CreateMenuLandscape")];
//        }else{
//            
//            println("iPhone_CreateMenuPortrait")
//            vc.viewControllers = [storyboard.instantiateViewControllerWithIdentifier("iPhone_CreateMenuPortrait")];
//        }
        
        (vc.viewControllers.first as! iPhone_CreateMenuViewController).sourceViewController = timerViewController;
        
        self.presentViewController(vc, animated: true, completion: nil);
    }
}