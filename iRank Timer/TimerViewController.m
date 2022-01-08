//
//  TimerViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-19.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerViewController.h"

@implementation TimerViewController
    
- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    blindSet   = appDelegate.blindSet;
    blindLevel = [blindSet currentBlindLevel];
    
    [blindSet updateNextBreakRemain];
    
    currentElapsedTime = 0;
    timerPauseSeconds  = 0;
    timerEnabled       = NO;
    timerStarted       = NO;
    timerFinished      = NO;
    backgroundColor    = @"blue";
    
    timer = nil;
    alertView = nil;
    
    //        [self configureTimeBank];
    [self updateCurrentLevel];
    
    if( appDelegate.inverseColors ){
        
        timerTextColor          = [UIColor blackColor];
        timerShadowColor        = [UIColor grayColor];
        timerWarningShadowColor = [UIColor darkGrayColor];
        warningColor            = darkRed2Color;
        
        highlightCellTextColor = [UIColor blackColor];
        cellTextColor          = [UIColor darkGrayColor];
        currentLevelCellBgColor = darkSilverColor;
        
        timerBgImageName    = @"timer-white-bg.png";
        timerBgRedImageName = @"timer-red-white-bg.png";
    }else{
        
        timerTextColor          = [UIColor whiteColor];
        timerShadowColor        = [UIColor blackColor];
        timerWarningShadowColor = darkRedColor;
        warningColor            = darkRed2Color;
        
        highlightCellTextColor  = [UIColor whiteColor];
        cellTextColor           = [UIColor grayColor];
        currentLevelCellBgColor = darkRedColor;
        
        timerBgImageName    = (IS_IPAD?@"timer-blue-bg.png":@"iphone-timer-blue-bg.png");
        timerBgRedImageName = (IS_IPAD?@"timer-red-bg.png":@"iphone-timer-red-bg.png");
    }
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        
        menuToolbar.tintColor = [UIColor blackColor];
    }
}
    
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    if( !appDelegate.inverseColors )
    return UIStatusBarStyleLightContent;
    
    return UIStatusBarStyleDefault;
}
    
-(void)dealloc {
    
    NSLog(@"dealloc");
}
    
-(void)localizeView {
    
    lblElapsedTimeLabel.text = NSLocalizedString(@"ELAPSED", @"TimerViewController");
    lblNextBreakLabel.text   = NSLocalizedString(@"NEXT BREAK", @"TimerViewController");
    
    lblLevelLabel.text       = NSLocalizedString(@"LEVEL", @"TimerViewController");
    lblElapsedLabel.text     = NSLocalizedString(@"ELAPSED", @"TimerViewController");
    
    lblDurationLabel.text    = NSLocalizedString(@"DURATION", @"TimerViewController");
    lblCurrentSmallBlind.text = NSLocalizedString(@"SMALL BLIND", @"TimerViewController");
    lblCurrentBigBlind.text   = NSLocalizedString(@"BIG BLIND", @"TimerViewController");
    lblCurrentAnte.text       = NSLocalizedString(@"ANTE", @"TimerViewController");
    lblSmallBlindLabel.text   = NSLocalizedString(@"SMALL BLIND", @"TimerViewController");
    lblBigBlindLabel.text     = NSLocalizedString(@"BIG BLIND", @"TimerViewController");
    lblAnteLabel.text         = NSLocalizedString(@"ANTE", @"TimerViewController");
}
    
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateTimerLabel];
}  
    
#pragma mark - Actions -
- (BOOL)openCreateMenu {
    
    if( LITE_VERSION ){
        
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:NSLocalizedString(@"This feature is not enabled in lite version of this app. Would you like to download the full version at App Store?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"Not now", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"YES", @"TimerViewController"), nil];
        alertView.tag = 2;
        [alertView show];
        return NO;
    }
    
    return YES;
}
    
- (void)openConfig:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad_Config" bundle:nil];
    UIViewController *configViewController = [sb instantiateViewControllerWithIdentifier:@"ConfigViewController"];
    
    [appDelegate pushViewController:configViewController];
}
    
- (void)previousLevel:(id)sender {
    
    timerFinished = NO;
    
    currentElapsedTime = 0;
    [blindSet previousLevel];
    [self updateCurrentLevel];    
}
    
- (void)nextLevel:(id)sender {
    
    timerFinished = NO;
    
    currentElapsedTime = 0;
    
    int currentAnte = blindLevel.ante;
    BOOL isBreak    = blindLevel.isBreak;
    
    [blindSet nextLevel];
    [self updateCurrentLevel];
    
    int nextAnte = blindLevel.ante;
    
    if( appDelegate.notifyFirstAnte && !isBreak && currentAnte==0 && nextAnte > 0 ){
        
        lblAnte.font      = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(IS_IPAD?95:50)];
        lblAnte.textColor = warningColor;
        
        [self blinkAnteLabel];
    }
}

