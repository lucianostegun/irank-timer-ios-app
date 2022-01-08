//
//  BlindSetEditorDetailsViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BlindSetEditorDetailsViewController : UITableViewController {
    
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var imgTableViewHeaderBorder: UIImageView!
    @IBOutlet weak var lblLevelNumber: UILabel!
    @IBOutlet weak var lblSmallBlind: UILabel!
    @IBOutlet weak var lblBigBlind: UILabel!
    @IBOutlet weak var lblAnte: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblElapsedTime: UILabel!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    var blindSet : BlindSet! = BlindSet();
    var currentLevelIndex : Int!;
    
    override func viewDidLoad() {

        super.viewDidLoad();
        
        if( appDelegate.IS_IPAD ){
            
            blindSet = (parentViewController?.parentViewController as! iPad_BlindSetEditorViewController).blindSet;
        }else{
            
            blindSet = (parentViewController as! iPhone_BlindSetEditorViewController).blindSet;
            
            
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications();
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDeviceOrientationDidChange:"), name: UIDeviceOrientationDidChangeNotification, object: nil);
        }

        self.tableView.setEditing(true, animated: false);
        

        var intrinsicSize : CGSize = self.tableViewHeader.intrinsicContentSize();
        var height : CGFloat = (intrinsicSize.height > 0) ? intrinsicSize.height : 25; // replace with some fixed value as needed
        var width : CGFloat = CGRectGetWidth(self.view.bounds);
        var frame : CGRect = CGRectMake(0, 0, width, height);
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(height, 0, 0, 0);
        var wrapperView : UIView = self.tableView.subviews[0] as! UIView; // this is a bit of a hack solution, but should always pull out the UITableViewWrapperView
        self.tableView.insertSubview(self.tableViewHeader, aboveSubview:wrapperView);
        
        switchOptionalLabels()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var headerFrame : CGRect = self.tableViewHeader.frame;
        let yOffset : CGFloat = scrollView.contentOffset.y;
        headerFrame.origin.y = max(0, yOffset);
        tableViewHeader.frame = headerFrame;
        // If the user is pulling down on the top of the scroll view, adjust the scroll indicator appropriately
        
        let height : CGFloat = CGRectGetHeight(headerFrame);
        
        if( yOffset < 0 ){
            
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(abs(yOffset) + height, 0, 0, 0);
        }
        
        imgTableViewHeaderBorder.hidden = (yOffset <= 0);
        imgTableViewHeaderBorder.frame.origin.y = 25.5;
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if( appDelegate.IS_IPHONE ){
            
            (parentViewController as! iPhone_BlindSetEditorViewController).blindSet.blindLevelList = blindSet.blindLevelList;
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        if( appDelegate.IS_IPAD ){
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }else{
            
            return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        }
    }
    
    func onDeviceOrientationDidChange(notifiction : NSNotification){
        
        switchOptionalLabels()
        
        tableView.reloadData();
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return blindSet.blindLevelList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BLIND_LEVEL_CELL", forIndexPath: indexPath) as! BlindLevelCell;

        var blindLevel : BlindLevel = blindSet.blindLevelList[indexPath.row];
        
        if( blindLevel.isBreak == true ){
            
            cell.lblLevelNumber.text = "";
            cell.lblSmallBlind.text  = NSLocalizedString("BREAK", comment: "");
            cell.lblBigBlind.text    = "";
            cell.lblAnte.text        = "";

        }else{
            
            cell.lblLevelNumber.text = "\(blindLevel.levelNumber)";
            cell.lblSmallBlind.text  = "\(blindLevel.smallBlind)";
            cell.lblBigBlind.text    = "\(blindLevel.bigBlind)";
            cell.lblAnte.text        = "\(blindLevel.ante)";
        }
        
        if( appDelegate.IS_IPAD ){
            
            cell.lblDuration.text    = Util.formatTimeString(Float(blindLevel.duration)) as String;
        }else{
            
            cell.lblDuration.text    = "\(blindLevel.duration) "+NSLocalizedString("min", comment: "");
        }
        cell.lblElapsedTime.text = blindLevel.elapsedTime;
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var blindLevel : BlindLevel = blindSet.blindLevelList[indexPath.row];
        var cell = cell as! BlindLevelCell;
        
        if( appDelegate.IS_IPHONE ){
            
            cell.lblDuration.hidden    = ( (appDelegate.IS_IPHONE_4_OR_LESS || appDelegate.IS_IPHONE_5) && appDelegate.isPortrait() );
            cell.lblElapsedTime.hidden = appDelegate.isPortrait();
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        if( appDelegate.IS_IPHONE ){
//
//            if( appDelegate.isPortrait() ){
//                
//                if( appDelegate.IS_IPHONE_4_OR_LESS || appDelegate.IS_IPHONE_5 ){
//                    
//                    return NSLocalizedString("blindSetList.tableHeader-iPhone[4-5]-portrait", comment: "");
//                }else{
//                    
//                    return NSLocalizedString("blindSetList.tableHeader-iPhone-portrait", comment: "");
//                }
//            }else{
//                
//                return NSLocalizedString("blindSetList.tableHeader-iPhone-landscape", comment: "");
//            }
//        }
//        
//        return NSLocalizedString("blindSetList.tableHeader", comment: "");
//    }
//
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        return tableViewHeader;
//        let width : CGFloat = tableView.bounds.size.width;
//        let height : CGFloat = 25;
//        var headerLbl : UILabel = UILabel();
//        headerLbl.frame = CGRectMake(0, 65, width, height);
//        headerLbl.text = "Table Header";
//        headerLbl.font = UIFont(name: "System", size: 20);
//        headerLbl.backgroundColor = UIColor.darkGrayColor();
//        headerLbl.textAlignment = NSTextAlignment.Left;
//
//        return headerLbl;
//    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var pluralLevels = blindSet.levels == 1 ? NSLocalizedString("level", comment: "") : NSLocalizedString("levels", comment: "");
        var pluralBreaks = blindSet.breaks == 1 ? "\(blindSet.breaks) " + NSLocalizedString("break", comment: "") : "\(blindSet.breaks) " + NSLocalizedString("breaks", comment: "");
        
        var breaks : String = blindSet.breaks == 0 ? NSLocalizedString("No breaks", comment: "") : pluralBreaks;
        
        return "\(blindSet.levels) \(pluralLevels) / \(breaks) / \(blindSet.duration) " + NSLocalizedString("total", comment: "");
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return blindSet.blindLevelList.count > 1;
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        // Get pointer to object being moved
        var blindLevel = blindSet.blindLevelList[sourceIndexPath.row];
        
        // Remove p from our array, it is automatically sent release
        blindSet.blindLevelList.removeAtIndex(sourceIndexPath.row); // Retain count of p is now 1
        
        // Re-inser p into array at new location, it is automatically retained
        blindSet.blindLevelList.insert(blindLevel, atIndex: destinationIndexPath.row);
        blindSet.updateMetadata();
        self.tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.Delete;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        currentLevelIndex = indexPath.row;
        self.performSegueWithIdentifier("EditBlindLevelSegue", sender: nil);
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if( editingStyle == UITableViewCellEditingStyle.Delete ){
            
            blindSet.blindLevelList.removeAtIndex(indexPath.row);
            self.tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade);
            
            blindSet.updateMetadata();
        }
        
        self.tableView.reloadData();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "CreateNewBlindLevelSegue" || segue.identifier == "EditBlindLevelSegue" ){

            var vc = (segue.destinationViewController.viewControllers as Array).first as! BlindLevelEditorViewController;
            
            vc.blindSet               = blindSet.copy() as! BlindSet;
            vc.previousViewController = self;
            
            if( segue.identifier == "CreateNewBlindLevelSegue" ){
                
                vc.currentLevelIndex = -1;
            }else{
                
                vc.currentLevelIndex = currentLevelIndex;
            }
        }
    }
    
    func switchOptionalLabels(){
        
        if( appDelegate.IS_IPHONE ){
            
            lblDuration.hidden    = ( (appDelegate.IS_IPHONE_4_OR_LESS || appDelegate.IS_IPHONE_5) && appDelegate.isPortrait() );
            lblElapsedTime.hidden = appDelegate.isPortrait();
        }
    }
}