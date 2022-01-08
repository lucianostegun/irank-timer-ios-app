//
//  TimerLevelCell.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerLevelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblSmallBlind;
@property (weak, nonatomic) IBOutlet UILabel *lblBigBlind;
@property (weak, nonatomic) IBOutlet UILabel *lblAnte;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblElapsed;

@end
