//
//  BlindSet.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 05/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

@objc(BlindSet)
class BlindSet : NSObject, NSCoding {
    
    class func appDelegate() -> AppDelegate {
        
        return UIApplication.sharedApplication().delegate as! AppDelegate;
    }
    
    var isNew : Bool = false;
    var blindSetId : Int;
    var blindSetIndex : Int = 0;
    var elapsedSeconds : Int = 0;
    var currentElapsedSeconds : Int = 0;
    var currentLevelIndex : Int = 0;
    var currentLevel : Int = 0; // Legado da versão 1.0
    var nextBreakRemain : Int = 0;
    var playSound : Bool = true;
    var blindChangeAlert : Bool = true;
    var lastMinuteAlert : Bool = true;
    var minuteAlert : Bool = true; // Legado da versão 1.0
    var doublePrevious : Bool = true;
    var breaks : Int = 0;
    var levels : Int = 0;
    var seconds : Int = 0;
    var blindSetName : String = "New blind set";
    var duration : String = "00:00:00";
    var blindLevelList : Array<BlindLevel> = [];
    
    override init(){
        
        self.blindSetId        = 0;
        self.currentLevelIndex = 0;
        self.levels            = 0;
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.isNew = false;
        
        self.blindSetId        = 0;
        self.currentLevelIndex = 0;
        self.levels            = 0;
        
        self.blindSetId            = Int(aDecoder.decodeIntForKey("blindSetId"));
        self.blindSetIndex         = Int(aDecoder.decodeIntForKey("blindSetIndex"));
        self.elapsedSeconds        = Int(aDecoder.decodeIntForKey("elapsedSeconds"));
        self.currentElapsedSeconds = Int(aDecoder.decodeIntForKey("currentElapsedSeconds"));
        self.currentLevelIndex     = Int(aDecoder.decodeIntForKey("currentLevelIndex"));
        self.currentLevel          = Int(aDecoder.decodeIntForKey("currentLevelIndex"));
        self.nextBreakRemain       = Int(aDecoder.decodeIntForKey("nextBreakRemain"));
        self.playSound             = aDecoder.decodeBoolForKey("playSound");
        self.blindChangeAlert      = aDecoder.decodeBoolForKey("blindChangeAlert");
        self.minuteAlert           = aDecoder.decodeBoolForKey("minuteAlert");
        self.lastMinuteAlert       = aDecoder.decodeBoolForKey("lastMinuteAlert");
        self.doublePrevious        = aDecoder.decodeBoolForKey("doublePrevious");
        self.blindSetName          = aDecoder.decodeObjectForKey("blindSetName") as! String;
        self.duration              = aDecoder.decodeObjectForKey("duration") as! String;
        self.blindLevelList        = aDecoder.decodeObjectForKey("blindLevelList") as! Array<BlindLevel>;
        self.breaks                = Int(aDecoder.decodeIntForKey("breaks"));
        self.levels                = Int(aDecoder.decodeIntForKey("levels"));
        self.seconds               = Int(aDecoder.decodeIntForKey("seconds"));
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeBool(self.isNew, forKey:"isNew");
        aCoder.encodeInt(Int32(self.blindSetId), forKey:"blindSetId");
        aCoder.encodeInt(Int32(self.blindSetIndex), forKey:"blindSetIndex");
        aCoder.encodeInt(Int32(self.currentElapsedSeconds), forKey:"currentElapsedSeconds");
        aCoder.encodeInt(Int32(self.elapsedSeconds), forKey:"elapsedSeconds");
        aCoder.encodeInt(Int32(self.currentLevelIndex), forKey:"currentLevelIndex");
        aCoder.encodeInt(Int32(self.nextBreakRemain), forKey:"nextBreakRemain");
        aCoder.encodeBool(self.playSound, forKey:"playSound");
        aCoder.encodeBool(self.blindChangeAlert, forKey:"blindChangeAlert");
        aCoder.encodeBool(self.minuteAlert, forKey:"minuteAlert");
        aCoder.encodeBool(self.lastMinuteAlert, forKey:"lastMinuteAlert");
        aCoder.encodeBool(self.doublePrevious, forKey:"doublePrevious");
        aCoder.encodeInt(Int32(self.breaks), forKey:"breaks");
        aCoder.encodeInt(Int32(self.levels), forKey:"levels");
        aCoder.encodeInt(Int32(self.seconds), forKey:"seconds");
        aCoder.encodeObject(self.blindSetName, forKey:"blindSetName");
        aCoder.encodeObject(self.duration, forKey:"duration");
        aCoder.encodeObject(self.blindLevelList, forKey:"blindLevelList");
    }
    
