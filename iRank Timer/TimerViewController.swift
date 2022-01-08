//
//  TimerViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 04/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import MultipeerConnectivity

class TimerViewController: BackgroundViewController, UIAlertViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet var sldrTimeSlider : [UISlider]!;
    @IBOutlet var lblTimer : [UILabel]!;
    @IBOutlet var lblSmallBlind : [UILabel]!;
    @IBOutlet var lblBigBlind : [UILabel]!;
    @IBOutlet var lblAnte : [UILabel]!;
    @IBOutlet var lblNextSmallBlind : [UILabel]!;
    @IBOutlet var lblNextBigBlind : [UILabel]!;
    @IBOutlet var lblNextAnte : [UILabel]!;
    @IBOutlet var lblElapsedTime : [UILabel]!;
    @IBOutlet var lblLevel : [UILabel]!;
    @IBOutlet var lblNextBreak : [UILabel]!;
    @IBOutlet var lblNextLevel : [UILabel]!;
    @IBOutlet var btnNextLevel : [UIButton]!;
    @IBOutlet var btnPreviousLevel : [UIButton]!;
    @IBOutlet var imgHand : [UIImageView]!;
    @IBOutlet var lblCountDown : [UILabel]!;
    @IBOutlet var imgHorizontalLineLeft : [UIImageView]!;
    @IBOutlet var imgHorizontalLineRight : [UIImageView]!;
    
    @IBOutlet var lblSmallBlindLabel : [UILabel]!;
    @IBOutlet var lblBigBlindLabel : [UILabel]!;
    @IBOutlet var lblAnteLabel : [UILabel]!;
    @IBOutlet var lblElapsedTimeLabel : [UILabel]!;
    @IBOutlet var lblLevelLabel : [UILabel]!;
    @IBOutlet var lblNextBreakLabel : [UILabel]!;
    @IBOutlet var lblBreak: UILabel!
    
    var mainAlertView : UIAlertView!
    var isRunning : Bool = false;
    var currentLevelIndex : Int = 0;
    var currentBlindSetIndex : Int!;
    var editingBlindSetIndex : Int = 0;
    var timer : NSTimer!;
    var longPauseTimer : NSTimer!;
    var soundTimer : NSTimer!;
    var countDownTimer : NSTimer!;
    var blindSet : BlindSet!;
    var blindSetList : Array<BlindSet>! = [];
    var currentElapsedSeconds = 0;
    var moveMainViewOnEdit : Bool = true;
    var firstAnteNotified : Bool = false;
    var audioPlayer : AVAudioPlayer!;
    var countDownSeconds : Int = 8;
    var currentCountDownSeconds : Int = 8;
    var isCountDownRunning : Bool = false;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        blindSet              = blindSetList[currentBlindSetIndex];
        currentLevelIndex     = blindSet.currentLevelIndex;
        
        resetTimer(false, force: false);
        
        currentElapsedSeconds = blindSet.currentElapsedSeconds;
        sldrTimeSlider.first!.value  = Float(blindSet.blindLevelList[currentLevelIndex].duration-currentElapsedSeconds);
        sldrTimeSlider.last!.value = sldrTimeSlider.first!.value
        
        updateTimerLabel();
        
        transitionBackground = appDelegate.backgroundMode == "dynamic";
        
        changeBackgroundMode();
        
        checkMultipeerMode();
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var textColor      = appDelegate.inverseTextColor ? UIColor.blackColor() : UIColor.whiteColor();
        var shadowColor    = appDelegate.inverseTextColor ? UIColor.whiteColor(): UIColor.blackColor()
        var horizontalLine = appDelegate.inverseTextColor ? "black-dot" : "gray-dot";
        
        lblTimer.first!.textColor = textColor;
        lblTimer.last!.textColor = lblTimer.first!.textColor
        lblSmallBlind.first!.textColor = textColor;
        lblSmallBlind.last!.textColor = lblSmallBlind.first!.textColor
        lblBigBlind.first!.textColor = textColor;
        lblBigBlind.last!.textColor = lblBigBlind.first!.textColor
        lblAnte.first!.textColor = textColor;
        lblAnte.last!.textColor = lblAnte.first!.textColor
        lblNextSmallBlind.first!.textColor = textColor;
        lblNextSmallBlind.last!.textColor = lblNextSmallBlind.first!.textColor
        lblNextBigBlind.first!.textColor = textColor;
        lblNextBigBlind.last!.textColor = lblNextBigBlind.first!.textColor
        lblNextAnte.first!.textColor = textColor;
        lblNextAnte.last!.textColor = lblNextAnte.first!.textColor
        lblElapsedTime.first!.textColor = textColor;
        lblElapsedTime.last!.textColor = lblElapsedTime.first!.textColor
        lblLevel.first!.textColor = textColor;
        lblLevel.last!.textColor = lblLevel.first!.textColor
        lblNextBreak.first!.textColor = textColor;
        lblNextBreak.last!.textColor = lblNextBreak.first!.textColor
        lblNextLevel.first!.textColor = textColor;
        lblNextLevel.last!.textColor = lblNextLevel.first!.textColor
        
        lblSmallBlindLabel.first!.textColor = textColor;
        lblSmallBlindLabel.last!.textColor = lblSmallBlindLabel.first!.textColor
        lblBigBlindLabel.first!.textColor = textColor;
        lblBigBlindLabel.last!.textColor = lblBigBlindLabel.first!.textColor
        lblAnteLabel.first!.textColor = textColor;
        lblAnteLabel.last!.textColor = lblAnteLabel.first!.textColor
        
        lblElapsedTimeLabel.first!.textColor = textColor;
        lblElapsedTimeLabel.last!.textColor = lblElapsedTimeLabel.first!.textColor
        lblLevelLabel.first!.textColor = textColor;
        lblLevelLabel.last!.textColor = lblLevelLabel.first!.textColor
        lblNextBreakLabel.first!.textColor = textColor;
        lblNextBreakLabel.last!.textColor = lblNextBreakLabel.first!.textColor
        
        imgHorizontalLineLeft.first!.image = UIImage(named: horizontalLine);
        imgHorizontalLineLeft.last!.image = imgHorizontalLineLeft.first!.image
        imgHorizontalLineRight.first!.image = UIImage(named: horizontalLine);
        imgHorizontalLineRight.last!.image = imgHorizontalLineRight.first!.image
        
        lblTimer.first!.shadowColor = appDelegate.inverseTextColor ? UIColor.lightGrayColor() : UIColor.darkGrayColor();
        lblTimer.last!.shadowColor = lblTimer.first!.shadowColor
        lblSmallBlind.first!.shadowColor = shadowColor;
        lblSmallBlind.last!.shadowColor = lblSmallBlind.first!.shadowColor
        lblBigBlind.first!.shadowColor = shadowColor;
        lblBigBlind.last!.shadowColor = lblBigBlind.first!.shadowColor
        lblAnte.first!.shadowColor = shadowColor;
        lblAnte.last!.shadowColor = lblAnte.first!.shadowColor
        
