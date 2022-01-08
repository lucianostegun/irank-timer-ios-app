//
//  BlindSet.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindLevel.h"
#import "XmlBlindSetParser.h"

@interface BlindSet : NSObject <NSCoding> {
    
}

@property (nonatomic, readwrite) BOOL isNew;
@property (nonatomic, readwrite) int blindSetId;
@property (nonatomic, readwrite) int elapsedSeconds;
@property (nonatomic, readwrite) int currentLevel;
@property (nonatomic, readwrite) int nextBreakRemain;
@property (nonatomic, readwrite) BOOL playSound;
@property (nonatomic, readwrite) BOOL blindChangeAlert;
@property (nonatomic, readwrite) BOOL minuteAlert;
@property (nonatomic, readwrite) BOOL doublePrevious;
@property (nonatomic, readonly) int breaks;
@property (nonatomic, readonly) int levels;
@property (nonatomic, readonly) int seconds;
@property (nonatomic, retain) NSString *blindSetName;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSMutableArray *blindLevelList;

-(void)addBlindLevel:(BlindLevel *)blindLevel;
-(int)blindLevels;
-(BlindLevel*)currentBlindLevel;
-(BlindLevel*)blindLevelByNumber:(int)levelNumber;
-(BlindLevel*)blindLevelByIndex:(int)levelIndex;
-(NSString*)elapsedtime;


-(int)previousLevel;
-(int)nextLevel;
-(int)resetLevels;
-(int)selectLevel:(int)levelNumber;
-(void)resetLevelNumbers;
-(void)updateElapsedTime;
-(void)updateNextBreakRemain;

+ (NSString *)formatTimeString:(int)seconds;
+ (NSMutableArray *)loadBlindSetListByXml:(NSString*)xmlFile;
+ (NSMutableArray *)loadArchivedBlindSetList:(BOOL)archive;
+ (void)archivedBlindSetList:(NSMutableArray*)blindSetList;
+ (NSString *)blindSetArrayPath;

@end
