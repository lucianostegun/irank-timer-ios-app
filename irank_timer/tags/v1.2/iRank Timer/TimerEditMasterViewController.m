//
//  TimerEditMasterViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerEditMasterViewController.h"
#import "TimerEditViewController.h"

@interface TimerEditMasterViewController ()

@end

@implementation TimerEditMasterViewController
@synthesize blindSet;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    if( IS_IPAD ){
        
        TimerEditViewController *timerEditViewController = (TimerEditViewController*)self.parentViewController.parentViewController;
        blindSet = timerEditViewController.blindSet;
        UINavigationController *navigationController = (UINavigationController*)[timerEditViewController.viewControllers objectAtIndex:1];
        timerEditDetailViewController = [navigationController.viewControllers objectAtIndex:0];
    }
    
    
    NSLog(@"blindSet.blindLevelList: %@", blindSet.blindLevelList);
    
    txtBlindSetName.text      = blindSet.blindSetName;
    switchPlaySound.on        = blindSet.playSound;
    switchBlindChangeAlert.on = blindSet.blindChangeAlert;
    switchMinuteAlert.on      = blindSet.minuteAlert;
    switchDoublePrevious.on   = blindSet.doublePrevious;
    
    [self localizeView];
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else{
        
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)localizeView {
    
    self.title               = NSLocalizedString(@"Blind Set Config", "TimerEditMasterViewController");
    lblBlindSetName.text     = NSLocalizedString(@"Name", "TimerEditMasterViewController");
    lblPlaySound.text        = NSLocalizedString(@"Play sound", "TimerEditMasterViewController");
    lblMinuteAlert.text      = NSLocalizedString(@"1 minute alert", "TimerEditMasterViewController");
    lblBlindChangeAlert.text = NSLocalizedString(@"Blind change alert", "TimerEditMasterViewController");
    lblDoublePrevious.text   = NSLocalizedString(@"Double previous", "TimerEditMasterViewController");
    lblLevels.text           = NSLocalizedString(@"Levels", "TimerEditMasterViewController");
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setAccessoryView:switchPlaySound];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] setAccessoryView:switchMinuteAlert];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] setAccessoryView:switchBlindChangeAlert];
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]] setAccessoryView:switchDoublePrevious];
}

-(void)viewDidAppear:(BOOL)animated{
    
//    [txtBlindSetName becomeFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 4;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if( section==3 )
        return NSLocalizedString(@"doublePreviousFooter", "TimerEditMasterViewController");
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(BOOL)validateForm {
    
    if( [txtBlindSetName.text isEqualToString:@""] ){
        
        [appDelegate showAlert:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"Please set the blind set name", "TimerEditMasterViewController")];
        [txtBlindSetName becomeFirstResponder];
        return NO;
    }
    
    if( blindSet.seconds == 0 ){
        
        [appDelegate showAlert:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"The blind set total duration must be greater than 0", "TimerEditMasterViewController")];
        return NO;
    }
    
    if( blindSet.levels == 0 ){
        
        [appDelegate showAlert:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"This blind set has no properly levels configured", "TimerEditMasterViewController")];
        return NO;
    }
    
    return YES;
}

-(void)saveBlindSet:(id)sender {
    
    if( ![self validateForm] )
        return;

    blindSet.blindSetName     = txtBlindSetName.text;
    blindSet.playSound        = switchPlaySound.on;
    blindSet.blindChangeAlert = switchBlindChangeAlert.on;
    blindSet.minuteAlert      = switchMinuteAlert.on;
    blindSet.doublePrevious   = switchDoublePrevious.on;
    
    [self dismiss:nil];
    
    if( blindSet.isNew == YES ){
        
        blindSet.isNew = NO;
        blindSet.blindSetId = rand();
        
        blindSet.blindSetIndex = appDelegate.blindSetList.count;
        
        [appDelegate.blindSetList addObject:blindSet];
        [self dismiss:nil];
    }else{
        
        [appDelegate.blindSetList replaceObjectAtIndex:blindSet.blindSetIndex withObject:blindSet];
    }

    if( appDelegate.blindSet.blindSetId==blindSet.blindSetId )
        appDelegate.blindSet = blindSet;
    
    NSLog(@"appDelegate.blindSetList: %@", appDelegate.blindSetList);
    NSLog(@"blindSet: %@", blindSet);
    NSLog(@"blindSet.blindLevelList: %@", blindSet.blindLevelList);
    
    [BlindSet archivedBlindSetList:appDelegate.blindSetList];
}

-(void)dismiss:(id)sender {
    
    if( IS_IPAD )
        [appDelegate dismissRootViewController];
    else
        [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    timerEditDetailViewController.title = newString;
    
    return YES;
}
    
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    blindSet.doublePrevious   = switchDoublePrevious.on;
    
    timerEditDetailViewController = (iPhoneTimerEditDetailViewController *)segue.destinationViewController;
    timerEditDetailViewController.blindSet = blindSet;
}
@end