- (void)blinkAnteLabel {

    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1.25)]];
    [basic setAutoreverses:YES];
    [basic setRepeatCount:10];
    [basic setDuration:0.25];
    [lblAnte.layer addAnimation:basic forKey:@"transform"];
    
    [self performSelector:@selector(resetAnteLabel) withObject:self afterDelay:5.0];
}

- (void)resetAnteLabel {
    
    lblAnte.font      = [UIFont fontWithName:(IS_IPAD?@"HelveticaNeue-Light":@"HelveticaNeue-Medium") size:(IS_IPAD?95:50)];
    
    if( appDelegate.inverseColors )
        lblAnte.textColor = [UIColor blackColor];
    else
        lblAnte.textColor = [UIColor whiteColor];
}

-(void)startStopTimer:(id)sender {
    
    if( timer==nil && !timerStarted )
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    
    if( timerEnabled ){
        
        timerEnabled = NO;
        [self performSelector:@selector(runPauseTimer) withObject:self afterDelay:1.0];
    }else{
        
        timerEnabled      = YES;
        timerStarted      = YES;
        timerPauseSeconds = 0;
    }
    
    [audioPlayer stop];
}
    
- (void)resetTimer:(id)sender {
    
    NSString *message;
    
    if( sender==nil )
    message = NSLocalizedString(@"Select a different blind set will reset the current timer. Do you want to change?", @"TimerViewController");
    else
        message = NSLocalizedString(@"Are you sure you want to reset the current timer?", @"TimerViewController");
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"Reset Timer", @"TimerViewController"), nil];
    alertView.tag = 1;
    [alertView show];
}
    
- (void)resetTimer {
    
    NSLog(@"Passou por aqui também");
    
    timerFinished      = NO;
    timerEnabled       = NO;
    timerStarted       = NO;
    currentElapsedTime = 0;
    
    timerPauseSeconds = 0;
    
    if( [btnTimerSwitch isKindOfClass:[UIBarButtonItem class]] )
        [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController")];
    else
        [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController") forState:UIControlStateNormal];
    
    [blindSet resetLevels];
    [self updateCurrentLevel];
    [audioPlayer stop];
}
    
-(void)updateCurrentLevel {
    
    blindLevel = [blindSet currentBlindLevel];
    
    if( blindLevel.isBreak ){
        
        lblCurrentLevel.text = @"-";
        lblSmallBlind.text   = @" ";
        lblBigBlind.text     = NSLocalizedString(@"BREAK", @"TimerViewController");
        lblAnte.text         = @" ";
        
        //        lblBigBlind.frame = CGRectMake(lblBigBlind.frame.origin.x, lblBigBlind.frame.origin.y, 396*2, lblBigBlind.frame.size.height);
    }else{
        
        lblCurrentLevel.text = [NSString stringWithFormat:@"%i", blindLevel.levelNumber];
        
        if( appDelegate.shortBlindNumber && blindLevel.smallBlind >= 1000 )
            lblSmallBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.smallBlind/1000)];
        else
            lblSmallBlind.text = [NSString stringWithFormat:@"%i", blindLevel.smallBlind];
        
        if( appDelegate.shortBlindNumber && blindLevel.bigBlind >= 1000 )
            lblBigBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.bigBlind/1000)];
        else
            lblBigBlind.text = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
        
        if( appDelegate.shortBlindNumber && blindLevel.ante >= 1000 )
            lblAnte.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.ante/1000)];
        else
            lblAnte.text = [NSString stringWithFormat:@"%i", blindLevel.ante];
        
        lblSmallBlind.text = [lblSmallBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblBigBlind.text   = [lblBigBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblAnte.text       = [lblAnte.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    lblTimer.text = [BlindSet formatTimeString:blindLevel.seconds];
    timerSlider.maximumValue = (float)blindLevel.seconds;
    timerSlider.value        = (float)blindLevel.seconds;
    
    lblElapsedTime.text = blindSet.elapsedtime;
    
    [self updateTimerLabel];
}
    
-(void)changeCurrentTime:(id)sender {
    
    currentElapsedTime  = blindLevel.seconds;
    currentElapsedTime -= (int)timerSlider.value;
    [self updateTimerLabel];
    
    [audioPlayer stop];
}
    
-(void)runTimer {
    
    if( !timerEnabled )
    return;
    
    currentElapsedTime++;
    timerSlider.value = (float)(blindLevel.seconds-currentElapsedTime);
    
    // ------------------TIMEBANK---------------------
    //    if( timerSlider.value==30 )
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStartTimeBank object:nil userInfo:nil];
    //
    //    if( timeBank > 0 )
    //        lblTimeBank.text = [NSString stringWithFormat:@"%i", timeBank];
    //    else if( timeBank == 0 )
    //        lblTimeBank.text = @"FOLD";
    //
    //    if( timeBank < -3 )
    //        [timeBankView setHidden:YES];
    //    else
    //        timeBank--;
    // ------------------TEMPORARIO---------------------
    
    
    //    NSLog(@"currentElapsedTime: %i", currentElapsedTime);
    
    [self updateTimerLabel];
    
    if( timerSlider.value == 0 && blindSet.blindChangeAlert && !timerFinished ){
        
        int currentAnte = blindLevel.ante;
        
        [self nextLevel:nil];
        
        int nextAnte = blindLevel.ante;
        
        if( appDelegate.notifyFirstAnte && currentAnte==0 && nextAnte > 0 )
            [self playSound: @"ante-notify1"];
        else
            [self playSound: appDelegate.blindChangeSound];
        
        
        if( [[UIApplication sharedApplication] applicationState] ==UIApplicationStateBackground )
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBlindLevelChange object:blindLevel userInfo:nil];
        
    }else if( timerSlider.value == 60 && blindLevel.seconds > 60 && blindSet.minuteAlert ){
        
        if( !audioPlayer.playing )
        [self playSound: appDelegate.minuteNotifySound];
    }else if( timerSlider.value == 5 && appDelegate.fiveSecondsClock ){
        
        if( !audioPlayer.playing )
        [self playSound: @"clock-tick"];
    }
}
    
