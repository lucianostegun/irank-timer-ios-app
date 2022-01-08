//
//  TimerViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-19.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindSet.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "TimerEditViewController.h"

@interface TimerViewController : UIViewController <AVAudioPlayerDelegate, UIAlertViewDelegate> {
    
    BlindLevel *blindLevel;
    BlindSet *blindSet;
    
    int currentElapsedTime;
    
    NSString *timerBgImageName;
    NSString *timerBgRedImageName;
    
    UIColor *timerTextColor;
    UIColor *timerShadowColor;
    UIColor *timerWarningShadowColor;
    UIColor *warningColor;
    UIColor *highlightCellTextColor;
    UIColor *cellTextColor;
    UIColor *currentLevelCellBgColor;
    
    BOOL timerEnabled;
    BOOL timerStarted;
    BOOL timerFinished;
    
    IBOutlet UIImageView *imgMainBg;
    IBOutlet UILabel *lblSmallBlind;
    IBOutlet UILabel *lblBigBlind;
    IBOutlet UILabel *lblAnte;
    IBOutlet UILabel *lblCurrentLevel;
    IBOutlet UILabel *lblElapsedTime;
    IBOutlet UILabel *lblNextBreak;
    IBOutlet UILabel *lblTimer;
    IBOutlet UISlider *timerSlider;
    IBOutlet UIToolbar *menuToolbar;
    IBOutlet UIImageView *imgHand;
    
    IBOutlet id btnTimerSwitch;
    IBOutlet id btnPreviousLevel;
    IBOutlet id btnNextLevel;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UILabel *lblCurrentSmallBlind;
    IBOutlet UILabel *lblCurrentBigBlind;
    IBOutlet UILabel *lblCurrentAnte;
    IBOutlet UILabel *lblElapsedTimeLabel;
    IBOutlet UILabel *lblNextBreakLabel;
    IBOutlet UILabel *lblNextLevelLabel;
    IBOutlet UILabel *lblLevelLabel;
    IBOutlet UILabel *lblSmallBlindLabel;
    IBOutlet UILabel *lblBigBlindLabel;
    IBOutlet UILabel *lblAnteLabel;
    IBOutlet UILabel *lblElapsedLabel;
    IBOutlet UILabel *lblDurationLabel;
    // -------------------
    
    NSString *backgroundColor;
    
    AVAudioPlayer *audioPlayer;
    int timerPauseSeconds;
    
    UIAlertView *alertView;
    
    NSTimer *timer;
}

- (void)localizeView;
- (void)invalidateTimer;
- (BOOL)openCreateMenu;
- (IBAction)openCreateMenu:(id)sender;
- (IBAction)previousLevel:(id)sender;
- (IBAction)nextLevel:(id)sender;
- (IBAction)startStopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (void)resetTimer;
- (IBAction)changeCurrentTime:(id)sender;
- (IBAction)openConfig:(id)sender;
- (void)updateCurrentLevel;

- (void)setBlindSet:(BlindSet*)aBlindSet;
- (void)updateBackground;
    
@end
