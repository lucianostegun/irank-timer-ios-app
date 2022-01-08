//
//  CreateMenuViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-21.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "CreateMenuViewController.h"
#import "TimerEditViewController.h"
#import "BlindLevel.h"

@interface CreateMenuViewController ()

@end

@implementation CreateMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
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
    [btnCancel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnWizard setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnWizard setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnPreset setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnPreset setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnManual setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnManual setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    if( !appDelegate.isIOS7 )
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
    
    [self localizeView];
}

-(void)localizeView{
    
    self.title = NSLocalizedString(@"Create a new blind set", "CreateMenuViewController");
    
    lblIntro.text      = NSLocalizedString(@"intro", "CreateMenuViewController");
    lblWizard.text     = NSLocalizedString(@"Blind set wizard", "CreateMenuViewController");
    lblPreset.text     = NSLocalizedString(@"Preset blind sets", "CreateMenuViewController");
    lblManual.text     = NSLocalizedString(@"Manual creation", "CreateMenuViewController");
    lblWizardInfo.text = NSLocalizedString(@"The assistent will guide you to create a new blind set according of players, chips and game duration.", "CreateMenuViewController");
    lblPresetInfo.text = NSLocalizedString(@"Choose one of the pre configured blind sets and edit for according your game players and duration.", "CreateMenuViewController");
    lblManualInfo.text = NSLocalizedString(@"Create your own blind set and configure each level, break and sound settings.", "CreateMenuViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -
-(void)createManualTimer:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad_Timer_Edit" bundle:nil];
    TimerEditViewController *timerEditViewController = [storyBoard instantiateInitialViewController];

    timerEditViewController.blindSet       = [[BlindSet alloc] init];
    timerEditViewController.blindSet.isNew = YES;
    
    BlindLevel *blindLevel = [[BlindLevel alloc] initWithLevelNumber:1 smallBlind:0 bigBlind:0 ante:0 duration:0];
    [timerEditViewController.blindSet addBlindLevel:blindLevel];
    
    timerEditViewController.blindSet.blindSetName = NSLocalizedString(@"New blind set", nil);
    [timerEditViewController.blindSet resetLevelNumbers];
    
    [appDelegate pushViewController:timerEditViewController];
}

-(void)dismiss:(id)sender {

    [appDelegate dismissRootViewController];
}

@end
