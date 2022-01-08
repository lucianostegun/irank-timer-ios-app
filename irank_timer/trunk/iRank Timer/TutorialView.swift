//
//  TutorialView.swift
//  iRank Timer
//
//  Created by Luciano Stegun on 21/02/15.
//  Copyright (c) 2015 Stegun.com. All rights reserved.
//

import UIKit
import Foundation

class TutorialView : UIView {
    
    var rectsArray : Array<CGRect>!;
    
    init(frame: CGRect, backgroundColor : UIColor, rects : Array<CGRect>) {
        
        super.init(frame: frame);
        
        self.rectsArray = rects;
        self.backgroundColor = backgroundColor;
        
        self.alpha = 0.5
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        UIRectFill(rect)
        
        for holeRectValue : CGRect in rectsArray {

            var holeRect : CGRect = holeRectValue;
            var holeRectIntersection : CGRect = CGRectIntersection(holeRect, rect);
            UIColor.clearColor().setFill();
            UIRectFill(holeRectIntersection);
        }
    }
    
//    var viewCover : TutorialView!;
//    var viewFocus : UIView!;
//    var nextButton = UIButton();
//    
//    func startTutorial(sender: AnyObject) {
//        
//        viewFocus = UIView();
//        
//        viewFocus.backgroundColor = UIColor.clearColor();
//        viewFocus.layer.borderColor = UIColor.whiteColor().CGColor;
//        viewFocus.layer.borderWidth = 1;
//        
//        viewCover = TutorialView(frame: view.bounds, backgroundColor: UIColor.blackColor().colorWithAlphaComponent(0.85), rects: [viewFocus.frame]);
//        
//        nextButton.setTitle("Next", forState: UIControlState.Normal)
//        nextButton.frame = CGRectMake(0, 0, 100, 30);
//        nextButton.addTarget(self, action: Selector("nextTutorialStep"), forControlEvents: UIControlEvents.TouchUpInside)
//        nextButton.tag = 0;
//        
//        viewCover.addSubview(nextButton);
//        viewCover.addSubview(viewFocus)
//        self.view.addSubview(viewCover)
//        
//        nextTutorialStep();
//    }
//    
//    
//    func nextTutorialStep(){
//        
//        let POSITION_TOP    = 1;
//        let POSITION_RIGHT  = 2;
//        let POSITION_BOTTOM = 3;
//        let POSITION_LEFT   = 4;
//        var buttonPosition  = POSITION_BOTTOM; // 1 = TOP, 2 = RIGHT, 3 = BOTTOM, 4 = LEFT
//        
//        switch( nextButton.tag ){
//        case 0:
//            viewFocus.frame = lblTimer.frame;
//            buttonPosition = POSITION_BOTTOM;
//        case 1:
//            viewFocus.frame = lblSmallBlind.frame;
//            break;
//        case 2:
//            viewFocus.frame = lblElapsedTime.frame;
//            break;
//        default:
//            break;
//        }
//        
//        nextButton.tag = nextButton.tag+1;
//        
//        switch( buttonPosition ){
//        case POSITION_BOTTOM:
//            nextButton.frame = CGRectMake(viewFocus.frame.origin.x + (viewFocus.frame.width/2) - (nextButton.frame.width/2), viewFocus.frame.origin.y + viewFocus.frame.height + 20, nextButton.frame.width, nextButton.frame.height)
//            break;
//        default:
//            break;
//        }
//        
//        viewCover.rectsArray = [viewFocus.frame];
//        viewCover.setNeedsDisplay();
//        nextButton.setNeedsDisplay();
//    }
}