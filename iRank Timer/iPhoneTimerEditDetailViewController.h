//
//  iPhoneTimerEditDetailViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerEditDetailViewController.h"

@interface iPhoneTimerEditDetailViewController : TimerEditDetailViewController {
    
    IBOutlet UIBarButtonItem *btnEditLevels;
    IBOutlet UIBarButtonItem *btnDoneEditingLevels;
    IBOutlet UINavigationItem *createMenuNavigationItem;
    
    BlindLevel *blindLevel;
}

- (IBAction)switchEditLevels:(id)sender;

@end
