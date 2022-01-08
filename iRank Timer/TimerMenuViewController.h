//
//  TimerMenuViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-20.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLevelCell.h"
#import "TimerMenuCell.h"

@interface TimerMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    BlindSet *blindSet;
    BlindLevel *blindLevel;
    
    UIColor *highlightCellTextColor;
    UIColor *cellTextColor;
    UIColor *currentLevelCellBgColor;
    
    IBOutlet UIBarButtonItem *btnEditTimerMenu;
    IBOutlet UIBarButtonItem *btnDoneEditingTimerMenu;
    IBOutlet UINavigationItem *timerMenuNavigationItem;
    IBOutlet UIButton *btnResetButton;
    IBOutlet UINavigationBar *menuNavigationBar;
    
    BOOL isShowingLandscapeView;
}

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) id delegate;

- (IBAction)editBlindSets:(id)sender;
- (IBAction)openCreateMenu:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
