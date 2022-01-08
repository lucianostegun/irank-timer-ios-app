//
//  BlindSetEditorMasterViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BlindSetEditorMasterViewController : UITableViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    var blindSet : BlindSet!;
    @IBOutlet weak var txtBlindSetName: UITextField!
    @IBOutlet weak var cellPlaySound: UITableViewCell!
    @IBOutlet weak var cellLastMinuteAlert: UITableViewCell!
    @IBOutlet weak var cellBlindChangeAlert: UITableViewCell!
    @IBOutlet weak var btnSaveBlindSet: UIBarButtonItem!
    @IBOutlet weak var btnDuplicateBlindSet: UIBarButtonItem!
    
    @IBAction func dismissViewController(sender: AnyObject) {       
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            blindSet = (parentViewController?.parentViewController as! iPad_BlindSetEditorViewController).blindSet;
        }else{
            
            blindSet = (parentViewController as! iPhone_BlindSetEditorViewController).blindSet;
        }
        
        btnDuplicateBlindSet.enabled = !blindSet.isNew;
        
        fillFields();
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }else{
            
            return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    func fillFields(){
        
        txtBlindSetName.text = blindSet.blindSetName;
        self.tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if( indexPath.section == 1 ){
            
            switch( indexPath.row ){
            case 0:
                
                cell.accessoryType = self.getAccessoryType(blindSet.playSound);
                break;
            case 1:
                
                cell.accessoryType = self.getAccessoryType(blindSet.lastMinuteAlert);
                break;
            case 2:
                
                cell.accessoryType = self.getAccessoryType(blindSet.blindChangeAlert);
                break;
            default:
                break;
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if( indexPath.section == 1 ){
            
            switch( indexPath.row ){
            case 0:
                
                blindSet.playSound = !blindSet.playSound;
                break;
            case 1:
                
                blindSet.lastMinuteAlert = !blindSet.lastMinuteAlert;
                break;
            case 2:
                
                blindSet.blindChangeAlert = !blindSet.blindChangeAlert;
                break;
            default:
                break;
            }
        }
        
        tableView.reloadData();
    }
    
    func getAccessoryType(value : Bool) -> UITableViewCellAccessoryType {
        
        if( value == true ){
            
            return UITableViewCellAccessoryType.Checkmark;
        };
        
        return UITableViewCellAccessoryType.None;
    }
    
    func validateBlindSet(){
        
        btnSaveBlindSet.enabled = (txtBlindSetName.text != "");
    }
    
    @IBAction func editingChangeBlindSetName(sender: AnyObject) {
        
        validateBlindSet();
    }
    
    @IBAction func saveBlindSet(sender: AnyObject) {
        
        if( blindSet.isNew && Constants.LITE_VERSION ){
            
            appDelegate.checkLiteVersion(NSLocalizedString("This version of iRank Timer only allow 3 blind sets. Would like to upgrade and create unlimited blind sets?", comment: ""))
            return;
        }
        
        blindSet.blindSetName = txtBlindSetName.text;
        
        if( Constants.DeviceIdiom.IS_IPAD ){

            var blindSetEditorViewController : iPad_BlindSetEditorViewController = parentViewController?.parentViewController as! iPad_BlindSetEditorViewController;
            var detailsViewController = (blindSetEditorViewController.viewControllers.last as! UINavigationController).viewControllers.first as! BlindSetEditorDetailsViewController;
            blindSet.blindLevelList   = detailsViewController.blindSet.blindLevelList;
            
            blindSet.updateMetadata();
            
            blindSetEditorViewController.updateSourceViewController(blindSet);
            
            if( blindSetEditorViewController.doubleDismiss ){
                
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
            }else if( blindSetEditorViewController.tripleDismiss ){
                
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
            }else{
                
                self.dismissViewController(sender);
            }
        }else{
            
            var blindSetEditorViewController : iPhone_BlindSetEditorViewController = parentViewController as! iPhone_BlindSetEditorViewController;
            
            blindSetEditorViewController.updateSourceViewController(blindSet);
            
            blindSet.updateMetadata();
    
            println("blindSet.isNew (1): \(blindSet.isNew)");
            
            if( blindSetEditorViewController.doubleDismiss ){
                
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
            }else if( blindSetEditorViewController.tripleDismiss ){
                
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
            }else{
                
                self.dismissViewController(sender);
            }
        }
    }
    
    @IBAction func duplicateBlindSet(sender: AnyObject) {
        
        blindSet.blindSetName = blindSet.blindSetName+" "+NSLocalizedString("copy", comment: "");
        txtBlindSetName.text  = blindSet.blindSetName;
        blindSet.isNew = true;
        
        btnDuplicateBlindSet.enabled = false;
    }
}