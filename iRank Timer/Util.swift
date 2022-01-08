//
//  Util.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 08/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class Util {
    
    class func formatTimeString(var seconds:Float) -> NSString {
        
        var hours : Int   = Int(floor(seconds/3600));
        seconds    -= (Float(hours)*3600);
        var minutes : Int = Int(floor(seconds/60));
        seconds    -= (Float(minutes)*60);
        
        var seconds : Int = Int(seconds);
        
        return NSString(format: "%02d:%02d:%02d", hours, minutes, seconds);
    }
    
    class func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = Array<T>()
        var addedDict = [T: Bool]()
        for elem in source {
            if addedDict[elem] == nil {
                addedDict[elem] = true
                buffer.append(elem)
            }
        }
        return buffer
    }
    
    class func getPlural(value : Int) -> String {
        
        if( value == 1 ){
            
            return "";
        }
        
        return "s";
    }
    
    class func getShortBlindNumber(blindNumber : Int) -> String {
        
        return Util.getShortBlindNumber(blindNumber, force: false);
    }
    
    class func getShortBlindNumber(blindNumber : Int, force : Bool) -> String {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        if( !appDelegate.shortBlindNumber && !force ){
            
            return "\(blindNumber)";
        }
        
        var blindNumberFloat : Float = NSString(string: "\(blindNumber)").floatValue;
        
        if( blindNumberFloat < 1000 ){
            
            return "\(blindNumber)";
        }
        
        blindNumberFloat = blindNumberFloat / 1000;
        
        var blindLabel : String = NSString(format: "%.2fk", blindNumberFloat) as String;
        
        blindLabel = blindLabel.stringByReplacingOccurrencesOfString(".00", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        blindLabel = blindLabel.stringByReplacingOccurrencesOfString(".0", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
        
        blindLabel = blindLabel.replace("\\.0*k$", template: "k");
        blindLabel = blindLabel.replace("(\\.[1-9]+)0*k$", template: "$1k");
        
        return blindLabel;
    }
}

extension UIColor {
    class func defaultColor() -> UIColor {
        
        return UIColor(hue: 0.05, saturation: 0.82, brightness: 0.81, alpha: 1);
    }
}