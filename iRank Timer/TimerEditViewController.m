//
//  TimerEditViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerEditViewController.h"

@interface TimerEditViewController ()

@end

@implementation TimerEditViewController
@synthesize blindSet;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
