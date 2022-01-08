//
//  XmlBlindSetParser.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 19/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class XmlBlindSetParser: NSObject, NSXMLParserDelegate {

    var currentElementValue : String!;
    var blindSetId : Int! = 0;
    var foundFirst : Bool = false;
    var blindSet : BlindSet!;
    var blindSetList : Array<BlindSet>!;
    
    override init() {

        super.init();
        
        self.resetBlindSetList()
    }
    
    func parsingDidTimeout(){
        
        println("Error loading BlindSet list");
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        if( elementName == nil || foundFirst ){
            
            return;
        }
        
        if( elementName == "blindSet" ){
            
            var blindSetId : Int         = (attributeDict["id"] as! String).toInt()!;
            let playSound : Bool         = Bool((attributeDict["playSound"] as! String).toInt()!);
            let blindChangeAlert : Bool  = Bool((attributeDict["blindChangeAlert"] as! String).toInt()!);
            let lastMinuteAlert : Bool   = Bool((attributeDict["lastMinuteAlert"] as! String).toInt()!);
            let doublePrevious : Bool    = Bool((attributeDict["doublePrevious"] as! String).toInt()!);
            let blindSetName : String = attributeDict["name"] as! String;
            let duration : String     = attributeDict["duration"] as! String;
            
            blindSet = BlindSet();
            
            blindSet.blindSetId       = blindSetId;
            blindSet.blindSetName     = blindSetName;
            blindSet.duration         = duration;
            blindSet.playSound        = playSound;
            blindSet.blindChangeAlert = blindChangeAlert;
            blindSet.lastMinuteAlert  = lastMinuteAlert;
            blindSet.doublePrevious   = doublePrevious;
            return;
        }
        
        if( elementName == "blindLevel" ){
            
            var blindLevel : BlindLevel;
            let isBreak : Bool = Bool((attributeDict["isBreak"] as! String).toInt()!);
            let duration : Int = (attributeDict["duration"] as! String).toInt()!;
            let elapsedTime : String = (attributeDict["elapsedTime"] as! String!)

            blindLevel = BlindLevel();
            blindLevel.isBreak     = isBreak;
            blindLevel.duration    = duration*60;
            blindLevel.elapsedTime = elapsedTime
            
            if( !isBreak ){
                
                let levelNumber : Int    = (attributeDict["levelNumber"] as! String).toInt()!;
                let smallBlind : Int     = (attributeDict["smallBlind"] as! String).toInt()!
                let bigBlind : Int       = (attributeDict["bigBlind"] as! String).toInt()!
                let ante : Int           = (attributeDict["ante"] as! String).toInt()!
                
                blindLevel.levelNumber = levelNumber
                blindLevel.smallBlind  = smallBlind
                blindLevel.bigBlind    = bigBlind
                blindLevel.ante        = ante
            }
            
            blindSet.addBlindLevel(blindLevel);
            return;
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        if( foundFirst ){
            
            return;
        }
        
        if( currentElementValue == nil ){

            currentElementValue = string;
        }else{
        
            currentElementValue = currentElementValue+string;
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if( elementName == nil || elementName == "blindSets" || foundFirst ){
            
            return;
        }
        
        if( elementName == "blindSet" ){
            
            blindSet.updateMetadata();

            blindSet.blindSetIndex = blindSetList.count;
            blindSetList.append(blindSet);
            
            if( blindSet.blindSetId == self.blindSetId ){
                
                foundFirst = true;
            }else{
                
                blindSet = nil;
            }
        }
        
        currentElementValue = nil;
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {

    }
    
    func getBlindSetList() -> Array<BlindSet> {
        
        return blindSetList;
    }
    
    func resetBlindSetList() {
    
        if( blindSetList != nil ){
            
            blindSetList = nil;
        }
    
        blindSetList = [];
    }
}