//
//  TimerEditMasterViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindSet.h"
#import "TimerEditDetailViewController.h"
#import "iPhoneTimerEditDetailViewController.h"

@interface TimerEditMasterViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    IBOutlet UITextField *txtBlindSetName;
    IBOutlet UISwitch *switchPlaySound;
    IBOutlet UISwitch *switchBlindChangeAlert;
    IBOutlet UISwitch *switchMinuteAlert;
    IBOutlet UISwitch *switchDoublePrevious;
    TimerEditDetailViewController *timerEditDetailViewController;

    // INTERNACIONALIZAÇÃO
    IBOutlet UILabel *lblBlindSetName;
    IBOutlet UILabel *lblPlaySound;
    IBOutlet UILabel *lblMinuteAlert;
    IBOutlet UILabel *lblBlindChangeAlert;
    IBOutlet UILabel *lblDoublePrevious;
    IBOutlet UILabel *lblLevels;
    // -------------------
}

@property (nonatomic, strong) BlindSet *blindSet;

-(IBAction)saveBlindSet:(id)sender;
-(IBAction)dismiss:(id)sender;

@end
