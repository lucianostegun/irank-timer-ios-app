//
//  TimerEditDetailViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-21.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindSet.h"
#import "BSKeyboardControls.h"
#import "TimerEditViewController.h"
#import "TimerPresetViewController.h"
#import "BlindLevelCell.h"
#import "BlindLevel.h"

@interface TimerEditDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate>{
    
    NSMutableArray *textFieldList;
    NSMutableArray *lblElapsedList;
    BOOL viewLoaded;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UIBarButtonItem *btnNewLevel;
    // -------------------
}

@property (nonatomic, strong) BlindSet *blindSet;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

- (IBAction)addBlindLevel:(id)sender;
- (IBAction)switchLevelBreak:(id)sender;

@end
