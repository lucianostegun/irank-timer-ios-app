//
//  iPadTimerViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-16.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerViewController.h"

@interface iPadTimerViewController : TimerViewController <UITableViewDataSource, UITableViewDelegate> {
 
    IBOutlet UITableView *tableViewLevelOverview;
    IBOutlet UILabel *lblNextSmallBlind;
    IBOutlet UILabel *lblNextBigBlind;
    IBOutlet UILabel *lblNextAnte;
    IBOutlet UIBarButtonItem *btnEditTimerMenu;
    IBOutlet UIBarButtonItem *btnDoneEditingTimerMenu;
    IBOutlet UINavigationItem *timerMenuNavigationItem;
    IBOutlet UIButton *btnResetButton;
    IBOutlet UINavigationBar *menuNavigationBar;
    
    UIButton *btnTimerSwitchLocal;
    UIButton *btnPreviousLevelLocal;
    UIButton *btnNextLevelLocal;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UIBarButtonItem *btnSettings;
    // -------------------
}

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIView *content;

- (void)showMenu:(BOOL)animated;
- (void)hideMenu:(BOOL)animated;
- (IBAction)editBlindSets:(id)sender;

@end
