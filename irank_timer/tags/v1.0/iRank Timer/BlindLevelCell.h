//
//  BlindLevelCell.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlindLevelCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgFieldSeparator1;
@property (weak, nonatomic) IBOutlet UIImageView *imgFieldSeparator2;
@property (weak, nonatomic) IBOutlet UIImageView *imgFieldSeparator3;
@property (weak, nonatomic) IBOutlet UIImageView *imgFieldSeparator4;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UITextField *txtSmallBlind;
@property (weak, nonatomic) IBOutlet UITextField *txtBigBlind;
@property (weak, nonatomic) IBOutlet UITextField *txtAnte;
@property (weak, nonatomic) IBOutlet UITextField *txtDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UISwitch *isBreak;

@end
