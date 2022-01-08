//
//  BlindLevel.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlindLevel : NSObject <NSCoding> {
    
}

@property (nonatomic, readwrite) int levelNumber;
@property (nonatomic, readwrite) int smallBlind;
@property (nonatomic, readwrite) int bigBlind;
@property (nonatomic, readwrite) int ante;
@property (nonatomic, readwrite) int duration;
@property (nonatomic, readwrite) int seconds;
@property (nonatomic, readwrite) BOOL isBreak;
@property (nonatomic, retain) NSString *elapsedTime;

-(id)initWithLevelNumber:(int)levelNumber smallBlind:(int)smallBlind bigBlind:(int)bigBlind ante:(int)ante duration:(int)duration;
-(id)initWithDuration:(int)duration isBreak:(int)isBreak;

@end