-(void)runPauseTimer {
    
    timerPauseSeconds++;
    
    if( !timerStarted || timerEnabled || !appDelegate.longPauseAlert )
    return;
    
    BOOL continueCounting = YES;
    
    if( timerPauseSeconds % 60 == 0 && timerStarted ){
        
        if( alertView==nil ){
            
            alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TIMER IS PAUSED", @"TimerViewController") message:NSLocalizedString(@"Timer is paused for a long time.\nWould you like to resume timer now?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"NO", "TimerViewController") otherButtonTitles:NSLocalizedString(@"RESUME", @"TimerViewController"), nil];
            alertView.tag = 0;
            [alertView show];
            
            [self playSound:@"pulse" loops:4];
            
            // Isso é para que só de o alerta uma vez se estiver em segundo plano
            if( [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground )
            continueCounting = NO;
        }
    }
    
    if( continueCounting )
    [self performSelector:@selector(runPauseTimer) withObject:self afterDelay:1.0];
}
    
- (void)alertView:(UIAlertView *)pAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch( pAlertView.tag ){
        case 0:
            if (buttonIndex == 1)
                [self startStopTimer:nil];
            break;
        case 1:
            if (buttonIndex == 1){
            
                appDelegate.blindSet = blindSet;
                [self resetTimer];
            }else{
            
                blindSet = appDelegate.blindSet;
            }
            break;
        case 2:
            if (buttonIndex == 1){
                
                NSString *appUrl = [NSString stringWithFormat:APP_URL, appDelegate.language];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appUrl]];
            }
            break;
    }
    
    [audioPlayer stop];
    
    alertView = nil;
}
    
-(void)updateTimerLabel {
    
    lblElapsedTime.text = [BlindSet formatTimeString: blindSet.elapsedSeconds+currentElapsedTime];
    lblTimer.text       = [BlindSet formatTimeString:(int)timerSlider.value];
    
    
    if( blindSet.nextBreakRemain < 0 )
    lblNextBreak.text = @"--:--:--";
    else
    lblNextBreak.text = [BlindSet formatTimeString:blindSet.nextBreakRemain-currentElapsedTime];
    
    [self updateTimerColor];
}
    
-(void)updateTimerColor {
    
    if( timerSlider.value < 10 ){
        
        lblTimer.textColor    = warningColor;
        lblTimer.shadowColor  = timerWarningShadowColor;
        lblTimer.shadowOffset = CGSizeMake(1, 3);
        
    }else{
        
        lblTimer.textColor    = timerTextColor;
        lblTimer.shadowColor  = timerShadowColor;
        lblTimer.shadowOffset = CGSizeMake(0, 4);
    }
    
    [self updateBackground];
}

-(void)updateBackground {
    
    if( timerSlider.value < 10 ){
     
        if( [backgroundColor isEqualToString:@"blue"] ){
            
            backgroundColor = @"red";
            imgMainBg.image = [UIImage imageNamed:timerBgRedImageName];
        }
    }else{
        
        if( [backgroundColor isEqualToString:@"red"] ){
            
            backgroundColor = @"blue";
            imgMainBg.image = [UIImage imageNamed:timerBgImageName];
        }
    }
}

-(void)playSound:(NSString *)soundName loops:(int)loops {
    
    if( !appDelegate.playSounds || !blindSet.playSound )
    return;
    
    [audioPlayer stop];
    
    NSLog(@"playSound: %@", soundName);
    
    NSString* blindNotifyAudio = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:blindNotifyAudio]  error:NULL];
    
    audioPlayer.numberOfLoops = loops;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
    
-(void)playSound:(NSString *)soundName {
    
    [self playSound:soundName loops:0];
}
    
-(void)invalidateTimer {
    
    [timer invalidate];
    timer = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)setBlindSet:(BlindSet *)aBlindSet {
    
    blindSet = aBlindSet;
}

@end
