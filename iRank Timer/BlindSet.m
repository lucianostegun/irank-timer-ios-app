//
//  BlindSet.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-22.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "BlindSet.h"

@implementation BlindSet
@synthesize blindSetId;
@synthesize blindSetIndex;
@synthesize duration;
@synthesize blindSetName;
@synthesize blindLevelList;
@synthesize currentLevel;
@synthesize elapsedSeconds;
@synthesize nextBreakRemain;
@synthesize breaks;
@synthesize levels;
@synthesize isNew;
@synthesize playSound;
@synthesize blindChangeAlert;
@synthesize minuteAlert;
@synthesize doublePrevious;
@synthesize seconds;

-(id)init {
    
    self = [super init];
    
    blindLevelList = [[NSMutableArray alloc] init];
    currentLevel   = 1;
    elapsedSeconds = 0;
    levels         = 0;
    breaks         = 0;
    
    playSound        = YES;
    blindChangeAlert = YES;
    minuteAlert      = YES;
    doublePrevious   = YES;
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    BlindSet *copy = [[BlindSet alloc] init];
    
    if( copy ){
        
        [copy setBlindSetId:         self.blindSetId];
        [copy setBlindSetIndex:      self.blindSetIndex];
        [copy setElapsedSeconds:     self.elapsedSeconds];
        [copy setCurrentLevel:       self.currentLevel];
        [copy setNextBreakRemain:    self.nextBreakRemain];
        [copy setPlaySound:          self.playSound];
        [copy setBlindChangeAlert:   self.blindChangeAlert];
        [copy setMinuteAlert:        self.minuteAlert];
        [copy setDoublePrevious:     self.doublePrevious];
        [copy setBlindSetName:       self.blindSetName];
        [copy setDuration:           self.duration];
        [copy setBlindLevelList:     [[NSMutableArray alloc] init]];
        [copy setBreaks:             self.breaks];
        [copy setLevels:             self.levels];
        [copy setSeconds:            self.seconds];
        
        for( BlindLevel *blindLevel in self.blindLevelList )
            [copy.blindLevelList addObject:[blindLevel copy]];
    }
    
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeBool:isNew forKey:@"isNew"];
    [encoder encodeInt:blindSetId forKey:@"blindSetId"];
    [encoder encodeInt:blindSetIndex forKey:@"blindSetIndex"];
    [encoder encodeInt:elapsedSeconds forKey:@"elapsedSeconds"];
    [encoder encodeInt:currentLevel forKey:@"currentLevel"];
    [encoder encodeInt:nextBreakRemain forKey:@"nextBreakRemain"];
    [encoder encodeBool:playSound forKey:@"playSound"];
    [encoder encodeBool:blindChangeAlert forKey:@"blindChangeAlert"];
    [encoder encodeBool:minuteAlert forKey:@"minuteAlert"];
    [encoder encodeBool:doublePrevious forKey:@"doublePrevious"];
    [encoder encodeInt:breaks forKey:@"breaks"];
    [encoder encodeInt:levels forKey:@"levels"];
    [encoder encodeInt:seconds forKey:@"seconds"];
    [encoder encodeObject:blindSetName forKey:@"blindSetName"];
    [encoder encodeObject:duration forKey:@"duration"];
    [encoder encodeObject:blindLevelList forKey:@"blindLevelList"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    isNew = NO;
    
    [self setBlindSetId:         [decoder decodeIntForKey:@"blindSetId"]];
    [self setBlindSetIndex:      [decoder decodeIntForKey:@"blindSetIndex"]];
    [self setElapsedSeconds:     [decoder decodeIntForKey:@"elapsedSeconds"]];
    [self setCurrentLevel:       [decoder decodeIntForKey:@"currentLevel"]];
    [self setNextBreakRemain:    [decoder decodeIntForKey:@"nextBreakRemain"]];
    [self setPlaySound:          [decoder decodeBoolForKey:@"playSound"]];
    [self setBlindChangeAlert:   [decoder decodeBoolForKey:@"blindChangeAlert"]];
    [self setMinuteAlert:        [decoder decodeBoolForKey:@"minuteAlert"]];
    [self setDoublePrevious:     [decoder decodeBoolForKey:@"doublePrevious"]];
    [self setBlindSetName:       [decoder decodeObjectForKey:@"blindSetName"]];
    [self setDuration:           [decoder decodeObjectForKey:@"duration"]];
    [self setBlindLevelList:     [decoder decodeObjectForKey:@"blindLevelList"]];

    breaks  = [decoder decodeIntForKey:@"breaks"];
    levels  = [decoder decodeIntForKey:@"levels"];
    seconds = [decoder decodeIntForKey:@"seconds"];
    
    return self;
}

-(void)addBlindLevel:(BlindLevel*)blindLevel {

    if( blindLevel.isBreak )
        breaks++;
    else
        levels++;
    
    seconds += blindLevel.seconds;
    
    [blindLevelList addObject:blindLevel];
}

-(int)blindLevels {
    
    return blindLevelList.count;
}

-(BlindLevel*)blindLevelByNumber:(int)levelNumber {
    
    for(BlindLevel *blindLevel in blindLevelList)
        if( blindLevel.levelNumber==levelNumber )
            return blindLevel;
        
    return nil;
}

