//
//  BackgroundViewController.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 02/03/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class BackgroundViewController: UIViewController {
    
    @IBOutlet var imgBackground1 : [UIImageView]!;
    @IBOutlet var imgBackground2 : [UIImageView]!;
    
    var backgroundWidth : CGFloat = 1290.0;
    var backgroundHeight : CGFloat = 968.0;
    var delta : CGFloat = -100;
    var filePrefix : String = "";
    
    let backgrounds : UInt32 = 9;
    let backgroundFadeInterval : Double = 20;
    var backgroundNumber1 : Int!;
    var backgroundNumber2: Int!;
    
    var enableBackgroundTransition : Bool = false;
    var transitionBackground : Bool = true;
    
    func startBackgroundTransition(){
        
        if( backgroundWidth < 1290 ){
            
            delta = -50;
            filePrefix = "iphone-";
        }
        
        do {
            
            backgroundNumber1 = Int(arc4random_uniform(backgrounds))+1;
            backgroundNumber2 = Int(arc4random_uniform(backgrounds))+1;
        }while( backgroundNumber1 == backgroundNumber2 );
        
        self.imgBackground1.first!.hidden = false;
        self.imgBackground1.last!.hidden = self.imgBackground1.first!.hidden
        self.imgBackground2.first!.hidden = false;
        self.imgBackground2.last!.hidden = self.imgBackground2.first!.hidden
        
        self.imgBackground1.first!.alpha = 1;
        self.imgBackground1.last!.alpha = self.imgBackground1.first!.alpha
        self.imgBackground2.first!.alpha = 1;
        self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha
        
        self.imgBackground1.first!.image = UIImage(named: "\(filePrefix)background-\(backgroundNumber1).jpg");
        self.imgBackground1.last!.image = self.imgBackground1.first!.image
        self.imgBackground2.first!.image = UIImage(named: "\(filePrefix)background-\(backgroundNumber2).jpg");
        self.imgBackground2.last!.image = self.imgBackground2.first!.image
        
        //        self.imgBackground1.frame = CGRectMake(delta, delta, self.backgroundWidth, self.backgroundHeight);
        //        self.imgBackground2.frame = CGRectMake(delta, delta, self.backgroundWidth, self.backgroundHeight);
        
        enableBackgroundTransition = true;
        
        NSTimer.scheduledTimerWithTimeInterval(backgroundFadeInterval, target: self, selector: Selector("fadeOutBackground"), userInfo: nil, repeats: false);
        //        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("slideBackground2"), userInfo: nil, repeats: false);
    }
    
    func stopBackgroundTransition(){
        
        transitionBackground = false;
        imgBackground1.first!.layer.removeAllAnimations();
        imgBackground2.first!.layer.removeAllAnimations();
    }
    
    func fadeOutBackground(){
        
        if( !transitionBackground ){
            
            return;
        }
        
        do {
            
            backgroundNumber1 = Int(arc4random_uniform(backgrounds))+1;
        }while( backgroundNumber1 == backgroundNumber2 );
        
        self.imgBackground1.first!.image = UIImage(named: "\(filePrefix)background-\(backgroundNumber1).jpg");
        self.imgBackground1.last!.image = self.imgBackground1.first!.image
        
        UIView .animateWithDuration(2, animations: {
            self.imgBackground2.first!.alpha = 0;
            self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha
        });
        
        if( transitionBackground ){
            
            NSTimer.scheduledTimerWithTimeInterval(backgroundFadeInterval, target: self, selector: Selector("fadeInBackground"), userInfo: nil, repeats: false);
        }
        //        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("slideBackground1"), userInfo: nil, repeats: false);
    }
    
    func fadeInBackground(){
        
        if( !transitionBackground ){
            
            return;
        }
        
        do {
            
            backgroundNumber2 = Int(arc4random_uniform(backgrounds))+1;
        }while( backgroundNumber1 == backgroundNumber2 );
        
        self.imgBackground2.first!.image = UIImage(named: "\(filePrefix)background-\(backgroundNumber2).jpg");
        self.imgBackground2.last!.image = self.imgBackground2.first!.image
        
        UIView .animateWithDuration(2, animations: {
            self.imgBackground2.first!.alpha = 1;
            self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha
        });
        
        if( transitionBackground ){
            
            NSTimer.scheduledTimerWithTimeInterval(backgroundFadeInterval, target: self, selector: Selector("fadeOutBackground"), userInfo: nil, repeats: false);
        }
        //        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("slideBackground2"), userInfo: nil, repeats: false);
    }
    
    func slideBackground1(){
        
        var corner = arc4random_uniform(4);
        
        self.imgBackground1.first!.alpha = 1;
        self.imgBackground1.last!.alpha = self.imgBackground1.first!.alpha
        
        if( corner == 1 ){
            
            self.imgBackground1.first!.frame = CGRectMake(-100, -100, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
        }else if( corner == 2 ){
            
            
            self.imgBackground1.first!.frame = CGRectMake(-100, 0, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
        }else if( corner == 3 ){
            
            self.imgBackground1.first!.frame = CGRectMake(0, 0, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
        }else{
            
            self.imgBackground1.first!.frame = CGRectMake(0, -100, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
        }
        
        UIView .animateWithDuration(22, animations: {
            
            if( corner == 1 ){
                
                self.imgBackground1.first!.frame = CGRectMake(0, 0, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
            }else if( corner == 2 ){
                
                self.imgBackground1.first!.frame = CGRectMake(0, -100, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
            }else if( corner == 3 ){
                
                self.imgBackground1.first!.frame = CGRectMake(-100, -100, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
            }else{
                
                self.imgBackground1.first!.frame = CGRectMake(-100, 0, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground1.last!.frame = self.imgBackground1.first!.frame
            }
            
        });
    }
    
    func slideBackground2(){
        
        var corner = arc4random_uniform(4);
        
        self.imgBackground2.first!.alpha = 1;
        self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha
        
        if( corner == 1 ){
            
            self.imgBackground2.first!.frame = CGRectMake(-100, -100, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
        }else if( corner == 2 ){
            
            self.imgBackground2.first!.frame = CGRectMake(-100, 0, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
        }else if( corner == 3 ){
            
            self.imgBackground2.first!.frame = CGRectMake(0, 0, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
        }else{
            
            self.imgBackground2.first!.frame = CGRectMake(0, -100, self.backgroundWidth, self.backgroundHeight);
            self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
        }
        
        UIView .animateWithDuration(22, animations: {
            
            if( corner == 1 ){
                
                self.imgBackground2.first!.frame = CGRectMake(0, 0, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
            }else if( corner == 2 ){
                
                self.imgBackground2.first!.frame = CGRectMake(0, -100, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
            }else if( corner == 3 ){
                
                self.imgBackground2.first!.frame = CGRectMake(-100, -100, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
            }else{
                
                self.imgBackground2.first!.frame = CGRectMake(-100, 0, self.backgroundWidth, self.backgroundHeight);
                self.imgBackground2.last!.frame = self.imgBackground2.first!.frame
            }
            
        });
    }
    
    @IBAction func changeBackground(){
        
        stopBackgroundTransition();
        
        enableBackgroundTransition = true;
        
        self.imgBackground2.first!.hidden = false;
        self.imgBackground2.last!.hidden = self.imgBackground2.first!.hidden
        
        self.imgBackground2.first!.alpha = 1;
        self.imgBackground2.last!.alpha = self.imgBackground2.first!.alpha
        
        var tag : Int = self.imgBackground2.first!.tag + 1;
        if( tag > 10 ){
            
            tag = 1;
        }
        
        self.imgBackground2.first!.tag = tag;
        self.imgBackground2.last!.tag = self.imgBackground2.first!.tag;
        
        var backgroundNumber1 : Int = self.imgBackground2.first!.tag;
    
        self.imgBackground2.first!.image = UIImage(named: "\(filePrefix)background-\(backgroundNumber1).jpg");
        self.imgBackground2.last!.image = self.imgBackground2.first!.image
    }
}