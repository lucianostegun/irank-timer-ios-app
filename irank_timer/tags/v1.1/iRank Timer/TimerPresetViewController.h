//
//  TimerPresetViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-27.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerPresetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
 
    NSArray *microStackList;
    NSArray *regularStackList;
    NSArray *deepStackList;
    
    IBOutlet UITableView *microStackTableView;
    IBOutlet UITableView *regularStackTableView;
    IBOutlet UITableView *deepStackTableView;
    
    UIColor *headerColor;
    
    IBOutlet UILabel *lblMicroStack;
    IBOutlet UILabel *lblMediumStack;
    IBOutlet UILabel *lblDeepStack;
}

@end