    override func copy() -> AnyObject {
        
        var blindSet = BlindSet();
        
        blindSet.isNew                 = self.isNew;
        blindSet.blindSetId            = self.blindSetId;
        blindSet.blindSetIndex         = self.blindSetIndex;
        blindSet.currentElapsedSeconds = self.currentElapsedSeconds;
        blindSet.elapsedSeconds        = self.elapsedSeconds;
        blindSet.currentLevelIndex     = self.currentLevelIndex;
        blindSet.nextBreakRemain       = self.nextBreakRemain;
        blindSet.playSound             = self.playSound;
        blindSet.blindChangeAlert      = self.blindChangeAlert;
        blindSet.minuteAlert           = self.minuteAlert;
        blindSet.lastMinuteAlert       = self.lastMinuteAlert;
        blindSet.doublePrevious        = self.doublePrevious;
        blindSet.breaks                = self.breaks;
        blindSet.levels                = self.levels;
        blindSet.seconds               = self.seconds;
        blindSet.blindSetName          = self.blindSetName;
        blindSet.duration              = self.duration;
        blindSet.blindLevelList        = [];
        
        for blindLevel in self.blindLevelList {
            
            blindSet.blindLevelList.append(blindLevel.copy() as! BlindLevel);
        }
        
        return blindSet;
    }
    
    func addBlindLevel(blindLevel : BlindLevel){
        
        self.blindLevelList.append(blindLevel);
        self.updateMetadata();
    }
    
    func updateElapsedSeconds(){
        
        var elapsedTime : Int = 0;
        
        if( self.currentLevelIndex > self.blindLevelList.count-1 ){
            
            self.currentLevelIndex = self.blindLevelList.count-1;
        }
        
        for( var i=0; i < self.currentLevelIndex; i++ ){
            
            elapsedTime += self.blindLevelList[i].duration;
        }
        
        self.elapsedSeconds = elapsedTime;
    }
    
    func getElapsedSeconds(levelIndex : Int) -> Int {
        
        var elapsedTime : Int = 0;
        
        for( var i=0; i < levelIndex; i++ ){
            
            elapsedTime += self.blindLevelList[i].duration;
        }
        
        return elapsedTime;
    }
    
    func updateMetadata(){
        
        var levels   = 0;
        var breaks   = 0;
        var duration = 0;
        
        for( var i = 0; i < self.blindLevelList.count; i++ ){
            
            self.blindLevelList[i].levelIndex = i;
            duration                          = duration + blindLevelList[i].duration;
            
            if( self.blindLevelList[i].isBreak == true ){
                
                ++breaks;
            }else{
                
                ++levels;
                self.blindLevelList[i].levelNumber = levels;
            }
        }
        
        self.levels = levels;
        self.breaks = breaks;
        
        updateElapsedSeconds();
        updateNextBreak();
        
        self.duration = Util.formatTimeString(Float(duration)) as! String;
    }
    
    func updateNextBreak(){
        
        var remainingTime = 0;
        var hasBreak      = false;
        
        for( var i = self.currentLevelIndex; i < self.blindLevelList.count; i++ ){
            
            if( self.blindLevelList[i].isBreak == true && i > self.currentLevelIndex ){
                
                hasBreak = true;
                break;
            }
            
            remainingTime += self.blindLevelList[i].duration;
        }
        
        if( hasBreak ){
            
            self.nextBreakRemain = remainingTime;
        }else{
            
            self.nextBreakRemain = 0;
        }
    }
    
