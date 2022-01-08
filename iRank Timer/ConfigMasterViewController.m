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
#import "iPadTimerViewController.h"

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
    switchNotifyFirstAnte.on  = appDelegate.notifyFirstAnte;
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
    
    selectedIndexPath = nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self updateSwitchers];
    [self.tableView reloadData];
}

-(void)updateSwitchers {
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryView:switchPlaySounds];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] setAccessoryView:switchFiveSecondsClock];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setAccessoryView:switchLongPauseAlert];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] setAccessoryView:switchNotifyFirstAnte];
    
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
    lblNotifyFirstAnte.text  = NSLocalizedString(@"Notify first ante", "ConfigMasterViewController");
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

-(void)switchSoundSettings:(id)sender {
    
    NSArray *rowSection0List = [[NSArray alloc] initWithObjects:
                                [NSIndexPath indexPathForRow:1 inSection:0],
                                [NSIndexPath indexPathForRow:2 inSection:0],
                                [NSIndexPath indexPathForRow:3 inSection:0],nil];
    
    [self.tableView beginUpdates];
    
    if( switchPlaySounds.on ){
        
        
        [self.tableView insertRowsAtIndexPaths:rowSection0List withRowAnimation:UITableViewRowAnimationFade];
    }else{
        
        
        [self.tableView deleteRowsAtIndexPaths:rowSection0List withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
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
            return (LITE_VERSION || !IS_IPAD?2:3);
        case 2:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if( !cell )
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.detailTextLabel.text = @"";
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Play sounds", "ConfigMasterViewController");
                    cell.accessoryView = switchPlaySounds;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Sounds", "ConfigMasterViewController");
                    cell.detailTextLabel.text = [self blindChangeSoundName];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Five seconds alert", "ConfigMasterViewController");
                    cell.accessoryView = switchFiveSecondsClock;
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"Long pause alert", "ConfigMasterViewController");
                    cell.accessoryView = switchLongPauseAlert;
                    break;
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"Notify first ante", "ConfigMasterViewController");
                    cell.accessoryView = switchNotifyFirstAnte;
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Language", "ConfigMasterViewController");
                    cell.detailTextLabel.text = [self language];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Short blind numbers", "ConfigMasterViewController");
                    cell.accessoryView = switchShortBlindNumber;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Inverse colors", "ConfigMasterViewController");
                    cell.accessoryView = switchInverseColors;
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Prevent sleep", "ConfigMasterViewController");
                    cell.accessoryView = switchPreventSleep;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Run in background", "ConfigMasterViewController");
                    cell.accessoryView = switchRunBackground;
                    break;
            }
            break;
    }
    
    return cell;
}

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

    if( IS_IPAD ){

        if( indexPath.section==0 && indexPath.row==1 ){
            
            ConfigDetailViewController *configDetailViewController = [[ConfigDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self changeDetailViewController:configDetailViewController];
        }else if( indexPath.section==1 && indexPath.row==0 ){
            
            ConfigLanguageViewController *configLanguageViewController = [[ConfigLanguageViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self changeDetailViewController:configLanguageViewController];
        }else{
            
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            return;
        }
    }else{
        
        if( indexPath.section==0 && indexPath.row==1 )
            [self performSegueWithIdentifier:@"ConfigSoundsSegue" sender:self];
        else if( indexPath.section==1 && indexPath.row == 0 )
            [self performSegueWithIdentifier:@"ConfigLanguageSegue" sender:self];
        else{
            
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            return;
        }
    }
    
    selectedIndexPath = indexPath;
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
    appDelegate.notifyFirstAnte  = switchNotifyFirstAnte.on;
    appDelegate.inverseColors    = switchInverseColors.on;
    appDelegate.preventSleep     = switchPreventSleep.on;
    appDelegate.runBackground    = switchRunBackground.on;
    [appDelegate updateSettings];
  
    if( IS_IPAD ){
        
        [self dismiss:NO];
        
        if( changeViewController ){
            
            iPadTimerViewController *currentTimerViewController = [appDelegate.rootViewControllers lastObject];
            [currentTimerViewController invalidateTimer];
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:(appDelegate.inverseColors?@"iPad_Timer_White":@"iPad_Timer") bundle:nil];
            iPadTimerViewController* timerViewController = [storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [appDelegate.window setRootViewController: timerViewController];
            
            NSLog(@"appDelegate.rootViewControllers: %@", appDelegate.rootViewControllers);
            
            appDelegate.rootViewControllers = [[NSMutableArray alloc] initWithObjects:timerViewController, nil];
            
            [appDelegate.window makeKeyAndVisible];
        }
    }else{
        
        [self dismiss:YES];
    }
}

-(void)dismiss:(BOOL)defaultDismiss {
    
    if( defaultDismiss )
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)checkLiteVersion:(id)sender {

    if( LITE_VERSION ){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:NSLocalizedString(@"This feature is not enabled in lite version of this app. Would you like to download the full version at App Store?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"Not now", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"YES", @"TimerViewController"), nil];
        alertView.tag = 2;
        [alertView show];
        
        ((UISwitch *)sender).on = NO;
    }
}

- (void)alertView:(UIAlertView *)pAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch( pAlertView.tag ){
        case 2:
            if (buttonIndex == 1){
                
                NSString *appUrl = [NSString stringWithFormat:APP_URL, appDelegate.language];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appUrl]];
            }
            break;
    }
}



@end
