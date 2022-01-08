//
//  ConfigDetailViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "ConfigDetailViewController.h"

@interface ConfigDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation ConfigDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *filePath;
    
    filePath = [[NSBundle mainBundle] pathForResource:@"blindChangeSounds" ofType:@"plist"];
    blindChangeSoundList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"minuteNofitySounds" ofType:@"plist"];
    minuteAlertSoundList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    self.title = NSLocalizedString(@"Sounds", "ConfigMasterViewController");
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the detail item

//- (void)setDetailItem:(id)viewController {
//    
//    if (_detailItem != viewController) {
//        _detailItem = viewController;
//        
//        // Update the view.
////        [self configureView];
//    }
//    
//    [(UINavigationController*)self.parentViewController setViewControllers:[NSArray arrayWithObject:viewController]];
//    
//    if (self.masterPopoverController != nil)
//        [self.masterPopoverController dismissPopoverAnimated:YES];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if( section==0 )
        return blindChangeSoundList.count;
    
    return minuteAlertSoundList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *menuItem;
    
    switch( indexPath.section ){
        case 0:
            menuItem = [blindChangeSoundList objectAtIndex:indexPath.row];
            break;
        case 1:
            menuItem = [minuteAlertSoundList objectAtIndex:indexPath.row];
            break;
    }
    
    if( [appDelegate.blindChangeSound isEqualToString:menuItem[@"fileName"]] || [appDelegate.minuteNotifySound isEqualToString:menuItem[@"fileName"]] )
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = menuItem[@"soundName"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *menuItem;
    
    switch( indexPath.section ){
        case 0:
            menuItem = [blindChangeSoundList objectAtIndex:indexPath.row];
            appDelegate.blindChangeSound = menuItem[@"fileName"];
            
            [self playSound:appDelegate.blindChangeSound];
            break;
        case 1:
            menuItem = [minuteAlertSoundList objectAtIndex:indexPath.row];
            appDelegate.minuteNotifySound = menuItem[@"fileName"];
            
            [self playSound:appDelegate.minuteNotifySound];
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSettingsDetailsChange object:nil];
    
    [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if( section==0 )
        return NSLocalizedString(@"Blind change sounds", "ConfigDetailViewController");
    
    return NSLocalizedString(@"1 minute left sounds", "ConfigDetailViewController");
}

-(void)playSound:(NSString *)soundName {
    
    [audioPlayer stop];
    
    NSString* filePath = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    
    audioPlayer.numberOfLoops = 0;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
@end
