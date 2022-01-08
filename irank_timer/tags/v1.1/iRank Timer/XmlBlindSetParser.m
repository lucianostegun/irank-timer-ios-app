//
//  XmlBlindSetParser.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "XmlBlindSetParser.h"
#import "BlindSet.h"
#import "BlindLevel.h"

@implementation XmlBlindSetParser

@synthesize blindSet;
@synthesize blindSetList;

- (XmlBlindSetParser *) initXMLParser{
    
    self = [super init];
    
    [self resetBlindSetList];
    
    return self;
}

- (void)parsingDidTimeout {
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Error loading BlindSet list" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
//    NSLog(@"didStartElement");
//    NSLog(@"elementName: %@", elementName);
    
    if( [elementName isEqualToString:@"blindSet"] ){
        
        int blindSetId         = [[attributeDict objectForKey:@"id"] integerValue];
        BOOL playSound         = [[attributeDict objectForKey:@"playSound"] boolValue];
        BOOL blindChangeAlert  = [[attributeDict objectForKey:@"blindChangeAlert"] boolValue];
        BOOL minuteAlert       = [[attributeDict objectForKey:@"minuteAlert"] boolValue];
        BOOL doublePrevious    = [[attributeDict objectForKey:@"doublePrevious"] boolValue];
        NSString *blindSetName = [attributeDict objectForKey:@"name"];
        NSString *duration     = [attributeDict objectForKey:@"duration"];
        
        blindSet = [[BlindSet alloc] init];
        
        blindSet.blindSetId       = blindSetId;
        blindSet.blindSetName     = blindSetName;
        blindSet.duration         = duration;
        blindSet.playSound        = playSound;
        blindSet.blindChangeAlert = blindChangeAlert;
        blindSet.minuteAlert      = minuteAlert;
        blindSet.doublePrevious   = doublePrevious;
        return;
    }
    
    if( [elementName isEqualToString:@"blindLevel"] ){
        
        BlindLevel *blindLevel;
        int isBreak  = [[attributeDict objectForKey:@"isBreak"] boolValue];
        int duration = [[attributeDict objectForKey:@"duration"] integerValue];
        
        if( isBreak ){
            
            blindLevel = [[BlindLevel alloc] initWithDuration:duration isBreak:YES];
        }else{

            int levelNumber = [[attributeDict objectForKey:@"levelNumber"] integerValue];
            int smallBlind  = [[attributeDict objectForKey:@"smallBlind"] integerValue];
            int bigBlind    = [[attributeDict objectForKey:@"bigBlind"] integerValue];
            int ante        = [[attributeDict objectForKey:@"ante"] integerValue];
            
            blindLevel = [[BlindLevel alloc] initWithLevelNumber:levelNumber smallBlind:smallBlind bigBlind:bigBlind ante:ante duration:duration];
        }
        
//        NSLog(@"blindLevel: %@", blindLevel);

        [blindSet addBlindLevel:blindLevel];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
//    NSLog(@"foundCharacters");
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
//    NSLog(@"didEndElement");
    
    if( [elementName isEqualToString:@"blindSets"] )
        return;
    
    if( [elementName isEqualToString:@"blindSet"] ){

        [blindSet updateElapsedTime];
        [blindSet updateNextBreakRemain];
        [blindSetList addObject:blindSet];
        blindSet = nil;
    }else{
    
    }
    
    currentElementValue = nil;
}

- (NSMutableArray *) getBlindSetList {
    
    return blindSetList;
}

- (void) resetBlindSetList {
    
    if( blindSetList )
        blindSetList = nil;
    
    blindSetList = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
