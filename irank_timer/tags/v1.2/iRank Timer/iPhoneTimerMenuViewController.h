//
//  iPhoneTimerMenuViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-20.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLevelCell.h"
#import "TimerMenuCell.h"

@interface iPhoneTimerMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    
    BlindSet *blindSet;
    BlindLevel *blindLevel;
    
    UIColor *highlightCellTextColor;
    UIColor *cellTextColor;
    UIColor *currentLevelCellBgColor;
    
    IBOutlet UIBarButtonItem *btnEditTimerMenu;
    IBOutlet UIBarButtonItem *btnDoneEditingTimerMenu;
    IBOutlet UIBarButtonItem *btnSettings;
    IBOutlet UINavigationItem *timerMenuNavigationItem;
    IBOutlet UIButton *btnResetButton;
    
    BOOL isShowingLandscapeView;
}

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) id delegate;

- (IBAction)editBlindSets:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
