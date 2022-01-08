//
//  WizardViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    int players;
    int blindDuration;
    
    BOOL chips1;
    BOOL chips5;
    BOOL chips10;
    BOOL chips25;
    BOOL chips50;
    BOOL chips100;
    BOOL chips500;
    BOOL chips1000;
    BOOL chips5000;
    BOOL chips10000;
    
    int selectedChips;
    
    IBOutlet UISlider *sliderPlayers;
    IBOutlet UISlider *sliderDuration;
    IBOutlet UIButton *btnBuildBlindSet;
    IBOutlet UILabel *lblPlayers;
    IBOutlet UILabel *lblDuration;
    IBOutlet UISwitch *switchUseAnte;
    IBOutlet UISwitch *switchAllowAddon;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UITextView *lblIntro;
    IBOutlet UILabel *lblPlayWithAnte;
    IBOutlet UILabel *lblAllowAddon;
    // -------------------
}

-(IBAction)toggleChip:(id)sender;
-(IBAction)changeDuration:(id)sender;
-(IBAction)changePlayers:(id)sender;
-(IBAction)generateBlindSet:(id)sender;

@end
