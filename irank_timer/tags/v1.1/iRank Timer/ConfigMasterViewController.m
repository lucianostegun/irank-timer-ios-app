//
//  ConfigMasterViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "ConfigMasterViewController.h"
#import "ConfigViewController.h"
#import "ConfigDetailViewController.h"
#import "ConfigLanguageViewController.h"
#import "TimerViewController.h"

@interface ConfigMasterViewController ()

@end

@implementation ConfigMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    switchPlaySounds.on       = appDelegate.playSounds;
    switchFiveSecondsClock.on = appDelegate.fiveSecondsClock;
    switchLongPauseAlert.on   = appDelegate.longPauseAlert;
    switchShortBlindNumber.on = appDelegate.shortBlindNumber;
    switchInverseColors.on    = appDelegate.inverseColors;
    switchPreventSleep.on     = appDelegate.preventSleep;
    switchRunBackground.on    = appDelegate.runBackground;
    
    [self localizeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMasterDetails:) name:kNotificationSettingsDetailsChange object:nil];
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else{
     
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryView:switchPlaySounds];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] setAccessoryView:switchFiveSecondsClock];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setAccessoryView:switchLongPauseAlert];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]] setAccessoryView:switchShortBlindNumber];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]] setAccessoryView:switchInverseColors];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] setAccessoryView:switchPreventSleep];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] setAccessoryView:switchRunBackground];
}

-(void)localizeView {
    
    self.title = NSLocalizedString(@"iRank Timer Config", "ConfigMasterViewController");

    lblPlaySounds.text       = NSLocalizedString(@"Play sounds", "ConfigMasterViewController");
    lblSounds.text           = NSLocalizedString(@"Sounds", "ConfigMasterViewController");
    lblFiveSecondsAlert.text = NSLocalizedString(@"Five seconds alert", "ConfigMasterViewController");
    lblLongPauseAlert.text   = NSLocalizedString(@"Long pause alert", "ConfigMasterViewController");
    lblShortBlindNumber.text = NSLocalizedString(@"Short blind numbers", "ConfigMasterViewController");
    lblInverseColors.text    = NSLocalizedString(@"Inverse colors", "ConfigMasterViewController");
    lblLanguageLabel.text    = NSLocalizedString(@"Language", "ConfigMasterViewController");
    lblPreventSleep.text     = NSLocalizedString(@"Prevent sleep", "ConfigMasterViewController");
    lblRunBackground.text    = NSLocalizedString(@"Run in background", "ConfigMasterViewController");
    
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
                return 4;
            else
                return 1;
        case 1:
            return 3;
        case 2:
            return 2;
    }
    return 0;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"ConfigCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if( !cell )
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    
//    
//    
//    return cell;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch( section ){
        case 0:
            return NSLocalizedString(@"Sound settings", "ConfigMasterViewController");
        case 1:
            return NSLocalizedString(@"Layout", "ConfigMasterViewController");
        case 2:
            return NSLocalizedString(@"General", "ConfigMasterViewController");
    }
    
    return nil;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if( indexPath.section==0 && indexPath.row==1 ){

        ConfigDetailViewController *configDetailViewController = [[ConfigDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self changeDetailViewController:configDetailViewController];
    }else if( indexPath.section==1 ){

        if( indexPath.row != 0 )
            return;
            
        ConfigLanguageViewController *configLanguageViewController = [[ConfigLanguageViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self changeDetailViewController:configLanguageViewController];
    }
}

-(void)changeDetailViewController:(UIViewController*)viewController {
    
    [[[(UISplitViewController*)self.parentViewController.parentViewController viewControllers] objectAtIndex:1] setViewControllers:[NSArray arrayWithObject:viewController]];
}

-(void)saveSettings:(id)sender {
    
    BOOL changeViewController = (appDelegate.inverseColors!=switchInverseColors.on);
    
    appDelegate.playSounds       = switchPlaySounds.on;
    appDelegate.fiveSecondsClock = switchFiveSecondsClock.on;
    appDelegate.longPauseAlert   = switchLongPauseAlert.on;
    appDelegate.shortBlindNumber = switchShortBlindNumber.on;
    appDelegate.inverseColors    = switchInverseColors.on;
    appDelegate.preventSleep     = switchPreventSleep.on;
    appDelegate.runBackground    = switchRunBackground.on;
    [appDelegate updateSettings];
  
    [self dismiss];
    
    if( changeViewController ){

        TimerViewController *currentTimerViewController = [appDelegate.rootViewControllers lastObject];
        [currentTimerViewController invalidateTimer];
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:(appDelegate.inverseColors?@"iPad_Timer_White":@"iPad_Timer") bundle:nil];
        TimerViewController* timerViewController = [storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        [appDelegate.window setRootViewController: timerViewController];
        
        NSLog(@"appDelegate.rootViewControllers: %@", appDelegate.rootViewControllers);
        
        appDelegate.rootViewControllers = [[NSMutableArray alloc] initWithObjects:timerViewController, nil];
        
        [appDelegate.window makeKeyAndVisible];
    }
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
