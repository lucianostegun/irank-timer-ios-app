//
//  iPhoneTimerViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-16.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerViewController.h"

@interface iPhoneTimerViewController : TimerViewController {
    
    UIBarButtonItem *btnTimerSwitchLocal;
    UIBarButtonItem *btnPreviousLevelLocal;
    UIBarButtonItem *btnNextLevelLocal;
    
    BOOL isShowingLandscapeView;
    BOOL showMenuToolbar;
    
    IBOutlet UIImageView *imgSmallBlindBg;
    IBOutlet UIImageView *imgBigBlindBg;
    IBOutlet UIImageView *imgAnteBg;
    IBOutlet UIImageView *imgCurrentLevelBg;
    IBOutlet UIImageView *imgElapsedTimeBg;
    IBOutlet UIImageView *imgNextBreakBg;
    IBOutlet UIButton *btnSettings;
    IBOutlet UILabel *lblCurrentLevelLabel;
}

-(void)showMenuToolbar:(BOOL)animated;
-(void)hideMenuToolbar:(BOOL)animated;
-(void)hideMenuToolbarDelayed;
-(IBAction)toggleMenuToolbar:(id)sender;
-(void)resetTimer;

@end
