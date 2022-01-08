//
//  TimerMenuCell.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerMenuCell.h"

@implementation TimerMenuCell
@synthesize lblBlindSetName;
@synthesize lblLevels;
@synthesize lblDuration;
@synthesize lblBreaks;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
