//
//  BlindLevel.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 05/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import Foundation

@objc(BlindLevel)
class BlindLevel : NSObject, NSCoding {
    
    var levelIndex : Int = 0;
    var levelNumber : Int = 0;
    var smallBlind : Int = 0;
    var bigBlind : Int = 0;
    var ante : Int = 0;
    var duration : Int = 0;
    var seconds : Int = 0;
    var isBreak : Bool = false;
    var elapsedTime : String = "00:00:00";
    
    override init(){
        
        self.levelIndex = 0;
    }

    override func copy() -> AnyObject {
        
        var blindLevel = BlindLevel();
        blindLevel.levelIndex  = self.levelIndex;
        blindLevel.levelNumber = self.levelNumber;
        blindLevel.smallBlind  = self.smallBlind;
        blindLevel.bigBlind    = self.bigBlind;
        blindLevel.ante        = self.ante;
        blindLevel.duration    = self.duration;
        blindLevel.seconds     = self.seconds;
        blindLevel.isBreak     = self.isBreak;
        blindLevel.elapsedTime = self.elapsedTime;
    
        return blindLevel;
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.levelIndex  = Int(aDecoder.decodeIntForKey("levelIndex"));
        self.levelNumber = Int(aDecoder.decodeIntForKey("levelNumber"));
        self.smallBlind  = Int(aDecoder.decodeIntForKey("smallBlind"));
        self.bigBlind    = Int(aDecoder.decodeIntForKey("bigBlind"));
        self.ante        = Int(aDecoder.decodeIntForKey("ante"));
        self.duration    = Int(aDecoder.decodeIntForKey("duration"));
        self.seconds     = Int(aDecoder.decodeIntForKey("seconds"));
        self.isBreak     = aDecoder.decodeBoolForKey("isBreak");
        self.elapsedTime = aDecoder.decodeObjectForKey("elapsedTime") as! String;
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInt(Int32(self.levelIndex), forKey:"levelIndex");
        aCoder.encodeInt(Int32(self.levelNumber), forKey:"levelNumber");
        aCoder.encodeInt(Int32(self.smallBlind), forKey:"smallBlind");
        aCoder.encodeInt(Int32(self.bigBlind), forKey:"bigBlind");
        aCoder.encodeInt(Int32(self.ante), forKey:"ante");
        aCoder.encodeInt(Int32(self.duration), forKey:"duration");
        aCoder.encodeInt(Int32(self.seconds), forKey:"seconds");
        aCoder.encodeBool(self.isBreak, forKey:"isBreak");
        aCoder.encodeObject(self.elapsedTime, forKey:"elapsedTime");
    }
}