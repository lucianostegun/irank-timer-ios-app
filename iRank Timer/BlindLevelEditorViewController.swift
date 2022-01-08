//
//  BlindLevelEditorViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BlindLevelEditorViewController : UITableViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    var blindSet : BlindSet!;
    var previousViewController : BlindSetEditorDetailsViewController!;
    var currentLevelIndex : Int!;
    var hasChangeAnything : Bool = false;
    var lastFirstResponder : AnyObject!;
    
    @IBOutlet weak var lblSuggestion: UILabel!
    @IBOutlet weak var swcIsBreak: UISwitch!
    @IBOutlet weak var txtSmallBlind: UITextField!
    @IBOutlet weak var txtBigBlind: UITextField!
    @IBOutlet weak var txtAnte: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnSuggestion1: UIButton!
    @IBOutlet weak var btnSuggestion2: UIButton!
    @IBOutlet weak var btnSuggestion3: UIButton!
    @IBOutlet weak var btnSuggestion4: UIButton!
    @IBOutlet weak var btnPreviousLevel: UIBarButtonItem!
    @IBOutlet weak var btnNextLevel: UIBarButtonItem!
    @IBOutlet weak var btnDeleteLevel: UIButton!
    @IBOutlet weak var btnReplicateDuration: UIButton!
    @IBOutlet weak var imgReplicatedDuration: UIImageView!
    
    @IBOutlet weak var cellSmallBlind: UITableViewCell!
    @IBOutlet weak var cellBigBlind: UITableViewCell!
    @IBOutlet weak var cellAnte: UITableViewCell!
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        if( currentLevelIndex == -1 ){
        
            addNewLevel();
        }
        
        loadBlindLevelFields();
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
        }else{
            
            return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        }
    }
    
    func addNewLevel(){
        
        var duration = 0;
        var ante     = 0;
        
        if( blindSet.blindLevelList.count > 0 ){
            
            duration = blindSet.blindLevelList[blindSet.blindLevelList.count-1].duration;
            ante     = blindSet.blindLevelList[blindSet.blindLevelList.count-1].ante;
        }
        
        var blindLevel : BlindLevel = BlindLevel();
        blindLevel.levelIndex = blindSet.blindLevelList.count;
        blindLevel.levelNumber = blindSet.levels+1;
        blindLevel.smallBlind = 0;
        blindLevel.bigBlind = 0;
        blindLevel.ante = ante;
        blindLevel.duration = duration;
        blindLevel.isBreak = false;
        blindLevel.elapsedTime = Util.formatTimeString(Float(blindSet.getElapsedSeconds(blindLevel.levelIndex)+(blindLevel.duration))) as! String;
        
        self.blindSet.blindLevelList.append(blindLevel);
        self.blindSet.levels = self.blindSet.levels+1;
        
        currentLevelIndex = self.blindSet.blindLevelList.count-1;
    }
    
    func loadBlindLevelFields(){
        
        var switchBreak : Bool = false;
        var wasBreak : Bool = swcIsBreak.on;
        
        swcIsBreak.on      = blindSet.blindLevelList[currentLevelIndex].isBreak;
        txtSmallBlind.text = "\(blindSet.blindLevelList[currentLevelIndex].smallBlind)";
        txtBigBlind.text   = "\(blindSet.blindLevelList[currentLevelIndex].bigBlind)";
        txtAnte.text       = "\(blindSet.blindLevelList[currentLevelIndex].ante)";
        txtDuration.text   = "\(blindSet.blindLevelList[currentLevelIndex].duration/60)";
        
        switchBreak = wasBreak != swcIsBreak.on;
        
        btnPreviousLevel.enabled = (currentLevelIndex > 1);
        if( currentLevelIndex < blindSet.blindLevelList.count-1 ){
            
            btnNextLevel.title = NSLocalizedString("Next level", comment: "");
        }else{
            
            btnNextLevel.title = NSLocalizedString("New level", comment: "")
        }
        
        lblSuggestion.hidden = true;
        
        validateBlindLevel();
        loadSuggestions();
        
        self.title = blindSet.blindLevelList[currentLevelIndex].isBreak == true ? NSLocalizedString("BREAK", comment: "") : NSLocalizedString("LEVEL #", comment: "") + "\(blindSet.blindLevelList[currentLevelIndex].levelNumber)";
        
        tableView.footerViewForSection(0)?.textLabel.text = NSLocalizedString("Elapsed time:", comment: "") + " \(blindSet.blindLevelList[currentLevelIndex].elapsedTime)";
        
        cellSmallBlind.hidden = swcIsBreak.on;
        cellBigBlind.hidden = swcIsBreak.on;
        cellAnte.hidden = swcIsBreak.on;
        
        imgReplicatedDuration.hidden = true;
        
        tableView.reloadData();
        
        if( switchBreak ){
            
            if( swcIsBreak.on ){
                
                txtDuration.becomeFirstResponder();
                
                lastFirstResponder = txtDuration;
            }else{
             
                if( Constants.DeviceIdiom.IS_IPAD ){
                    
                    if( lastFirstResponder == nil ){
                        
                        txtDuration.becomeFirstResponder();
                    }else{
                        
                        lastFirstResponder.becomeFirstResponder();
                    }
                }
            }
        }else{
            
            if( lastFirstResponder != nil ){
                
                lastFirstResponder.becomeFirstResponder()
            }
        }
    }
    
    func loadSuggestions(){
        
        var smallBlind_1 = 0;
        var smallBlind_2 = 0;
        
        var has2PreviousLevel = false;
        var has1PreviousLevel = false;
        
        for var i = currentLevelIndex-1; i >= 0 ; --i {
            
            var isBreak = blindSet.blindLevelList[i].isBreak;
            
            if( isBreak == true ){
                
                continue;
            }
            
            if( !has1PreviousLevel ){
                
                has1PreviousLevel = true;
                smallBlind_1      = blindSet.blindLevelList[i].smallBlind;
                continue;
            }
            
            if( !has2PreviousLevel ){
                
                has2PreviousLevel = true;
                smallBlind_2      = blindSet.blindLevelList[i].smallBlind;
                break;
            }
        }
        
        var options : Array<Int> = [];
        
        if( has1PreviousLevel ){
            
            var difference = 0;
            
            if( has2PreviousLevel ){
                
                difference = smallBlind_1-smallBlind_2;
                
                if( difference > 0 ){
                    
                    options.append(smallBlind_1+difference);
                }
            }
            
            if( difference > 0 ){
                
                options.append(smallBlind_1+(difference*2));
                options.append(smallBlind_1+(difference*3));
            }
            
            // Esses só serão usados quando for o segundo level
            options.append(smallBlind_1*2);
            options.append(smallBlind_1*3);
            options.append(smallBlind_1*4);
            
            options.sort({ (i1, i2) -> Bool in
                return i1 < i2;
            });
            
            options = Util.uniq(options);
        }
        
        btnSuggestion1.hidden = !((options.count >= 1) && (txtSmallBlind.text == "" || txtSmallBlind.text == "0"));
        btnSuggestion2.hidden = !((options.count >= 2) && (txtSmallBlind.text == "" || txtSmallBlind.text == "0"));
        btnSuggestion3.hidden = !((options.count >= 3) && (txtSmallBlind.text == "" || txtSmallBlind.text == "0"));
        btnSuggestion4.hidden = !((options.count >= 4) && (txtSmallBlind.text == "" || txtSmallBlind.text == "0"));
        
        var smallBlind : String = "";
        var bigBlind : String   = "";
        
        lblSuggestion.hidden = (btnSuggestion1.hidden && btnSuggestion2.hidden && btnSuggestion3.hidden && btnSuggestion4.hidden)
        
        if( options.count >= 1 ){
            
            smallBlind = "\(Util.getShortBlindNumber(options[0], force: true))";
            bigBlind   = "\(Util.getShortBlindNumber(options[0]*2, force: true))";
            
            btnSuggestion1.tag = options[0];
            btnSuggestion1.setTitle("\(smallBlind)/\(bigBlind)", forState: UIControlState.Normal);
        }
        
        if( options.count >= 2 ){
            
            smallBlind = "\(Util.getShortBlindNumber(options[1], force: true))";
            bigBlind   = "\(Util.getShortBlindNumber(options[1]*2, force: true))";
            
            btnSuggestion2.tag = options[1];
            btnSuggestion2.setTitle("\(smallBlind)/\(bigBlind)", forState: UIControlState.Normal);
        }
        
        if( options.count >= 3 ){
            
            smallBlind = "\(Util.getShortBlindNumber(options[2], force: true))";
            bigBlind   = "\(Util.getShortBlindNumber(options[2]*2, force: true))";
            
            btnSuggestion3.tag = options[2];
            btnSuggestion3.setTitle("\(smallBlind)/\(bigBlind)", forState: UIControlState.Normal);
        }
        
        if( options.count >= 4 ){
            
            smallBlind = "\(Util.getShortBlindNumber(options[3], force: true))";
            bigBlind   = "\(Util.getShortBlindNumber(options[3]*2, force: true))";
            
            btnSuggestion4.tag = options[3];
            btnSuggestion4.setTitle("\(smallBlind)/\(bigBlind)", forState: UIControlState.Normal);
        }
    }
    
    func validateBlindLevel() -> Bool {
        
        var smallBlindOk : Bool = (txtSmallBlind.text != "") && (txtSmallBlind.text != "0");
        var bigBlindOk : Bool   = (txtBigBlind.text != "") && (txtBigBlind.text != "0");
        var anteOk : Bool       = (txtAnte.text != "");
        var durationOk : Bool   = (txtDuration.text != "") && (txtDuration.text != "0");
        
        if( swcIsBreak.on ){
            
            btnSave.enabled          = durationOk;
            btnPreviousLevel.enabled = durationOk;
            btnNextLevel.enabled     = durationOk;
            
            return durationOk;
        }
            
        btnSave.enabled          = (smallBlindOk && bigBlindOk && anteOk && durationOk);
        btnPreviousLevel.enabled = (smallBlindOk && bigBlindOk && anteOk && durationOk && currentLevelIndex > 0);
        btnNextLevel.enabled     = (smallBlindOk && bigBlindOk && anteOk && durationOk);
        btnDeleteLevel.enabled   = blindSet.blindLevelList.count > 1;
        
        return (smallBlindOk && bigBlindOk && anteOk && durationOk);
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return NSLocalizedString("Elapsed time:", comment: "") + " \(blindSet.blindLevelList[currentLevelIndex].elapsedTime)";
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cellSmallBlind.hidden = (swcIsBreak.on == true);
        cellBigBlind.hidden   = (swcIsBreak.on == true);
        cellAnte.hidden       = (swcIsBreak.on == true);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if( blindSet.blindLevelList[currentLevelIndex].isBreak == true ){
            
            if( indexPath.row > 0 && indexPath.row > 1 ){
                
                return 0;
            }
        }
        
        return 44;
    }
    
    func saveCurrentBlindLevel(){
        
        var isBreak = swcIsBreak.on;
        
        blindSet.blindLevelList[currentLevelIndex].isBreak = isBreak;
        
        if( !isBreak ){
            
            blindSet.blindLevelList[currentLevelIndex].smallBlind = txtSmallBlind.text.toInt()!;
            blindSet.blindLevelList[currentLevelIndex].bigBlind   = txtBigBlind.text.toInt()!;
            blindSet.blindLevelList[currentLevelIndex].ante       = txtAnte.text.toInt()!;
        }
        
        blindSet.blindLevelList[currentLevelIndex].duration       = txtDuration.text.toInt()!*60;
        blindSet.blindLevelList[currentLevelIndex].elapsedTime = Util.formatTimeString(Float(blindSet.getElapsedSeconds(blindSet.blindLevelList[currentLevelIndex].levelIndex)+(blindSet.blindLevelList[currentLevelIndex].duration))) as! String;
    }
    
    @IBAction func loadPreviousLevel(sender: AnyObject) {
        
        saveCurrentBlindLevel();
        
        currentLevelIndex = currentLevelIndex-1;
        loadBlindLevelFields();
        
        btnPreviousLevel.enabled = (currentLevelIndex > 0);
    }
    
    @IBAction func loadNextLevel(sender: AnyObject) {
        
        saveCurrentBlindLevel();
        
        currentLevelIndex = currentLevelIndex+1;
        
        if( currentLevelIndex > blindSet.blindLevelList.count-1 ){
            
            addNewLevel();
        }
        
        loadBlindLevelFields();
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        
        if( !hasChangeAnything ){
         
            handelConfirm();
            return;
        }

        var title     = NSLocalizedString("Cancel without saving?", comment: "");
        var message   = NSLocalizedString("All data will be lost!", comment: "");
        var yesButton = NSLocalizedString("YES", comment: "");
        var noButton  = NSLocalizedString("NO", comment: "");
        
        var alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: noButton, otherButtonTitles: yesButton)
        alert.show();
    }
    
    func handelConfirm() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func handelCancel() {
        // Your code
    }
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if( buttonIndex == 0 ){
            
            handelCancel();
        }else{
            
            handelConfirm()
        }
    }
    
    @IBAction func saveBlindLevel(sender: AnyObject) {
        
        saveCurrentBlindLevel();
        blindSet.updateMetadata();
        previousViewController.blindSet = blindSet;
        previousViewController.tableView.reloadData();
        handelConfirm();
    }
    
    @IBAction func changeIsBreak(sender: AnyObject) {

        blindSet.blindLevelList[currentLevelIndex].isBreak = swcIsBreak.on;
        blindSet.updateMetadata();
        
        hasChangeAnything = true;
        
        validateBlindLevel();
        self.tableView.reloadData();
        
        if( Constants.DeviceIdiom.IS_IPAD ){
            
            txtDuration.becomeFirstResponder();
        }
    }
    
    @IBAction func deleteCurrentLevel(sender: AnyObject) {
        
        blindSet.blindLevelList.removeAtIndex(currentLevelIndex);
        blindSet.updateMetadata();
        
        if( currentLevelIndex > blindSet.blindLevelList.count-1 ){
            
            currentLevelIndex = currentLevelIndex-1;
        }
        
        loadBlindLevelFields();
        validateBlindLevel();
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let validString = string as! NSString
        
        let validTimeCharacterSet = NSCharacterSet(charactersInString: "0123456789");
        let invalidTimeCharacterSet = validTimeCharacterSet.invertedSet
        let rangeOfInvalidCharacters = validString.rangeOfCharacterFromSet(invalidTimeCharacterSet)
        let invalidNumber = rangeOfInvalidCharacters.location != NSNotFound
        
        return !invalidNumber;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {

        if( textField.tag == 3 ){
            
            self.tableView.reloadData();
        }
        
        hasChangeAnything = true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch( textField.tag ){
        case 0:
            textField.resignFirstResponder();
            txtSmallBlind.becomeFirstResponder();
            break;
        case 1:
            textField.resignFirstResponder();
            txtBigBlind.becomeFirstResponder();
            
            if( txtBigBlind.text == "" || txtBigBlind.text == "0" ){
                
                duplicateSmallAsBig();
            }
            break;
        case 2:
            textField.resignFirstResponder();
            txtAnte.becomeFirstResponder();
            break;
        case 3:
            
            
            lastFirstResponder = textField;
            
            if( validateBlindLevel() ){
                
                loadNextLevel(self);
            }
            
            textField.resignFirstResponder();
//            txtDuration.becomeFirstResponder()
//            return false;
        default:
            break;
        }
        
        lastFirstResponder = textField;
        
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {

        lastFirstResponder = textField
    }
    
    func duplicateSmallAsBig(){
        
        let smallBlind : Int = txtSmallBlind.text.toInt()!;
        txtBigBlind.text = "\(smallBlind*2)";
        
        validateBlindLevel();
    }
    
    @IBAction func validateBlindLevel(sender: AnyObject) {
        
        validateBlindLevel();

        if( sender.tag == 0 && (sender as! UITextField).text == "" ){
            
            loadSuggestions();
        }
        
        if( sender.tag == 3 && (sender as! UITextField).text != "" ){
            
            var blindLevel : BlindLevel = blindSet.blindLevelList[currentLevelIndex];
            
            blindLevel.duration = txtDuration.text.toInt()!*60;
            blindLevel.elapsedTime = Util.formatTimeString(Float(self.blindSet.getElapsedSeconds(blindLevel.levelIndex)+(blindLevel.duration))) as! String;
        }
    }
    
    @IBAction func chooseLevelSuggestion(sender: AnyObject) {
        
        var smallBlind = sender.tag;

        txtSmallBlind.text = "\(smallBlind)";
        txtBigBlind.text   = "\(smallBlind*2)";
        
        hasChangeAnything = true;
        
        validateBlindLevel();
    }
    
    @IBAction func replicateDuration(sender: AnyObject) {
        
        let duration : Int = txtDuration.text.toInt()!*60;
        
        for( var i = 0; i < blindSet.blindLevelList.count; i++){
            
            blindSet.blindLevelList[i].duration = duration;
            blindSet.blindLevelList[i].elapsedTime = Util.formatTimeString(Float(blindSet.getElapsedSeconds(blindSet.blindLevelList[i].levelIndex)+(blindSet.blindLevelList[i].duration))) as! String;
        }
        
        
        imgReplicatedDuration.hidden = false;
    }
}