    class func findBlindSetListByXml(fileName : String, blindSetId : Int) -> BlindSet{
        
        var blindSetParser : XmlBlindSetParser = XmlBlindSetParser();
        blindSetParser.blindSetId = blindSetId;
        
        var filePath : String = NSBundle.mainBundle().pathForResource(fileName, ofType: "xml")!;
        var xmlData : NSData = NSData(contentsOfFile: filePath)!;
        
        var parser : NSXMLParser = NSXMLParser(data: xmlData);
        
        parser.delegate = blindSetParser
        parser.shouldProcessNamespaces = true;
        parser.shouldReportNamespacePrefixes = true;
        parser.shouldResolveExternalEntities = false;
        parser.parse();
        
        return blindSetParser.blindSet;
    }
    
    class func loadBlindSetListByXml(fileName : String) -> Array<BlindSet>{
        
        var blindSetParser : XmlBlindSetParser = XmlBlindSetParser();
        
        var filePath : String = NSBundle.mainBundle().pathForResource(fileName, ofType: "xml")!;
        var xmlData : NSData = NSData(contentsOfFile: filePath)!;
        
        var parser : NSXMLParser = NSXMLParser(data: xmlData);
        
        parser.delegate = blindSetParser
        parser.shouldProcessNamespaces = true;
        parser.shouldReportNamespacePrefixes = true;
        parser.shouldResolveExternalEntities = false;
        parser.parse();
        
        return blindSetParser.getBlindSetList();
    }
    
    class func archiveBlindSetList(blindSetList : Array<BlindSet>){
        
        var blindSetListPath = BlindSet.getBlindSetArchivePath();
        var success : Bool = NSKeyedArchiver.archiveRootObject(blindSetList, toFile: blindSetListPath);

        if( success && BlindSet.appDelegate().enableBackup ){
            
            BlindSet.saveiCloudBackup();
        }
    }
    
    class func convertArchivedBlindSetList(){
        
        var paths : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array;
        var documentsDirectory : String = paths[0] as! String;

        var blindSetListPath = "\(documentsDirectory)/customBlindSetList.data";
        
//        println("blindSetListPath: \(blindSetListPath)");
        
        var manager : NSFileManager = NSFileManager.defaultManager();
        var fileExists = manager.fileExistsAtPath(blindSetListPath);
        
        if( !fileExists ){
            
//            println("Arquivo não existe");
            return;
        }
        
        var blindSetOldList : Array<BlindSet> = NSKeyedUnarchiver.unarchiveObjectWithFile(blindSetListPath) as! Array<BlindSet>;
        
        var blindSetList : Array<BlindSet> = [];
        
        for blindSetOld : BlindSet in blindSetOldList {
            
            var blindSet : BlindSet = blindSetOld.copy() as! BlindSet;
            blindSet.currentLevelIndex = blindSetOld.currentLevel;
            blindSet.lastMinuteAlert   = blindSetOld.minuteAlert;

            for( var i = blindSet.currentLevelIndex; i < blindSet.levels; i++ ){
                
                blindSet.blindLevelList[i].duration        = blindSet.blindLevelList[i].duration * 60;
            }
            
            blindSet.updateMetadata();
            
            blindSetList.append(blindSet);
        }
        
        BlindSet.archiveBlindSetList(blindSetList);
    }
    
    class func loadArchivedBlindSetList(archive : Bool) -> Array<BlindSet> {
        
        var blindSetListPath = BlindSet.getBlindSetArchivePath();
        
        var blindSetList : Array<BlindSet> = [];
        var manager : NSFileManager = NSFileManager.defaultManager();
        var fileExists = manager.fileExistsAtPath(blindSetListPath);
        
        if( fileExists ){
            
            blindSetList = NSKeyedUnarchiver.unarchiveObjectWithFile(blindSetListPath) as! Array<BlindSet>;
        }else{

            blindSetList = BlindSet.loadBlindSetListByXml("startupBlindSets");
            
            if( archive ){
            
                BlindSet.archiveBlindSetList(blindSetList);
            }
        }

