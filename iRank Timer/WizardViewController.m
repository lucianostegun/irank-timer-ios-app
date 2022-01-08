//
//  WizardViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "WizardViewController.h"
#import "BlindLevel.h"
#import "BlindSet.h"
#import "TimerEditViewController.h"

@interface WizardViewController ()

@end

@implementation WizardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(45, 45, 45, 45)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(45, 45, 45, 45)];
    
    // Set the background for any states you plan to use
    [btnBuildBlindSet setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnBuildBlindSet setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    chips1     = NO;
    chips5     = NO;
    chips10    = NO;
    chips25    = NO;
    chips50    = NO;
    chips100   = NO;
    chips500   = NO;
    chips1000  = NO;
    chips5000  = NO;
    chips10000 = NO;
    
    selectedChips = 0;  
    players = 6;
    blindDuration = 15;
    
    sliderPlayers.value  = players;
    sliderDuration.value = blindDuration;
    
    [self changePlayers:nil];
    [self changeDuration:nil];
    [self localizeView];
}

-(void)localizeView{
    
    self.title = NSLocalizedString(@"Blind set wizard", "WizardViewController");
    
    lblIntro.text = NSLocalizedString(@"wizard-intro", "WizardViewController");
    lblPlayWithAnte.text = NSLocalizedString(@"Play with ante", "WizardViewController");
    lblAllowAddon.text = NSLocalizedString(@"Allow add on", "WizardViewController");
    [btnBuildBlindSet setTitle: NSLocalizedString(@"Generate blind set", "WizardViewController") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleChip:(id)sender {
    
    UIButton *chip = (UIButton*)sender;
    BOOL selected = chip.alpha!=1;
    
    selectedChips += (selected?1:-1);
    
    if( selectedChips > 5 ){
        
        selectedChips = 5;
        return;
    }
    
    if( chip.alpha==1 )
        chip.alpha = 0.2;
    else
        chip.alpha = 1;
    
    switch( chip.tag ){
        case 1:
            chips1 = selected;
            break;
        case 5:
            chips5 = selected;
            break;
        case 10:
            chips10 = selected;
            break;
        case 25:
            chips25 = selected;
            break;
        case 50:
            chips50 = selected;
            break;
        case 100:
            chips100 = selected;
            break;
        case 500:
            chips500 = selected;
            break;
        case 1000:
            chips1000 = selected;
            break;
        case 5000:
            chips5000 = selected;
            break;
        case 10000:
            chips10000 = selected;
            break;
    }
}

-(void)changePlayers:(id)sender {
    
    players = (int)sliderPlayers.value;
    
    lblPlayers.text = [NSString stringWithFormat:@"%i %@", players, NSLocalizedString(@"players", "WizardViewController")];
}

-(void)changeDuration:(id)sender {
    
    blindDuration = (int)sliderDuration.value;
    
    lblDuration.text = [NSString stringWithFormat:@"%i %@", blindDuration, NSLocalizedString(@"minutes", "WizardViewController")];
}

-(void)generateBlindSet:(id)sender {
    
    int smallValue    = 0;
    
    if( chips10000 ){
        NSLog(@"chips 10000");
        smallValue = 10000;
    }
    
    if( chips5000 ){
        NSLog(@"chips 5000");
        smallValue = 5000;
    }
    
    if( chips1000 ){
        NSLog(@"chips 1000");
        smallValue = 1000;
    }
    
    if( chips500 ){
        NSLog(@"chips 500");
        smallValue = 500;
    }
    
    if( chips100 ){
        NSLog(@"chips 100");
        smallValue = 100;
    }
    
    if( chips50 ){
        NSLog(@"chips 50");
        smallValue = 50;
    }
    
    if( chips25 ){
        NSLog(@"chips 25");
        smallValue = 25;
    }
    
    if( chips10 ){
        NSLog(@"chips 10");
        smallValue = 10;
    }
    
    if( chips5 ){
        NSLog(@"chips 5");
        smallValue = 5;
    }
    
    if( chips1 ){
        NSLog(@"chips 1");
        smallValue = 1;
    }
    
    if( selectedChips < 4 ){
        
        [appDelegate showAlert:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"Please select at least 4 different chips", "WizardViewController")];
        return;
    }
    
    if( selectedChips > 5 ){
        
        [appDelegate showAlert:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"Please select up to 5 different chips", "WizardViewController")];
        return;
    }
    
    int smallBlind     = smallValue;
    int bigBlind       = smallValue*2;
    int ante           = 0;
    int lastSmallBlind = 0;
    int lastBigBlind   = 0;
    int lastDifference = 0;
    
    BlindSet *blindSet = [[BlindSet alloc] init];
    blindSet.isNew = YES;
    blindSet.blindSetName = NSLocalizedString(@"New custom blind set", "WizardViewController");
    
    NSLog(@"smallValue: %i", smallValue);
    
    int levelNumber = 0;
    for(int level=1; level <= 20; level++){
        
        BlindLevel *blindLevel;
        
//        if( players > 6 && ((switchAllowAddon.on==YES && level==7) || level==15) ){
        if( (switchAllowAddon.on==YES && level==7) ||
            (switchAllowAddon.on==NO && players > 6 && level==7) ||
           (players > 7 && level==15) ){
        
            int duration = blindDuration*0.66;
            duration  = (duration<15?duration:15);
            duration  = (ceil((float)duration/5)*5);
            
            blindLevel = [[BlindLevel alloc] initWithDuration:duration isBreak:YES levelIndex:blindSet.blindLevels];
        }else{
            
            levelNumber++;

            float percent;
            
            switch( levelNumber ){
                case 1:
                    smallBlind = smallValue;
                    break;
                case 2:
                    percent = 2;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 3:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 4:
                    percent = 1.4;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 5:
                    percent = 1.2;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante = smallValue;
                    break;
                case 6:
                    percent = 1.2;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 7:
                    percent = 1.25;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += smallValue;
                    break;
                case 8:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 9:
                    percent = 1.7;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += smallValue*2;
                    break;
                case 10:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += smallValue*2;
                    break;
                case 11:
                    percent = 1.33;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += smallValue*2;
                    break;
                case 12:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += smallValue*2;
                    break;
                case 13:
                    percent = 1.66;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante *= 2;
                    break;
                case 14:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 15:
                    percent = 1.335;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += ante/2;
                    break;
                case 16:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
                case 17:
                    percent = 1.334;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    ante += ante/3;
                    break;
                case 18:
                    percent = 1.5;
                    smallBlind = round((smallBlind*percent)/smallValue)*smallValue;
                    break;
            }
            
            
            if( switchUseAnte.on==NO )
                ante = 0;
            
            bigBlind = smallBlind*2;
            
            blindLevel = [[BlindLevel alloc] initWithLevelNumber:levelNumber levelIndex:blindSet.blindLevels smallBlind:smallBlind bigBlind:bigBlind ante:ante duration:blindDuration];

            lastDifference = smallBlind-lastSmallBlind;
            
            lastSmallBlind = smallBlind;
            lastBigBlind   = bigBlind;
        }
        
        [blindSet addBlindLevel:blindLevel];
    }
    
    [blindSet resetLevelNumbers];
    
    [self openTimerEdit:blindSet];
    NSLog(@"blindSet: %@", blindSet);
}

-(void)openTimerEdit:(BlindSet*)blindSet {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad_Timer_Edit" bundle:nil];
    TimerEditViewController *timerEditViewController = [storyBoard instantiateInitialViewController];
    
    timerEditViewController.blindSet = blindSet;
    
    [appDelegate pushViewController:timerEditViewController];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
@end
