//
//  XmlBlindSetParser.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlindSet;

@interface XmlBlindSetParser : NSObject <NSXMLParserDelegate> {
    
    NSMutableString *currentElementValue;
    
    BlindSet *blindSet;
    NSMutableArray *blindSetList;
}

@property (nonatomic, retain) BlindSet *blindSet;
@property (nonatomic, copy) NSMutableArray *blindSetList;

- (XmlBlindSetParser *) initXMLParser;
- (NSMutableArray *) getBlindSetList;
- (void) resetBlindSetList;
@end