-(BlindLevel*)blindLevelByIndex:(int)levelIndex {
    
    if( levelIndex > self.blindLevels-1 ){
        
        currentLevel = self.blindLevels;
        levelIndex   = currentLevel-1;
    }
    
    return (BlindLevel *)[blindLevelList objectAtIndex:levelIndex];
}

-(BlindLevel *)currentBlindLevel {
    
    return [self blindLevelByIndex:currentLevel-1];
}

-(void)updateElapsedTime {
    
    int elapsedTime = 0;
    
    for(BlindLevel *blindLevel in blindLevelList){
        
        elapsedTime += blindLevel.seconds;
        
        blindLevel.elapsedTime = [BlindSet formatTimeString:elapsedTime];
    }
}

-(int)previousLevel {
    
    if( currentLevel > 1 )
        elapsedSeconds -= [[self blindLevelByIndex:currentLevel-2] seconds];

    currentLevel = currentLevel - 1;
    
    if( currentLevel <= 0 )
        currentLevel = 1;
    
    [self updateNextBreakRemain];
    
    return currentLevel;
}

-(int)nextLevel {

    if( currentLevel < self.blindLevels )
        elapsedSeconds += [[self currentBlindLevel] seconds];
    
    currentLevel = currentLevel+1;
    
    if( currentLevel > self.blindLevels )
        currentLevel = self.blindLevels;
    
    [self updateNextBreakRemain];
    
    return currentLevel;
}

-(int)resetLevels {
    
    currentLevel   = 1;
    elapsedSeconds = 0;
    [self updateNextBreakRemain];
    
    return currentLevel;
}

-(NSString *)elapsedtime {
    
    if( currentLevel > 1 ){
        
        BlindLevel *aBlindLevel = [self blindLevelByIndex:currentLevel-2];
        return [aBlindLevel elapsedTime];
    }
    
    return @"00:00:00";
}

+(NSString *)formatTimeString:(int)seconds {
    
    int hours   = floor(seconds/3600);
    seconds    -= (hours*3600);
    int minutes = floor(seconds/60);
    seconds    -= (minutes*60);
    
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

-(void)updateNextBreakRemain {
    
    int nextBreak   = 0;
    BOOL hasBreak   = NO;
    BOOL isBreakNow = self.currentBlindLevel.isBreak;
    
    int levelNumber = 0;
    for(BlindLevel *blindLevel in blindLevelList){
        
        levelNumber++;
        
        if( levelNumber < currentLevel )
            continue;
        
        if( blindLevel.isBreak && (!isBreakNow || levelNumber > currentLevel) ){
            
            hasBreak = YES;
            break;
        }
        
        nextBreak += blindLevel.seconds;
    }
    
    if( hasBreak )
        nextBreakRemain = nextBreak;
    else
        nextBreakRemain = -1;
}

-(void)resetLevelNumbers {
    
    int durationSeconds = 0;
    int levelNumber     = 0;
    int levelIndex      = 0;
    levels = 0;
    breaks = 0;
    
    for(BlindLevel *blindLevel in blindLevelList){
        
        durationSeconds += blindLevel.seconds;
        
        blindLevel.elapsedTime = [BlindSet formatTimeString:durationSeconds];
        blindLevel.levelIndex  = levelIndex++;
        
        if( blindLevel.isBreak ){
            
            breaks++;
            continue;
        }
        
        levels++;
        
        levelNumber++;
        blindLevel.levelNumber = levelNumber;
    }
    
    self.duration = [BlindSet formatTimeString:durationSeconds];
    seconds       = durationSeconds;
}

+ (NSMutableArray *)loadBlindSetListByXml:(NSString*)xmlFile {
    
    XmlBlindSetParser *blindSetParser = [[XmlBlindSetParser alloc] initXMLParser];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:xmlFile ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:filePath];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:blindSetParser];
    [parser setShouldProcessNamespaces:YES];
    [parser setShouldReportNamespacePrefixes:YES];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    return [blindSetParser getBlindSetList];
}

+ (NSMutableArray *)loadArchivedBlindSetList:(BOOL)archive {
    
    NSString *blindSetListPath = [BlindSet blindSetArrayPath];
    
    NSMutableArray *blindSetList;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL fileExists = [manager fileExistsAtPath:blindSetListPath];
    
    if( fileExists )
        blindSetList = [NSKeyedUnarchiver unarchiveObjectWithFile:blindSetListPath];
    else{
     
        blindSetList = [BlindSet loadBlindSetListByXml:(LITE_VERSION?@"startupBlindSets-lite":@"startupBlindSets")];
        
        // Se o arquivo ainda não existir
        if( archive )
           [BlindSet archivedBlindSetList: blindSetList];
    }
    
    // Se for a versão free corta a lista deixando apenas o primeiro
    if( LITE_VERSION )
        blindSetList = [NSMutableArray arrayWithObject:blindSetList.firstObject];
    
    return blindSetList;
}

+ (NSString *)blindSetArrayPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"customBlindSetList.data"];
}

+ (void)archivedBlindSetList:(NSMutableArray*)blindSetList {

    NSString *blindSetListPath = [BlindSet blindSetArrayPath];
    [NSKeyedArchiver archiveRootObject:blindSetList toFile:blindSetListPath];
}

-(NSString *)description {
    
    return [NSString stringWithFormat:@"#%i (%i): %@, L:%i B:%i D:%@", blindSetId, blindSetIndex, blindSetName, levels, breaks, duration];
}

@end
