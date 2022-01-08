//
//  TimerMenuCell.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerMenuCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UILabel *lblBlindSetName;
@property (weak, nonatomic) IBOutlet UILabel *lblLevels;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblBreaks;

@end