        return blindSetList;
    }
    
    class func loadArchivedBlindSetList(documentUrl : NSURL, archive: Bool) -> Array<BlindSet>! {
        
        var blindSetListPath : String = documentUrl.path!;
        
        var blindSetList : Array<BlindSet> = [];
        var manager : NSFileManager = NSFileManager.defaultManager();
        var fileExists = manager.fileExistsAtPath(blindSetListPath);
        
        if( fileExists ){
            
            blindSetList = NSKeyedUnarchiver.unarchiveObjectWithFile(blindSetListPath) as! Array<BlindSet>;
            BlindSet.archiveBlindSetList(blindSetList);
            
            return blindSetList;
        }
        
        return nil;
    }
    
    class func getBlindSetArchivePath() -> String {
        
        var paths : Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array;
        var documentsDirectory : String = paths[0] as! String;
        
        return "\(documentsDirectory)/archivedBlindSetList.data";
    }
    
    class func saveiCloudBackup(){
        
        println("Saving data to iCloud: ")
        
        if( !appDelegate().needBackup ){
        
            println("No backup needed")
            return;
        }
        
        var manager : NSFileManager = NSFileManager.defaultManager();
        
        var ubiq : NSURL!;
        ubiq = manager.URLForUbiquityContainerIdentifier(nil);
        
        println("ubiq: \(ubiq)\n-----------------------------------------------------------");
       
        if( ubiq == nil ){
            
            println("Backup no iCloud não habilitado");
            return;
        }
        
        var theError : NSError?;
        var fileExists : Bool   = false;
        var filePath            = BlindSet.getBlindSetArchivePath();
        var backupName : String = "archivedBlindSetList.data";
        
        fileExists = manager.fileExistsAtPath(filePath);
        
        if( !fileExists ){
            
            println("Arquivo fonte para backup no iCloud não existe");
            return;
        }else{

            var deviceName   = appDelegate().device.name;
            var blindSetList = BlindSet.loadArchivedBlindSetList(false);
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd";
            var backupDate   = dateFormatter.stringFromDate(NSDate());

            backupName = "Backup \(backupDate) "+NSLocalizedString("with", comment:"")+" \(blindSetList.count) "+NSLocalizedString("blind set", comment:"")+"\(Util.getPlural(blindSetList.count)) @ \(deviceName)";
            
            var plainData : NSData = backupName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!;
            
            backupName = plainData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros);
            backupName = "\(backupName).data";
            
            println("backupName: \(backupName)");
        }
        
        var sourceUrl      = NSURL(fileURLWithPath: filePath);
        var destinationUrl = ubiq.URLByAppendingPathComponent("Documents", isDirectory: true).URLByAppendingPathComponent(backupName);
        
//        println("destinationUrl: \(destinationUrl)");
        
        fileExists = manager.fileExistsAtPath(destinationUrl.path!);
        
        if( fileExists ){
            
            manager.removeItemAtURL(destinationUrl, error: &theError)
            
            if( theError != nil ){
                
                println("Error removing file to prepare iCloud Backup");
                return
            }
        }
        
//        println("sourceUrl: \(sourceUrl)\n-----------------------------------------------------------");
        
        manager.setUbiquitous(false, itemAtURL: sourceUrl!, destinationURL: destinationUrl, error: &theError);
//        manager.copyItemAtURL(destinationUrl, toURL: sourceUrl!, error: nil)
        
        if( theError != nil ){
            
            println("theError: \(theError)\n-----------------------------------------------------------");
        }else{
            
            appDelegate().needBackup = false;
            println("Success sent to iCloud backup");
        }
    }
    
    class func checkiCloudBackupAvailability() -> Bool {
 
//        println("Checking iCloud backup availability...");
        
        var ubiq : NSURL!;
        ubiq = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil);
        
        if( ubiq == nil ){
            
//            println("iCloud backup is disabled")
            return false;
        }
        
//        println("iCloud backup is enabled");
        
        return true;
    }
}