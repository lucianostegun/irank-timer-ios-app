//
//  iPhoneBlindLevelEditViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-25.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindSet.h"
#import "BlindLevel.h"

@interface iPhoneBlindLevelEditViewController : UITableViewController <UITextFieldDelegate> {
    
    IBOutlet UILabel *lblIsBreak;
    IBOutlet UILabel *lblLevel;
    IBOutlet UILabel *lblLevelNumber;
    IBOutlet UILabel *lblSmallBlind;
    IBOutlet UILabel *lblBigBlind;
    IBOutlet UILabel *lblAnte;
    IBOutlet UILabel *lblDuration;
    IBOutlet UILabel *lblMinutes;
    IBOutlet UILabel *lblElapsed;
    IBOutlet UILabel *lblTotalDuration;
    IBOutlet UITextField *txtSmallBlind;
    IBOutlet UITextField *txtBigBlind;
    IBOutlet UITextField *txtAnte;
    IBOutlet UITextField *txtDuration;
    IBOutlet UISwitch *isBreak;
    
    IBOutlet UIBarButtonItem *btnAddBlindLevel;
    IBOutlet UIBarButtonItem *btnPreviousLevel;
    IBOutlet UIBarButtonItem *btnNextLevel;
    IBOutlet UIBarButtonItem *btnAddBlindLevelToolbar;
    IBOutlet UIBarButtonItem *btnPreviousLevelToolbar;
    IBOutlet UIBarButtonItem *btnNextLevelToolbar;
    
    IBOutlet UIToolbar *keyboardToolbar;
    
    UITextField *currentTextField;
}

@property (nonatomic, assign) BlindSet *blindSet;
@property (nonatomic, assign) BlindLevel *blindLevel;

- (IBAction)addBlindLevel:(id)sender;
- (IBAction)deleteLevel:(id)sender;
- (IBAction)switchIsBreak:(id)sender;
- (IBAction)previousLevel:(id)sender;
- (IBAction)nextLevel:(id)sender;

@end
