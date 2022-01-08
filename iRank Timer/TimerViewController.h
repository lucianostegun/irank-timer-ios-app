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

@interface TimerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  AVAudioPlayerDelegate, UIAlertViewDelegate> {
    
    AppDelegate *appDelegate;
    
    BlindSet *blindSet;
    BlindLevel *blindLevel;
    
    int currentElapsedTime;
    
    BOOL timerEnabled;
    BOOL timerStarted;
    BOOL timerFinished;
    
    IBOutlet UITableView *tableViewLevelOverview;
    IBOutlet UIImageView *imgMainBg;
    IBOutlet UILabel *lblSmallBlind;
    IBOutlet UILabel *lblBigBlind;
    IBOutlet UILabel *lblAnte;
    IBOutlet UILabel *lblNextSmallBlind;
    IBOutlet UILabel *lblNextBigBlind;
    IBOutlet UILabel *lblNextAnte;
    IBOutlet UILabel *lblCurrentLevel;
    IBOutlet UILabel *lblElapsedTime;
    IBOutlet UILabel *lblNextBreak;
    IBOutlet UILabel *lblTimer;
    IBOutlet UISlider *timerSlider;
    IBOutlet UIButton *btnTimerSwitch;
    IBOutlet UIButton *btnPreviousLevel;
    IBOutlet UIButton *btnNextLevel;
    IBOutlet UIBarButtonItem *btnEditTimerMenu;
    IBOutlet UIBarButtonItem *btnDoneEditingTimerMenu;
    IBOutlet UINavigationItem *timerMenuNavigationItem;
    IBOutlet UIButton *btnResetButton;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UILabel *lblElapsedTimeLabel;
    IBOutlet UILabel *lblNextBreakLabel;
    IBOutlet UILabel *lblNextLevelLabel;
    IBOutlet UILabel *lblLevelLabel;
    IBOutlet UILabel *lblDurationLabel;
    IBOutlet UILabel *lblElapsedLabel;
    IBOutlet UIBarButtonItem *btnSettings;
    // -------------------
    
    int timeBank;
    IBOutlet UIView *timeBankView;
    IBOutlet UILabel *lblTimeBank;
    
    NSString *backgroundColor;
    
    AVAudioPlayer *audioPlayer;
    int timerPauseSeconds;
    
    UIAlertView *alertView;
    
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIView *content;

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;
- (IBAction)openCreateMenu:(id)sender;
- (IBAction)previousLevel:(id)sender;
- (IBAction)nextLevel:(id)sender;
- (IBAction)startStopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)changeCurrentTime:(id)sender;
- (IBAction)playLevelNotify:(id)sender;
- (IBAction)editBlindSets:(id)sender;
- (IBAction)openConfig:(id)sender;

- (void)startTimeBank:(NSNotification *)notification;

@end
