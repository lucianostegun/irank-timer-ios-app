//
//  iPhoneCreateMenuViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-26.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneCreateMenuViewController.h"

@interface iPhoneCreateMenuViewController ()

@end

@implementation iPhoneCreateMenuViewController

-(void)localizeView {
    
    [super localizeView];
    
    lblIntro.text = NSLocalizedString(@"intro-iphone", "CreateMenuViewController");
}

- (void)awakeFromNib {
    
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self orientationChanged:nil];
    [super viewWillAppear:animated];
}

- (void)orientationChanged:(NSNotification *)notification {
    
    float delta = (appDelegate.isIOS7?0:15);
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if( deviceOrientation==UIDeviceOrientationPortraitUpsideDown )
        return;
    
    if(UIDeviceOrientationIsPortrait(deviceOrientation) ){
        
        delta = delta*1.25;
        
        NSLog(@"Passou por aqui PORTRAIT");
        
        isShowingLandscapeView = NO;
        
        lblIntro.frame = CGRectMake(20, 15-delta, 280, 100);
        
        lblPreset.frame     = CGRectMake(20, 133-delta, 280, 21);
        btnPreset.frame     = CGRectMake(20, 162-delta, 100, 100);
        lblPresetInfo.frame = CGRectMake(128, 162-delta, 172, 100);
        
        lblManual.frame     = CGRectMake(20, 270-delta, 280, 21);
        btnManual.frame = CGRectMake(20, 299-delta, 100, 100);
        lblManualInfo.frame = CGRectMake(128, 299-delta, 172, 100);
        
        lblPresetInfo.hidden = NO;
        lblManualInfo.hidden = NO;
        
        lblPreset.textAlignment = UITextAlignmentLeft;
        lblManual.textAlignment = UITextAlignmentLeft;
        
        imgBackground.image = [UIImage imageNamed:@"iphone-timer-blue-bg-portrait.png"];
    }else if( UIDeviceOrientationIsLandscape(deviceOrientation) ){
        
        NSLog(@"Passou por aqui LANDSCAPE");
        
        isShowingLandscapeView = YES;
        
        delta = 15;
        
        if( IS_4_INCHES ){
            
            lblIntro.frame = CGRectMake(20, 20-delta, 528, 70);
            
            lblPreset.frame     = CGRectMake(20, 98-delta, 180, 21);
            lblManual.frame     = CGRectMake(295, 98-delta, 180, 21);
            
            btnPreset.frame = CGRectMake(20, 127-delta, 150, 150);
            btnManual.frame = CGRectMake(310, 127-delta, 150, 150);
        }else{
            
            lblIntro.frame = CGRectMake(20, 20-delta, 440, 70);
            
            lblPreset.frame     = CGRectMake(20, 98-delta, 180, 21);
            lblManual.frame     = CGRectMake(280, 98-delta, 180, 21);
            
            btnPreset.frame = CGRectMake(36, 127-delta, 150, 150);
            btnManual.frame = CGRectMake(295, 127-delta, 150, 150);
        }

        lblPreset.textAlignment = UITextAlignmentCenter;
        lblManual.textAlignment = UITextAlignmentCenter;
        
        lblPresetInfo.hidden = YES;
        lblManualInfo.hidden = YES;
        
        imgBackground.image = [UIImage imageNamed:@"iphone-timer-blue-bg.png"];
        
    }
}

@end