//        sldrTimeSlider.first!.maximumTrackTintColor = appDelegate.inverseTextColor ? UIColor.blackColor() : UIColor.whiteColor();
//        sldrTimeSlider.last!.maximumTrackTintColor = sldrTimeSlider.first!.maximumTrackTintColor
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        if( appDelegate.firstExecution ){
            
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("showHandAnimation"), userInfo: nil, repeats: false);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return appDelegate.hideStatusBar;
    }
    
    func checkMultipeerMode(){
        
        if( appDelegate.enableMultipeer ){
            
            if( appDelegate.mpcManager == nil ){
                
                appDelegate.mpcManager = MPCManager();
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleMPCReceivedDataWithNotification:", name: "receivedMPCDataNotification", object: nil)
        }else{
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "receivedMPCDataNotification", object: nil);
        }
    }
    
    func resetTimer(fullReset : Bool, force : Bool){
        
        if( fullReset ){
            
            if( !force ){
                
                var title     = NSLocalizedString("Reset timer", comment: "");
                var message   = NSLocalizedString("Do you want to reset timer and load the first level of this blind set?", comment: "");
                var yesButton = NSLocalizedString("YES", comment: "")
                var noButton  = NSLocalizedString("NO", comment: "");
                
                confirmAlertView(title, message: message, noButton: noButton, yesButton: yesButton, tag: 1);
                
                return;
            }
            
            lblTimer.first!.textColor = UIColor.whiteColor();
            lblTimer.last!.textColor = lblTimer.first!.textColor
            
            currentLevelIndex          = 0;
            blindSet.currentLevelIndex = 0;
            isRunning                  = false;
            firstAnteNotified          = false;
            
            if( longPauseTimer != nil ){
                
                longPauseTimer.invalidate();
            }
        }
        
        currentElapsedSeconds = 0;
        
        sldrTimeSlider.first!.maximumValue = Float(blindSet.blindLevelList[currentLevelIndex].duration);
        sldrTimeSlider.last!.maximumValue = sldrTimeSlider.first!.maximumValue
        sldrTimeSlider.first!.value        = Float(blindSet.blindLevelList[currentLevelIndex].duration);
        sldrTimeSlider.last!.value = sldrTimeSlider.first!.value
        
        btnNextLevel.first!.enabled     = (currentLevelIndex < blindSet.blindLevelList.count-1);
        btnNextLevel.last!.enabled = btnNextLevel.first!.enabled
        btnNextLevel.first!.highlighted = !btnNextLevel.first!.enabled;
        btnNextLevel.last!.highlighted = btnNextLevel.first!.highlighted
        
        btnPreviousLevel.first!.enabled     = (currentLevelIndex > 0);
        btnPreviousLevel.last!.enabled = btnPreviousLevel.first!.enabled
        btnPreviousLevel.first!.highlighted = !btnPreviousLevel.first!.enabled;
        btnPreviousLevel.last!.highlighted = btnPreviousLevel.first!.highlighted
        
        if( blindSet.blindLevelList[currentLevelIndex].isBreak == true ){
            
            lblSmallBlind.first!.text  = "";
            lblSmallBlind.last!.text = lblSmallBlind.first!.text
            lblAnte.first!.text        = "";
            lblAnte.last!.text = lblAnte.first!.text
            lblLevel.first!.text    = "-";
            lblLevel.last!.text     = lblLevel.first!.text
            
            if( appDelegate.isPortrait() ){
                
                lblBigBlind.first!.text = "";
                lblBigBlind.last!.text  = lblBigBlind.first!.text;
                lblBreak.text           = NSLocalizedString("BREAK", comment: "");
                lblBreak.hidden         = false;
            }else{
                
                lblBigBlind.first!.text = NSLocalizedString("BREAK", comment: "");
                lblBigBlind.last!.text  = lblBigBlind.first!.text
                lblBreak.hidden         = true;
            }
        }else{
            
            lblBreak.hidden            = true;
            lblSmallBlind.first!.text  = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex].smallBlind);
            lblSmallBlind.last!.text   = lblSmallBlind.first!.text
            lblBigBlind.first!.text    = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex].bigBlind);
            lblBigBlind.last!.text     = lblBigBlind.first!.text
            lblAnte.first!.text        = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex].ante);
            lblAnte.last!.text         = lblAnte.first!.text
            lblLevel.first!.text       = "\(blindSet.blindLevelList[currentLevelIndex].levelNumber)";
            lblLevel.last!.text        = lblLevel.first!.text
        }
        
        if( blindSet.blindLevelList[currentLevelIndex].isBreak && appDelegate.isPortrait() && (appDelegate.IS_IPHONE_4_OR_LESS) ){
            
            lblSmallBlindLabel.first!.hidden = true;
            lblSmallBlindLabel.last!.hidden  = true;
            lblBigBlindLabel.first!.hidden   = true;
            lblBigBlindLabel.last!.hidden    = true;
            lblAnteLabel.first!.hidden       = true;
            lblAnteLabel.last!.hidden        = true;
        }else{
            
            lblSmallBlindLabel.first!.hidden = false;
            lblSmallBlindLabel.last!.hidden  = false;
            lblBigBlindLabel.first!.hidden   = false;
            lblBigBlindLabel.last!.hidden    = false;
            lblAnteLabel.first!.hidden       = false;
            lblAnteLabel.last!.hidden        = false;
        }
        
        if( currentLevelIndex+1 < blindSet.blindLevelList.count ){
            
            if( blindSet.blindLevelList[currentLevelIndex+1].isBreak == true ){
                
                lblNextSmallBlind.first!.text  = "";
                lblNextSmallBlind.last!.text = lblNextSmallBlind.first!.text
                lblNextBigBlind.first!.text    = NSLocalizedString("BREAK", comment: "");
                lblNextBigBlind.last!.text = lblNextBigBlind.first!.text
                lblNextAnte.first!.text        = "";
                lblNextAnte.last!.text = lblNextAnte.first!.text
            }else{
                
                lblNextSmallBlind.first!.text  = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex+1].smallBlind);
                lblNextSmallBlind.last!.text = lblNextSmallBlind.first!.text
                lblNextBigBlind.first!.text    = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex+1].bigBlind);
                lblNextBigBlind.last!.text = lblNextBigBlind.first!.text
                lblNextAnte.first!.text        = Util.getShortBlindNumber(blindSet.blindLevelList[currentLevelIndex+1].ante);
                lblNextAnte.last!.text = lblNextAnte.first!.text
            }
        }else{
            
            lblNextSmallBlind.first!.text  = "";
            lblNextSmallBlind.last!.text = lblNextSmallBlind.first!.text
            lblNextBigBlind.first!.text    = "";
            lblNextBigBlind.last!.text = lblNextBigBlind.first!.text
            lblNextAnte.first!.text        = "";
            lblNextAnte.last!.text = lblNextAnte.first!.text
        }
        
        blindSet.currentLevelIndex = currentLevelIndex;
        blindSet.updateElapsedSeconds();
        blindSet.updateNextBreak();
        
        updateTimerLabel();
    }
    
    func updateTimer(){
        
        if( !isRunning ){
            
            return;
        }
        
        sldrTimeSlider.first!.value  = sldrTimeSlider.first!.value-1;
        sldrTimeSlider.last!.value = sldrTimeSlider.first!.value
        currentElapsedSeconds = Int(sldrTimeSlider.first!.maximumValue-sldrTimeSlider.first!.value);
        
        var finish = false;
        
        if( sldrTimeSlider.first!.value == 0 ){
            
            imgBackground1.first!.alpha = 1.0;
            imgBackground1.last!.alpha = imgBackground1.first!.alpha;
            imgBackground2.first!.alpha = 1.0;
            imgBackground2.last!.alpha = imgBackground2.first!.alpha;
            
            if( currentLevelIndex >= blindSet.blindLevelList.count ){
                
                return;
            }
            
            var previousAnte : Int = blindSet.blindLevelList[currentLevelIndex].ante;
            
            if( nextBlindLevel() ){
                
                var currentAnte : Int = blindSet.blindLevelList[currentLevelIndex].ante;
                
                if( isRunning && previousAnte == 0 && currentAnte > 0 && appDelegate.notifyFirstAnte && !firstAnteNotified ){
                    
                    notifyFirstAnte();
                }else if( blindSet.playSound ){
                    
                    self.playSound(appDelegate.blindChangeSound);
                }
                
                if( currentAnte < previousAnte && !blindSet.blindLevelList[currentLevelIndex].isBreak ){
                    
                    firstAnteNotified = false;
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(appDelegate.kNotificationBlindLevelChange, object: blindSet.blindLevelList[currentLevelIndex], userInfo: nil);
            }else{
                
                finish = true;
            }
        }
        
        if( sldrTimeSlider.first!.value <= 5 ){
            
            imgBackground1.first!.alpha = 0.85;
            imgBackground1.last!.alpha = imgBackground1.first!.alpha
            imgBackground2.first!.alpha = 0.85;
            imgBackground2.last!.alpha = imgBackground2.first!.alpha
            lblTimer.first!.textColor = UIColor.redColor();
            lblTimer.last!.textColor = lblTimer.first!.textColor
            
            if( isRunning && sldrTimeSlider.first!.value == 5 && appDelegate.fiveSecondsClock ){
                
                self.playSound("clock-tick");
            }
        }else{
            
            lblTimer.first!.textColor = appDelegate.inverseTextColor ? UIColor.blackColor() : UIColor.whiteColor();
            lblTimer.last!.textColor = lblTimer.first!.textColor
        }
        
        if( isRunning && sldrTimeSlider.first!.value == 60 && blindSet.lastMinuteAlert ){
            
            self.playSound(appDelegate.lastMinuteSound);
        }
        
        updateTimerLabel();
        
        if( finish ){
            
            lblTimer.first!.textColor = UIColor.redColor();
            lblTimer.last!.textColor = lblTimer.first!.textColor
            lblTimer.first!.text      = "--:--:--";
            lblTimer.last!.text = lblTimer.first!.text
            
            self.playSound(appDelegate.blindChangeSound, loops: 2);
        }
    }
    
    func updateTimerLabel(){
        
        lblTimer.first!.text       = Util.formatTimeString(sldrTimeSlider.first!.value) as String;
        lblTimer.last!.text = lblTimer.first!.text
        lblElapsedTime.first!.text = Util.formatTimeString(Float(blindSet.elapsedSeconds+currentElapsedSeconds)) as String;
        lblElapsedTime.last!.text = lblElapsedTime.first!.text
        
        if( blindSet.nextBreakRemain == 0 ){
            
            lblNextBreak.first!.text = "--:--:--";
            lblNextBreak.last!.text = lblNextBreak.first!.text
        }else{
            
            lblNextBreak.first!.text = Util.formatTimeString(Float(blindSet.nextBreakRemain-currentElapsedSeconds)) as String;
            lblNextBreak.last!.text = lblNextBreak.first!.text
        }
    }
    
    func notifyFirstAnte(){
        
        firstAnteNotified = true;
        
        var transformAnim            = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values         = [NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(3 * CGFloat(M_PI/180), 0, 0, 1))),
            NSValue(CATransform3D: CATransform3DMakeScale(1.25, 1.25, 1.25)),
            NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(-8 * CGFloat(M_PI/180), 0, 0, 1)))]
        
        transformAnim.keyTimes       = [1];
        transformAnim.duration       = 0.25;
        transformAnim.repeatCount    = 20;
        self.lblAnte.first!.layer.addAnimation(transformAnim, forKey: "transform");
        
        self.playSound(appDelegate.firstAnteSound);
    }
    
    func startTimer(){
        
        if( isRunning ){
            
            return;
        }
        
        stopSound();
        
        if( timer != nil && timer.valid ){
            
            timer.invalidate();
        }
        
        if( longPauseTimer != nil ){
            
            longPauseTimer.invalidate();
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true);
        isRunning = true;
        
        sendMessageToRemotecontrol("timer-running")
    }
    
    func pauseTimer(reset : Bool){
        
        if( !isRunning ){
            
            return;
        }
        
        timer.invalidate();
        isRunning = false;
        
        var minutes = appDelegate.longPauseMinutes*60;
        
        if( !reset && minutes > 0 ){
            
            longPauseTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(minutes), target: self, selector: Selector("alertLongPause"), userInfo: nil, repeats: false);
        }
        
        sendMessageToRemotecontrol("timer-notRunning")
    }
    
    func alertLongPause(){
        
        if( isRunning ){
            
            return;
        }
        
        var title     = NSLocalizedString("TimerViewController.Long pause alert", comment: "")
        var message   = NSLocalizedString("Your timer is paused for a long time. Do yout want to resume?", comment: "")
        var yesButton = NSLocalizedString("YES", comment: "")
        var noButton  = NSLocalizedString("NO", comment: "")
        
        confirmAlertView(title, message: message, noButton: noButton, yesButton: yesButton, tag: 2);
        
        self.playSound("pulse", loops: 4);
    }
    
    func confirmAlertView(title : String, message : String, noButton : String, yesButton : String, tag : Int){
        
        mainAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: noButton, otherButtonTitles: yesButton)
        
        mainAlertView.tag = tag;
        mainAlertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        switch( alertView.tag ){
        case 1:
            if( buttonIndex == 1 ){
                
                resetTimer(true, force: true);
            }
            break;
        case 2:
            
            if( buttonIndex == 1 ){
                
                startTimer();
            }
            break;
        default:
            break;
        }
    }
    
    func nextBlindLevel() -> Bool {
        
        currentLevelIndex++;
        
        if( currentLevelIndex >= blindSet.blindLevelList.count ){
            
            pauseTimer(true);
            
            return false;
        }
        
        resetTimer(false, force: false);
        
        return true;
    }
    
    func previousBlindLevel(){
        
        currentLevelIndex--;
        resetTimer(false, force: false);
    }
    
    @IBAction func loadNextLevel(sender: AnyObject) {
        
        if( !btnNextLevel.first!.enabled ){
            
            return;
        }
        
        nextBlindLevel()
    }
    
    @IBAction func loadPreviousLevel(sender: AnyObject) {
        
        if( !btnPreviousLevel.first!.enabled ){
            
            return;
        }
        
        previousBlindLevel();
    }
    
    @IBAction func changeSliderValue(sender: AnyObject) {
        
        var slider : UISlider = sender as! UISlider;
        
        sldrTimeSlider.first!.value = Float(Int(slider.value));
        sldrTimeSlider.last!.value  = Float(Int(slider.value));
        
        var currentSlider : UISlider = sender as! UISlider;
        
        currentElapsedSeconds = Int(currentSlider.maximumValue-currentSlider.value);
        updateTimerLabel();
    }
    
    @IBAction func timerButtonTouchDown(sender: AnyObject) {
        
        lblTimer.first!.enabled = false;
        lblTimer.last!.enabled = lblTimer.first!.enabled
    }
    
    @IBAction func changeTimerState(sender: AnyObject) {
        
        lblTimer.first!.enabled = true;
        lblTimer.last!.enabled = lblTimer.first!.enabled
        
        if( isRunning ){
            
            pauseTimer(false);
        }else{
            
            if( mainAlertView != nil ){
                
                mainAlertView.dismissWithClickedButtonIndex(-1, animated: true);
            }
            
            startTimer();
        }
    }
    
    func playSound(soundName : String){
        
        self.playSound(soundName, loops: 0);
    }
    
    func playSound(soundName : String, loops : Int){
        
        if( !appDelegate.playSounds ){
            
            return;
        }
        
        if( soundName == "" ){
            
            return;
        }
        
        if( audioPlayer != nil ){
            
            audioPlayer.stop();
        }
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers, error: nil); // Usar esse se quiser apenas baixar o som atual
        //        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil); // Usar esse se quiser parar o som atual para tocar os sons do timer
        AVAudioSession.sharedInstance().setActive(false, error: nil);
        
        var filePath : String = NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!;
        audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: filePath), error: nil);
        
        audioPlayer.numberOfLoops = loops;
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        if( soundTimer != nil ){
            
            soundTimer.invalidate();
        }
        
        // Se estiver rodando o timer, evita que pare o som porque se estiver tocando uma música de fundo, trava tudo
        if( soundName != "countdown-step" ){
            
            soundTimer = NSTimer.scheduledTimerWithTimeInterval((audioPlayer.duration+2)*Double(loops+1), target: self, selector: Selector("stopSound"), userInfo: nil, repeats: false);
        }
    }
    
    func stopSound(){
        
        if( audioPlayer != nil ){
            
            audioPlayer.stop();
            AVAudioSession.sharedInstance().setActive(false, withOptions: AVAudioSessionSetActiveOptions.OptionNotifyOthersOnDeactivation, error: nil);
        }
    }
    
    func changeBackgroundMode(){
        
        transitionBackground = appDelegate.backgroundMode == "dynamic";
        
        if( transitionBackground ){
            
            if( self.imgBackground2.first!.subviews.count > 0 ){
                
                self.imgBackground2.first!.subviews[0].removeFromSuperview();
                self.imgBackground2.last!.subviews[0].removeFromSuperview();
            }
            
            startBackgroundTransition()
        }else{
            
            if( appDelegate.backgroundImageName == "custom" ){
                
                var ciimage = CIImage(image: appDelegate.backgroundCustomImage)
                
                var filter = CIFilter(name:"CIGaussianBlur")
                filter.setDefaults()
                filter.setValue(ciimage, forKey: kCIInputImageKey)
                filter.setValue(13, forKey: kCIInputRadiusKey)
                
                var outputImage = filter.outputImage;
                
                var finalImage = UIImage(CIImage: outputImage);
                var imageView : UIImageView!;
                
                if( self.imgBackground2.first!.subviews.count == 0 ){
                    
                    imageView = UIImageView(image: finalImage);
                    imageView.frame = CGRectMake(0, 0, backgroundWidth, backgroundHeight);
                }else{
                    
                    imageView = self.imgBackground2.first!.subviews[0] as! UIImageView
                    imageView.image = finalImage;
                }
                
                imageView.alpha = 0.25
                
                self.imgBackground2.first!.image = nil;
                self.imgBackground2.last!.image = self.imgBackground2.first!.image;
                self.imgBackground2.first!.addSubview(imageView)
                self.imgBackground2.last!.addSubview(imageView)
                self.imgBackground2.first!.backgroundColor = appDelegate.inverseTextColor ? UIColor.whiteColor() : UIColor.blackColor()
                self.imgBackground2.last!.backgroundColor = self.imgBackground2.first!.backgroundColor
                
                self.view.backgroundColor = appDelegate.inverseTextColor ? UIColor.whiteColor() : UIColor.blackColor()
                
                UIGraphicsEndImageContext();
            }else{
                
                self.imgBackground2.first!.image = UIImage(named: appDelegate.backgroundImageName);
                
                if( self.imgBackground2.first!.subviews.count > 0 ){
                    
                    self.imgBackground2.first!.subviews[0].removeFromSuperview();
                    self.imgBackground2.last!.subviews[0].removeFromSuperview();
                }
            }
            
            self.imgBackground1.first!.hidden = true;
            self.imgBackground1.last!.hidden = self.imgBackground1.first!.hidden;
            self.imgBackground2.first!.hidden = false;
            self.imgBackground2.last!.hidden = self.imgBackground2.first!.hidden;
            
            self.imgBackground2.first!.alpha = 1;
            self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha;
        }
    }
    
    func getConnectedPeer() -> MCPeerID! {
        
        if( appDelegate.mpcManager.session.connectedPeers.count == 0 ){
            
            self.appDelegate.mpcManager.session.disconnect();
            self.dismissViewControllerAnimated(false, completion: nil);
            
            return nil;
        }
        
        return appDelegate.mpcManager.session.connectedPeers[0] as! MCPeerID
    }
    
    func sendMessageToRemotecontrol(message: String) {
        
        if( !appDelegate.enableMultipeer ){
            return;
        }
        
        if( getConnectedPeer() != nil ){
            
            let messageDictionary: [String: String] = ["message": message];
            appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: getConnectedPeer())
        }
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, String>
        
        if let newCountDownSeconds = dataDictionary["countDownSeconds"] {
            
            countDownSeconds = (newCountDownSeconds as String).toInt()!;
        }
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            // Make sure that the message is other than "_end_chat_".
            if message != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
                //                var messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                println("message on timer: \(message)");
                
                switch( message ){
                case "timer-toggleState":
                    
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.changeTimerState(self);
                    })
                    break;
                case "timer-reset":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.resetTimer(true, force: true);
                    })
                    break;
                case "timer-pause":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.pauseTimer(false);
                    })
                    break;
                case "timer-level-previous":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.loadPreviousLevel(self);
                    })
                    break;
                case "timer-level-next":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.loadNextLevel(self);
                    })
                    break;
                case "countdown-start":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.startCountDown();
                    })
                    break;
                case "countdown-stop":
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                        
                        self.stopCountDown();
                    })
                    break;
                default:
                    break;
                }
            }
            else{
                self.appDelegate.mpcManager.session.disconnect()
            }
        }
    }
    
    func startCountDown(){
        
        if( isCountDownRunning ){
            
            stopCountDown();
            return;
        }
        
        sendMessageToRemotecontrol("countdown-running");
        
        currentCountDownSeconds = countDownSeconds;
        
        isCountDownRunning = true;
        
        lblCountDown.first!.hidden = false;
        lblCountDown.last!.hidden = lblCountDown.first!.hidden
        runCountDown()
        
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("runCountDown"), userInfo: nil, repeats: true);
    }
    
    func runCountDown(){
        
        if( !isCountDownRunning ){
            
            return;
        }
        
        lblCountDown.first!.text  = "\(currentCountDownSeconds)";
        lblCountDown.last!.text = lblCountDown.first!.text
        lblCountDown.first!.alpha = 1;
        lblCountDown.last!.alpha = lblCountDown.first!.alpha
        lblCountDown.first!.hidden = false;
        lblCountDown.last!.hidden = lblCountDown.first!.hidden
        
        currentCountDownSeconds = currentCountDownSeconds-1;
        
        if( currentCountDownSeconds < 0 ){
            
            lblCountDown.first!.text  = NSLocalizedString("TIME OUT", comment: "");
            lblCountDown.last!.text = lblCountDown.first!.text
            
            playSound("first-ante-1");
            countDownTimer.invalidate();
            isCountDownRunning = false;
            
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("stopCountDown"), userInfo: nil, repeats: false);
            
            return;
        }
        
        playSound("countdown-step");
    }
    
    func stopCountDown(){
        
        sendMessageToRemotecontrol("countdown-notRunning");
        
        lblCountDown.first!.layer.removeAllAnimations();
        lblCountDown.first!.hidden = true;
        lblCountDown.last!.hidden = lblCountDown.first!.hidden
        
        isCountDownRunning = false;
        
        if( countDownTimer != nil ){
            
            countDownTimer.invalidate();
        }
        
        stopSound();
    }
    
    func showHandAnimation(){
        
        if( !appDelegate.firstExecution ){
            
            return;
        }
        
        imgHand.first!.frame = CGRectMake(77, 215, 230, 270);
        imgHand.last!.frame = imgHand.first!.frame
        imgHand.first!.hidden = false;
        imgHand.last!.hidden = imgHand.first!.hidden
        imgHand.first!.alpha = 1;
        imgHand.last!.alpha = imgHand.first!.alpha
        
        UIView .animateWithDuration(1.25, animations: {
            self.imgHand.first!.alpha = 0;
            self.imgHand.last!.alpha = self.imgHand.first!.alpha
            self.imgHand.first!.frame = CGRectMake(377, 215, 230, 270);
            self.imgHand.last!.frame = self.imgHand.first!.frame
        });
        
        NSTimer.scheduledTimerWithTimeInterval(3.25, target: self, selector: Selector("showHandAnimation"), userInfo: nil, repeats: false);
    }
    
    func updateBlindSet(newBlindSet : BlindSet){
        
        var isNew : Bool = newBlindSet.isNew;
        newBlindSet.isNew = false;
        
        if( editingBlindSetIndex >= 0 && !isNew ){
            
            self.blindSetList[editingBlindSetIndex] = newBlindSet;
        }else{
            
            editingBlindSetIndex = -1;
            self.blindSetList.append(newBlindSet);
        }
        
        if( editingBlindSetIndex == currentBlindSetIndex && !isNew ){
            
            self.blindSet = self.blindSetList[editingBlindSetIndex];
            resetTimer(true, force: false);
        }
        
        appDelegate.needBackup = true;
        BlindSet.archiveBlindSetList(blindSetList);
    }
}

