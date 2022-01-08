//
//  iPhoneTimerViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-16.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneTimerViewController.h"
#import "iPhoneTimerMenuViewController.h"

@interface iPhoneTimerViewController ()

@end

@implementation iPhoneTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    btnTimerSwitchLocal   = (UIBarButtonItem *)btnTimerSwitch;
    btnPreviousLevelLocal = (UIBarButtonItem *)btnPreviousLevel;
    btnNextLevelLocal     = (UIBarButtonItem *)btnNextLevel;
    
    NSLog(@"blindSet: %@", blindSet);
    
    btnPreviousLevelLocal.enabled = (blindSet.currentLevel > 1 );
    btnNextLevelLocal.enabled     = (blindSet.blindLevels > blindSet.currentLevel );
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];
    
    [self localizeView];
    
    showMenuToolbar = YES;
    
    NSLog(@"screenWidth: %f", SCREEN_WIDTH);
}

-(void)localizeView {
    
    [super localizeView];
    
    [btnTimerSwitchLocal setTitle:NSLocalizedString((timerEnabled?@"PAUSE":@"START"), @"TimerViewController")];
    [btnPreviousLevel setTitle:NSLocalizedString(@"Previous", @"TimerViewController")];
    [btnNextLevel setTitle:NSLocalizedString(@"Next", @"TimerViewController")];
    
    lblCurrentLevelLabel.text = NSLocalizedString(@"LEVEL", @"TimerViewController");
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self showMenuToolbar:NO];
}

-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{
    
    if( menuToolbar.frame.origin.y >= SCREEN_WIDTH && isShowingLandscapeView )
        [self showMenuToolbar:YES];
}

-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    if( menuToolbar.frame.origin.y < SCREEN_WIDTH && isShowingLandscapeView )
        [self hideMenuToolbar:YES];
}

-(void)showMenuToolbar:(BOOL)animated{
    
    float screenWidth  = (isShowingLandscapeView?SCREEN_WIDTH:SCREEN_HEIGHT);
    float screenHeight = (isShowingLandscapeView?SCREEN_HEIGHT:SCREEN_WIDTH);
    
    if( animated ){
        
        //slide the content view to the right to reveal the menu
        [UIView animateWithDuration:.25
                         animations:^{
                             
                             [menuToolbar setFrame:CGRectMake(0, screenWidth-menuToolbar.frame.size.height-(appDelegate.isIOS7?0:20), screenHeight, menuToolbar.frame.size.height)];
                         }
         ];
        menuToolbar.alpha = 1;
    }else{
        
        [menuToolbar setFrame:CGRectMake(0, screenWidth-menuToolbar.frame.size.height-(appDelegate.isIOS7?0:20), screenHeight, menuToolbar.frame.size.height)];
        menuToolbar.alpha = 1;
    }
    
    showMenuToolbar = YES;
}

-(void)hideMenuToolbar:(BOOL)animated{
    
    float screenWidth  = (isShowingLandscapeView?SCREEN_WIDTH:SCREEN_HEIGHT);
//    float screenHeight = (isShowingLandscapeView?SCREEN_HEIGHT:SCREEN_WIDTH);
    
    if( animated ){
        
        //slide the content view to the right to reveal the menu
        [UIView animateWithDuration:.25
                         animations:^{
                             
                             [menuToolbar setFrame:CGRectMake(0, screenWidth, menuToolbar.frame.size.width, menuToolbar.frame.size.height)];
                             menuToolbar.alpha = 0;
                         }
         ];
    }else{
        
        [menuToolbar setFrame:CGRectMake(0, screenWidth, menuToolbar.frame.size.width, menuToolbar.frame.size.height)];
        menuToolbar.alpha = 0;
    }
    
    showMenuToolbar = NO;
}

-(void)toggleMenuToolbar:(id)sender {
    
    if( !isShowingLandscapeView )
        return;
    
    if( showMenuToolbar )
        [self hideMenuToolbar:YES];
    else
        [self showMenuToolbar:YES];
}

