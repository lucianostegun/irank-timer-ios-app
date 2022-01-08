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

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    TimerEditViewController *timerEditViewController = (TimerEditViewController*)self.parentViewController.parentViewController;
    blindSet = timerEditViewController.blindSet;
    
    UINavigationController *navigationController = (UINavigationController*)[timerEditViewController.viewControllers objectAtIndex:1];
    timerEditDetailViewController = [navigationController.viewControllers objectAtIndex:0];
    
    txtBlindSetName.text      = blindSet.blindSetName;
    switchPlaySound.on        = blindSet.playSound;
    switchBlindChangeAlert.on = blindSet.blindChangeAlert;
    switchMinuteAlert.on      = blindSet.minuteAlert;
    switchDoublePrevious.on   = blindSet.doublePrevious;
    
    [self localizeView];
}

-(void)localizeView {
    
    self.title = NSLocalizedString(@"Blind Set Config", "TimerEditMasterViewController");
    lblBlindSetName.text = NSLocalizedString(@"Name", "TimerEditMasterViewController");
    lblPlaySound.text = NSLocalizedString(@"Play sound", "TimerEditMasterViewController");
    lblMinuteAlert.text = NSLocalizedString(@"1 minute alert", "TimerEditMasterViewController");
    lblBlindChangeAlert.text = NSLocalizedString(@"Blind change alert", "TimerEditMasterViewController");
    lblDoublePrevious.text = NSLocalizedString(@"Double previous", "TimerEditMasterViewController");
}

-(void)viewDidAppear:(BOOL)animated{
    
    [txtBlindSetName becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if( [blindSet.blindSetName isEqualToString:@""] ){
        
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

    blindSet.blindSetName     = txtBlindSetName.text;
    blindSet.playSound        = switchPlaySound.on;
    blindSet.blindChangeAlert = switchBlindChangeAlert.on;
    blindSet.minuteAlert      = switchMinuteAlert.on;
    blindSet.doublePrevious   = switchDoublePrevious.on;
    
    if( ![self validateForm] )
        return;
    
    [appDelegate dismissRootViewController];
    
    if( blindSet.isNew == YES ){
        
        blindSet.isNew = NO;
        blindSet.blindSetId = rand();
        
        NSLog(@"blindSet.blindSetId: %i", blindSet.blindSetId);
        [appDelegate.blindSetList addObject:blindSet];
        [appDelegate dismissRootViewController];
    }

    if( appDelegate.blindSet.blindSetId==blindSet.blindSetId )
        appDelegate.blindSet = blindSet;
    
    NSLog(@"appDelegate.blindSetList: %@", appDelegate.blindSetList);
    
    [BlindSet archivedBlindSetList:appDelegate.blindSetList];
}

-(void)dismiss:(id)sender {
    
    [appDelegate dismissRootViewController];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    timerEditDetailViewController.title = newString;
    
    return YES;
}

@end
