//
//  BlindLevel.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "BlindLevel.h"

@implementation BlindLevel
@synthesize levelIndex;
@synthesize levelNumber;
@synthesize smallBlind;
@synthesize bigBlind;
@synthesize ante;
@synthesize duration;
@synthesize seconds;
@synthesize elapsedTime;
@synthesize isBreak;

-(id)initWithLevelNumber:(int)pLevelNumber levelIndex:(int)pLevelIndex smallBlind:(int)pSmallBlind bigBlind:(int)pBigBlind ante:(int)pAnte duration:(int)pDuration {
    
    self = [super init];
    
    self.levelIndex  = pLevelIndex;
    self.levelNumber = pLevelNumber;
    self.smallBlind  = pSmallBlind;
    self.bigBlind    = pBigBlind;
    self.ante        = pAnte;
    self.duration    = pDuration;
    self.isBreak     = NO;
    self.seconds     = duration*60;
    
    return self;
}

-(id)initWithDuration:(int)pDuration isBreak:(int)pIsBreak levelIndex:(int)pLevelIndex {
    
    self = [super init];
    
    self.levelIndex  = pLevelIndex;
    self.levelNumber = 0;
    self.smallBlind  = 0;
    self.bigBlind    = 0;
    self.ante        = 0;
    self.duration    = pDuration;
    self.isBreak     = pIsBreak;
    self.seconds     = duration*60;
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    
    BlindLevel *copy = [[BlindLevel alloc] init];
    
    if( copy ){
        
        [copy setLevelIndex:  self.levelIndex];
        [copy setLevelNumber: self.levelNumber];
        [copy setSmallBlind:  self.smallBlind];
        [copy setBigBlind:    self.bigBlind];
        [copy setAnte:        self.ante];
        [copy setDuration:    self.duration];
        [copy setSeconds:     self.seconds];
        [copy setIsBreak:     self.isBreak];
        [copy setElapsedTime: self.elapsedTime];
    }
    
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInt:levelIndex forKey:@"levelIndex"];
    [encoder encodeInt:levelNumber forKey:@"levelNumber"];
    [encoder encodeInt:smallBlind forKey:@"smallBlind"];
    [encoder encodeInt:bigBlind forKey:@"bigBlind"];
    [encoder encodeInt:ante forKey:@"ante"];
    [encoder encodeInt:duration forKey:@"duration"];
    [encoder encodeInt:seconds forKey:@"seconds"];
    [encoder encodeBool:isBreak forKey:@"isBreak"];
    [encoder encodeObject:elapsedTime forKey:@"elapsedTime"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    [self setLevelIndex:  [decoder decodeIntForKey:@"levelIndex"]];
    [self setLevelNumber: [decoder decodeIntForKey:@"levelNumber"]];
    [self setSmallBlind:  [decoder decodeIntForKey:@"smallBlind"]];
    [self setBigBlind:    [decoder decodeIntForKey:@"bigBlind"]];
    [self setAnte:        [decoder decodeIntForKey:@"ante"]];
    [self setDuration:    [decoder decodeIntForKey:@"duration"]];
    [self setSeconds:     [decoder decodeIntForKey:@"seconds"]];
    [self setIsBreak:     [decoder decodeBoolForKey:@"isBreak"]];
    [self setElapsedTime: [decoder decodeObjectForKey:@"elapsedTime"]];
    
    return self;
}

-(void)setDuration:(int)pDuration {
    
    duration = pDuration;
    seconds  = pDuration*60;
}

-(NSString *)description {
    
    return [NSString stringWithFormat:@"#%i (%i) SB:%i BB:%i - %i (%i)", levelNumber, levelIndex, smallBlind, bigBlind, duration, isBreak];
}

@end