- (void)previousLevel:(id)sender {
    
    [super previousLevel:sender];
    
    if( blindSet.currentLevel==1 )
        btnPreviousLevelLocal.enabled = NO;
    else
        btnPreviousLevelLocal.enabled = YES;
    
    if( blindSet.blindLevels > 1 )
        btnNextLevelLocal.enabled = YES;
    else
        btnNextLevelLocal.enabled = NO;
}

- (void)nextLevel:(id)sender {
    
    if( btnNextLevelLocal.enabled==NO ){
        
        if( timerEnabled )
            timerFinished = YES;
        return;
    }
    
    [super nextLevel:sender];
    
    if( blindSet.currentLevel==blindSet.blindLevels )
        btnNextLevelLocal.enabled = NO;
    else
        btnNextLevelLocal.enabled = YES;
    
    NSLog(@"Passou por aqui");
    if( blindSet.currentLevel > 1 )
        btnPreviousLevelLocal.enabled = YES;
    else
        btnPreviousLevelLocal.enabled = NO;
}

- (void)resetTimer:(id)sender {
    
    NSLog(@"resetTimer");
    [super resetTimer:sender];
    
    btnPreviousLevelLocal.enabled = NO;
    btnNextLevelLocal.enabled     = YES;
}

-(void)startStopTimer:(id)sender {
    
    if( timerEnabled )
        [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController")];
    else
        [btnTimerSwitch setTitle:NSLocalizedString(@"PAUSE", @"TimerViewController")];
    
    [super startStopTimer:sender];
}

- (void)awakeFromNib {
    
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    
    float delta = (appDelegate.isIOS7?0:15);
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if( deviceOrientation==UIDeviceOrientationPortraitUpsideDown )
        return;
    
    if (UIDeviceOrientationIsPortrait(deviceOrientation) ) {
        
        delta = delta*1.25;
        
        isShowingLandscapeView = NO;
        
        delta += 7;
        
        lblTimer.frame               = CGRectMake(20, 20-delta, 280, 95);
        timerSlider.frame            = CGRectMake(15, 108-delta, 287, timerSlider.frame.size.height);
        
        lblSmallBlind.frame          = CGRectMake(21, 157-delta, 130, 50);
        lblBigBlind.frame            = CGRectMake(169, 157-delta, 130, 50);
        lblCurrentLevel.frame        = CGRectMake(21, 252-delta, 130, 50);
        lblAnte.frame                = CGRectMake(169, 252-delta, 130, 50);
        
        lblCurrentSmallBlind.frame   = CGRectMake(17, 211-delta, 139, 18);
        lblCurrentBigBlind.frame     = CGRectMake(165, 211-delta, 139, 18);
        lblCurrentLevelLabel.frame   = CGRectMake(17, 306-delta, 139, 18);
        lblCurrentAnte.frame         = CGRectMake(165, 306-delta, 139, 18);
        
        imgSmallBlindBg.frame      = CGRectMake(11, 149-delta, 150, 87);
        imgBigBlindBg.frame        = CGRectMake(159, 149-delta, 150, 87);
        imgCurrentLevelBg.frame    = CGRectMake(11, 244-delta, 150, 87);
        imgAnteBg.frame            = CGRectMake(159, 244-delta, 150, 87);
        
        lblElapsedTime.frame       = CGRectMake(82, 339-delta, 156, 60);
        lblElapsedTimeLabel.frame  = CGRectMake(70, 401-delta, 180, 18);
        lblNextBreak.frame         = CGRectMake(82, 434-delta, 156, 60);
        lblNextBreakLabel.frame    = CGRectMake(70, 496-delta, 180, 18);
        
        imgElapsedTimeBg.frame     = CGRectMake(64, 339-delta, 192, 87);
        imgNextBreakBg.frame       = CGRectMake(64, 434-delta, 192, 87);
        
        btnSettings.frame          = CGRectMake(264, 459-delta, 48, 48);
        
        if( IS_4_INCHES ){
            
            NSLog(@"Passou por aqui PORTRAIT 4 INCHES");
            
            imgCurrentLevelBg.image = [UIImage imageNamed:@"blind-time-bg.png"];
            imgNextBreakBg.image    = [UIImage imageNamed:@"blind-time-bg.png"];
        }else{
            
            NSLog(@"Passou por aqui PORTRAIT 3.5 INCHES");
            
            btnSettings.frame          = CGRectMake(136, 310-delta, 48, 48);
            lblElapsedTime.frame       = CGRectMake(21, 342-delta, 130, 60);
            lblElapsedTimeLabel.frame  = CGRectMake(17, 401-delta, 139, 18);
            lblNextBreak.frame         = CGRectMake(170, 342-delta, 130, 60);
            lblNextBreakLabel.frame    = CGRectMake(165, 401-delta, 139, 18);
            imgElapsedTimeBg.frame     = CGRectMake(11, 339-delta, 151, 87);
            imgNextBreakBg.frame       = CGRectMake(159, 339-delta, 150, 87);
            
            imgCurrentLevelBg.image = [UIImage imageNamed:@"blind-level-bg.png"];
            imgNextBreakBg.image    = [UIImage imageNamed:@"blind-level-bg.png"];
        }
        
        lblCurrentLevelLabel.hidden = NO;
        
        timerBgImageName    = @"iphone-timer-blue-bg-portrait.png";
        timerBgRedImageName = @"iphone-timer-red-bg-portrait.png";
        
        [imgCurrentLevelBg setImage:[UIImage imageNamed:@"blind-level-bg.png"]];
        
        [self performSelector:@selector(showMenuToolbar:) withObject:self afterDelay:0.1];
    }else if( UIDeviceOrientationIsLandscape(deviceOrientation) ){

        isShowingLandscapeView = YES;
        
        lblTimer.frame               = CGRectMake(138, 5-delta, 292, 95);
        timerSlider.frame            = CGRectMake(18, 85-delta, 532, timerSlider.frame.size.height);
        
        lblSmallBlind.frame          = CGRectMake(29, 134-delta, 139, 50);
        lblBigBlind.frame            = CGRectMake(215, 134-delta, 139, 50);
        lblAnte.frame                = CGRectMake(397, 134-delta, 139, 50);
        
        lblCurrentSmallBlind.frame   = CGRectMake(29, 188-delta, 139, 18);
        lblCurrentBigBlind.frame     = CGRectMake(215, 188-delta, 139, 18);
        lblCurrentAnte.frame         = CGRectMake(397, 188-delta, 139, 18);
        
        lblCurrentLevel.frame      = CGRectMake(249, 230-delta, 70, 70);
        lblCurrentLevelLabel.frame = CGRectMake(220, 151-delta, 128, 18);
        
        imgSmallBlindBg.frame      = CGRectMake(20, 126-delta, 163, 87);
        imgBigBlindBg.frame        = CGRectMake(203, 126-delta, 163, 87);
        imgAnteBg.frame            = CGRectMake(385, 126-delta, 163, 87);
        imgCurrentLevelBg.frame    = CGRectMake(249, 230-delta, 70, 70);
        
        lblElapsedTime.frame       = CGRectMake(38, 224-delta, 156, 60);
        lblElapsedTimeLabel.frame  = CGRectMake(20, 283-delta, 192, 18);
        lblNextBreak.frame         = CGRectMake(374, 224-delta, 156, 60);
        lblNextBreakLabel.frame    = CGRectMake(356, 283-delta, 192, 18);
        
        imgElapsedTimeBg.frame     = CGRectMake(20, 221-delta, 192, 87);
        imgNextBreakBg.frame       = CGRectMake(356, 221-delta, 192, 87);
        
        btnSettings.frame          = CGRectMake(502, 20-(delta*0.5), 48, 48);
        
        if( IS_4_INCHES ){
            
            NSLog(@"Passou por aqui LANDSCAPE 4 INCHES");
            
            imgCurrentLevelBg.image = [UIImage imageNamed:@"blind-time-bg.png"];
            imgNextBreakBg.image    = [UIImage imageNamed:@"blind-time-bg.png"];
        }else{
            
            NSLog(@"Passou por aqui LANDSCAPE 3.5 INCHES");
            
            lblTimer.frame             = CGRectMake(94, 5-delta, 292, 95);
            timerSlider.frame          = CGRectMake(18, 85-delta, 444, 34);
            
            lblSmallBlind.frame        = CGRectMake(23, 134-delta, 130, 50);
            lblBigBlind.frame          = CGRectMake(175, 134-delta, 130, 50);
            lblCurrentLevel.frame      = CGRectMake(205, 230-delta, 70, 70);
            lblAnte.frame              = CGRectMake(328, 134-delta, 130, 50);
            
            lblCurrentSmallBlind.frame = CGRectMake(23, 188-delta, 130, 18);
            lblCurrentBigBlind.frame   = CGRectMake(175, 188-delta, 130, 18);
            lblCurrentLevelLabel.frame = CGRectMake(220, 151-delta, 128, 18);
            lblCurrentAnte.frame       = CGRectMake(328, 188-delta, 130, 18);
            
            imgSmallBlindBg.frame      = CGRectMake(13, 126-delta, 150, 87);
            imgBigBlindBg.frame        = CGRectMake(165, 126-delta, 150, 87);
            imgAnteBg.frame            = CGRectMake(318, 126-delta, 150, 87);
            imgCurrentLevelBg.frame    = CGRectMake(205, 230-delta, 70, 70);
            
            lblElapsedTime.frame       = CGRectMake(24, 224-delta, 130, 60);
            lblElapsedTimeLabel.frame  = CGRectMake(23, 283-delta, 130, 18);
            lblNextBreak.frame         = CGRectMake(328, 224-delta, 130, 60);
            lblNextBreakLabel.frame    = CGRectMake(328, 283-delta, 130, 18);
            
            imgElapsedTimeBg.frame     = CGRectMake(13, 221-delta, 150, 87);
            imgNextBreakBg.frame       = CGRectMake(318, 221-delta, 150, 87);
            
            btnSettings.frame          = CGRectMake(412, 20-(delta*0.5), 48, 48);
            
            imgCurrentLevelBg.image = [UIImage imageNamed:@"blind-level-bg.png"];
            imgNextBreakBg.image    = [UIImage imageNamed:@"blind-level-bg.png"];
        }
        
        lblCurrentLevelLabel.hidden  = YES;
        
        timerBgImageName    = @"iphone-timer-blue-bg.png";
        timerBgRedImageName = @"iphone-timer-red-bg.png";
        
        [imgCurrentLevelBg setImage:[UIImage imageNamed:@"iphone-level-circle.png"]];

        [self performSelector:@selector(showMenuToolbar:) withObject:self afterDelay:0.1];
        [self performSelector:@selector(hideMenuToolbarDelayed) withObject:nil afterDelay:1.5];
        
    }
    
    NSLog(@"timerBgImageName: %@", timerBgImageName);
    
    if( timerSlider.value < 10 )
        [imgMainBg setImage:[UIImage imageNamed:timerBgRedImageName]];
    else
        [imgMainBg setImage:[UIImage imageNamed:timerBgImageName]];
}

-(void)hideMenuToolbarDelayed {
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if( UIDeviceOrientationIsLandscape(deviceOrientation) )
        [self hideMenuToolbar:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"blindSet.blindSetId: %i", blindSet.blindSetId);
    
    UINavigationController *nc = segue.destinationViewController;
    ((iPhoneTimerMenuViewController *)nc.viewControllers.firstObject).delegate = self;
}

@end
