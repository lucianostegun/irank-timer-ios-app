//
//  ConfigDetailsBackgroundViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 13/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class ConfigDetailsBackgroundViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate        = UIApplication.sharedApplication().delegate as! AppDelegate;
    let backgrounds        = 11;
    var backgroundModeList = ["dynamic", "static"];
    var imagePicker        = UIImagePickerController()
    var customImage : UIImage!;
    var useCustomImage : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = NSLocalizedString("Background mode settings", comment: "");
        useCustomImage = appDelegate.backgroundImageName == "custom";
        customImage    = appDelegate.backgroundCustomImage;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;//appDelegate.hideStatusBar;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return appDelegate.backgroundMode == "dynamic" ? 1 : 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch( section ){
        case 0:
            return backgroundModeList.count;
        default:
            return backgrounds;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch( indexPath.section ){
        case 0:
            var cell = UITableViewCell(
                style: UITableViewCellStyle.Default,
                reuseIdentifier: "BACKGROUND_MODE_CELL")

            cell.textLabel?.text = backgroundModeList[indexPath.row] == "static" ? NSLocalizedString("Static", comment: "") : NSLocalizedString("Dynamic", comment: "");
            cell.accessoryType   = appDelegate.backgroundMode == backgroundModeList[indexPath.row] ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;

            return cell;
        default:
            
            var cell = self.tableView.dequeueReusableCellWithIdentifier("BACKGROUND_IMAGE_CELL", forIndexPath: indexPath) as! BackgroundCell;
            
            if( indexPath.row+1 < backgrounds ){
             
                if( indexPath.row+1 == 10 ){
                 
                    cell.lblBackgroundName.text   = NSLocalizedString("Classic background", comment: "");
                }else{
                    
                    cell.lblBackgroundName.text   = NSLocalizedString("Background #", comment: "") + "\(indexPath.row+1)";
                }
                
                if( appDelegate.backgroundMode == "static" ){

                    cell.imgBackgroundImage.image = UIImage(named: "background-\(indexPath.row+1)-thumb.jpg");
                    cell.accessoryType = appDelegate.backgroundImageName == "background-\(indexPath.row+1).jpg" && !useCustomImage ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
                }
            }else{
                
                cell.lblBackgroundName.text = NSLocalizedString("Select image from photo library", comment: "");
                
                if( customImage != nil ){
                    
                    cell.imgBackgroundImage.image = customImage;
                }
                
                cell.accessoryType = useCustomImage && customImage != nil ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None;
            }
            
            return cell;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch( indexPath.section ){
        case 0:
            return 44;
        default:
            return 100;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch( indexPath.section ){
        case 0:
            appDelegate.backgroundMode = backgroundModeList[indexPath.row];
            break;
        default:
            if( indexPath.row+1 < backgrounds ){
            
                appDelegate.backgroundImageName = "background-\(indexPath.row+1).jpg";
                useCustomImage = false;
            }else{
                
                if( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) ){
                    
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            break;
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeBackgroundMode", object:nil);
        NSNotificationCenter.defaultCenter().postNotificationName("changeSubOptionValue", object:nil);
        
        self.tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch( section ){
        case 0:
            return NSLocalizedString("Background mode", comment: "");
        case 1:
            return NSLocalizedString("Background Image", comment: "");
        default:
            break;
        }
        
        return nil;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        customImage = image;
        
        useCustomImage = true;
        
        appDelegate.backgroundImageName = "custom";
        appDelegate.backgroundCustomImage = image.copy() as! UIImage;
        
        NSNotificationCenter.defaultCenter().postNotificationName("changeBackgroundMode", object:nil);
        
        self.tableView.reloadData();
    }
}