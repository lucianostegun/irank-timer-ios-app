//
//  ConfigMasterViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "ConfigMasterViewController.h"
#import "ConfigViewController.h"
#import "ConfigLanguageViewController.h"

@interface ConfigMasterViewController ()

@end

@implementation ConfigMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    switchPlaySounds.on       = appDelegate.playSounds;
    switchFiveSecondsClock.on = appDelegate.fiveSecondsClock;
    switchLongPauseAlert.on   = appDelegate.longPauseAlert;
    switchShortBlindNumber.on = appDelegate.shortBlindNumber;
    switchPreventSleep.on     = appDelegate.preventSleep;
    switchRunBackground.on    = appDelegate.runBackground;
    
    [self localizeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMasterDetails:) name:kNotificationSettingsDetailsChange object:nil];
}

-(void)localizeView {
    
    self.title = NSLocalizedString(@"iRank Timer Config", "ConfigMasterViewController");

    lblPlaySounds.text       = NSLocalizedString(@"Play sounds", "ConfigMasterViewController");
    lblSounds.text           = NSLocalizedString(@"Sounds", "ConfigMasterViewController");
    lblFiveSecondsAlert.text = NSLocalizedString(@"FiveSecondsAlert", "ConfigMasterViewController");
    lblLongPauseAlert.text   = NSLocalizedString(@"LongPauseAlert", "ConfigMasterViewController");
    lblShortBlindNumber.text = NSLocalizedString(@"ShortBlindNumber", "ConfigMasterViewController");
    lblLanguageLabel.text    = NSLocalizedString(@"Language", "ConfigMasterViewController");
    lblPreventSleep.text     = NSLocalizedString(@"PreventSleep", "ConfigMasterViewController");
    lblRunBackground.text    = NSLocalizedString(@"RunBackground", "ConfigMasterViewController");
    
    [self changeMasterDetails:nil];
}

- (void)changeMasterDetails:(NSNotification *)notification {
    
    lblBlindChangeSound.text = [self blindChangeSoundName];
    lblLanguage.text         = [self language];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch( section ){
        case 0:
            if( switchPlaySounds.on )
                return 5;
            else
                return 1;
        case 1:
            return 1;
        case 2:
            return 2;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch( section ){
        case 0:
            return NSLocalizedString(@"Sound settings", "ConfigMasterViewController");
        case 1:
            return nil;
        case 2:
            return NSLocalizedString(@"General", "ConfigMasterViewController");
    }
    
    return nil;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    ConfigViewController *configViewController = (ConfigViewController*)self.parentViewController.parentViewController;
//
//
    if( indexPath.section==0 ){

        ConfigDetailViewController *configDetailViewController = [[ConfigDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];

//        self.detailViewController.detailItem = configDetailViewController;
        
//        [(UINavigationController*)self.detailViewController.parentViewController setViewControllers:[NSArray arrayWithObject:configDetailViewController]];

//        configViewController.viewControllers = [NSArray arrayWithObjects:self.parentViewController, configDetailViewController, nil];
        
        
        [self changeDetailViewController:configDetailViewController];
//        [[[(UISplitViewController*)self.parentViewController.parentViewController viewControllers] objectAtIndex:1] setViewControllers:[NSArray arrayWithObject:configDetailViewController]];
    }else{

        ConfigLanguageViewController *configLanguageViewController = [[ConfigLanguageViewController alloc] initWithStyle:UITableViewStyleGrouped];
//        [[configViewController.viewControllers objectAtIndex:1] pushViewController:configLanguageViewController];
//        configViewController.viewControllers = [NSArray arrayWithObjects:self.parentViewController, configLanguageViewController, nil];
        
//        self.detailViewController.detailItem = configLanguageViewController;
        
//        [(UINavigationController*)self.detailViewController.parentViewController setViewControllers:[NSArray arrayWithObject:configLanguageViewController]];
        
        [self changeDetailViewController:configLanguageViewController];
    }
    
//    if (self.detailViewController.masterPopoverController != nil)
//        [self.detailViewController.masterPopoverController dismissPopoverAnimated:YES];
}

-(void)changeDetailViewController:(UIViewController*)viewController {
    
    [[[(UISplitViewController*)self.parentViewController.parentViewController viewControllers] objectAtIndex:1] setViewControllers:[NSArray arrayWithObject:viewController]];
}

-(void)saveSettings:(id)sender {
    
    appDelegate.playSounds       = switchPlaySounds.on;
    appDelegate.fiveSecondsClock = switchFiveSecondsClock.on;
    appDelegate.longPauseAlert   = switchLongPauseAlert.on;
    appDelegate.shortBlindNumber = switchShortBlindNumber.on;
    appDelegate.preventSleep     = switchPreventSleep.on;
    appDelegate.runBackground    = switchRunBackground.on;
    [appDelegate updateSettings];
    
    [self dismiss];
}

-(void)dismiss {
    
    [appDelegate dismissRootViewController];
}

-(NSString*)blindChangeSoundName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blindChangeSounds" ofType:@"plist"];
    NSArray *blindChangeSoundList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for(NSDictionary *item in blindChangeSoundList){
        
        if( [appDelegate.blindChangeSound isEqualToString:item[@"fileName"]] ){
         
            blindChangeSoundList = nil;
            return item[@"soundName"];
        }
    }
    
    blindChangeSoundList = nil;
    return nil;
}

-(NSString*)language {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"languages" ofType:@"plist"];
    NSArray *languageList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for(NSDictionary *menuItem in languageList ){
        
        if( [appDelegate.language isEqualToString:menuItem[@"culture"]] ){

            languageList = nil;
            return menuItem[@"language"];
        }
    }
    
    languageList = nil;
    return nil;
}

-(void)switchSoundSettings:(id)sender {
    
    [self.tableView reloadData];
}

@end
