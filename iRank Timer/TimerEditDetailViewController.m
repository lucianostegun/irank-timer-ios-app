//
//  TimerEditViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-21.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerEditDetailViewController.h"

@interface TimerEditDetailViewController ()

@end

@implementation TimerEditDetailViewController
@synthesize blindSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( IS_IPAD ){
     
        TimerEditViewController *timerEditViewController = (TimerEditViewController*)self.parentViewController.parentViewController;
        blindSet = timerEditViewController.blindSet;
    }
    
    NSLog(@"blindSet: %@", blindSet);
    
    self.title = blindSet.blindSetName;
    
    lblElapsedList = [[NSMutableArray alloc] init];
    
    if( IS_IPAD ){
        
        [self resetTextFieldList];
        [[self tableView] setEditing: YES];
    }
    
    viewLoaded = false;
    
    [self localizeView];
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else{
        
        ((UINavigationController *)self.parentViewController).navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

-(void)localizeView {
    
    [btnNewLevel setTitle:NSLocalizedString(@"New level", "TimerEditDetailViewController")];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if( IS_IPAD )
        [self reloadTextFieldList];
    
    [super viewDidAppear:animated];
    
    viewLoaded = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"blindSet.blindLevels: %i", blindSet.blindLevels);
    return blindSet.blindLevels;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BlindLevelCell";

    BlindLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
        cell = [[BlindLevelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if( indexPath.row % 2 == 0 )
        cell.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:100];
    else
        cell.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:100];
    
    BlindLevel *blindLevel = [blindSet blindLevelByIndex:indexPath.row];
    
    if( blindLevel.isBreak ){
        
        [cell.lblLevel setHidden:YES];
        [cell.txtSmallBlind setHidden:YES];
        [cell.txtBigBlind setHidden:YES];
        [cell.txtAnte setHidden:YES];
        [cell.imgFieldSeparator1 setHidden:YES];
        [cell.imgFieldSeparator2 setHidden:YES];
        [cell.imgFieldSeparator3 setHidden:YES];
        [cell.imgFieldSeparator4 setHidden:YES];
    }else{
        
        [cell.lblLevel setHidden:NO];
        [cell.txtSmallBlind setHidden:NO];
        [cell.txtBigBlind setHidden:NO];
        [cell.txtAnte setHidden:NO];
        [cell.imgFieldSeparator1 setHidden:NO];
        [cell.imgFieldSeparator2 setHidden:NO];
        [cell.imgFieldSeparator3 setHidden:NO];
        [cell.imgFieldSeparator4 setHidden:NO];
        
        [textFieldList addObject:cell.txtSmallBlind];
        [textFieldList addObject:cell.txtBigBlind];
        [textFieldList addObject:cell.txtAnte];
        
        cell.lblLevel.text      = [NSString stringWithFormat:@"%i", blindLevel.levelNumber];
        cell.txtSmallBlind.text = [NSString stringWithFormat:@"%i", blindLevel.smallBlind];
        cell.txtBigBlind.text   = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
        cell.txtAnte.text       = [NSString stringWithFormat:@"%i", blindLevel.ante];
    }

    cell.lblElapsed.tag = indexPath.row;
    
    [lblElapsedList addObject:cell.lblElapsed];
    
    if( !appDelegate.isIOS5 )
        [textFieldList addObject:cell.txtDuration];
    
    if( viewLoaded && !appDelegate.isIOS5 )
        [self reloadTextFieldList];
    
    cell.txtDuration.delegate = self;
    
    cell.lblElapsed.text  = blindLevel.elapsedTime;
    cell.txtDuration.text = [NSString stringWithFormat:@"%i", blindLevel.duration];
    cell.isBreak.on       = blindLevel.isBreak;
    cell.isBreak.tag      = indexPath.row;
    
    cell.txtSmallBlind.tag = indexPath.row;
    cell.txtBigBlind.tag   = indexPath.row;
    cell.txtAnte.tag       = indexPath.row;
    cell.txtDuration.tag   = indexPath.row;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if( appDelegate.isIOS7 )
        return NSLocalizedString(@"header-ios7", "TimerEditDetailViewController");
    else
        return NSLocalizedString(@"header", "TimerEditDetailViewController");
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    NSString *levels = [NSString stringWithFormat:@"%i %@", blindSet.levels, NSLocalizedString((blindSet.levels==1?@"level":@"levels"), @"TimerViewController")];
    NSString *breaks;

    if( blindSet.breaks > 0 )
        breaks = [NSString stringWithFormat:@"%i %@", blindSet.breaks, NSLocalizedString((blindSet.breaks==1?@"break":@"breaks"), @"TimerViewController")];
    else
        breaks = NSLocalizedString(@"No breaks", @"TimerViewController");
    
    return [NSString stringWithFormat:@"%@ / %@ / %@", levels, breaks, blindSet.duration];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return blindSet.levels > 1;
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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If the table view is asking to commit a delete command...
    if( editingStyle == UITableViewCellEditingStyleDelete ){
        NSLog(@"blindSet.blindLevelList: %@", blindSet.blindLevelList);
        [blindSet.blindLevelList removeObjectAtIndex:indexPath.row];
        
        // we also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [blindSet resetLevelNumbers];
    }
    
    [self.tableView reloadData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // All other rows remain deletable
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // Get pointer to object being moved
    BlindLevel *blindLevel = [blindSet.blindLevelList objectAtIndex:[sourceIndexPath row]];
    
    // Remove p from our array, it is automatically sent release
    [blindSet.blindLevelList removeObjectAtIndex:[sourceIndexPath row]]; // Retain count of p is now 1
    
    // Re-inser p into array at new location, it is automatically retained
    [blindSet.blindLevelList insertObject:blindLevel atIndex:[destinationIndexPath row]]; // Retain count of p is now 2
    [blindSet resetLevelNumbers];
    [[self tableView] reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return proposedDestinationIndexPath;
}

- (void)switchLevelBreak:(id)sender {
    
    UISwitch *switchBreak = (UISwitch *) sender;
    int index = switchBreak.tag;
    
    [[blindSet blindLevelByIndex:index] setIsBreak:switchBreak.isOn];
    [blindSet resetLevelNumbers];

    [[self tableView] reloadData];
    [self reloadTextFieldList];
}

-(void)addBlindLevel:(id)sender {
    
    if( ![self checkLiteVersion] )
        return;
    
    int blindLevels = blindSet.levels;
    BlindLevel *lastBlindLevel = [blindSet blindLevelByNumber:blindLevels];
    
    int smallBlind = 0;
    int bigBlind   = 0;
    int ante       = lastBlindLevel.ante;
    int duration   = lastBlindLevel.duration;
    
    if( blindSet.doublePrevious && lastBlindLevel!=nil ){
        
        smallBlind = lastBlindLevel.smallBlind*2;
        bigBlind   = lastBlindLevel.bigBlind*2;
    }
    
    BlindLevel *blindLevel = [[BlindLevel alloc] initWithLevelNumber:blindLevels levelIndex:blindSet.blindLevels smallBlind:smallBlind bigBlind:bigBlind ante:ante duration:duration];
    [blindSet addBlindLevel:blindLevel];
    
    [blindSet resetLevelNumbers];

    [[self tableView] reloadData];
    [self reloadTextFieldList];
}

-(BOOL)checkLiteVersion {
    
    if( LITE_VERSION ){
        
        if( blindSet.blindLevels < 15 )
            return YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LITE VERSION", @"TimerEditViewController") message:NSLocalizedString(@"The lite version of this app allows you add up to 15 levels. Download the full version at App Store and get unlimited levels.", @"TimerEditDetailViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"Not now", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"DOWNLOAD", @"TimerEditDetailViewController"), nil];
        alertView.tag = 2;
        [alertView show];
        
        return NO;
    }
    
    return YES;
}












#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    NSLog(@"textFieldDidBeginEditing");
    
    if( !appDelegate.isIOS5 )
        [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    NSLog(@"textViewDidBeginEditing");
    if( !appDelegate.isIOS5  )
        [self.keyboardControls setActiveField:textView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    
    UIView *view = keyboardControls.activeField.superview.superview;
    [self.tableView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    
    [keyboardControls.activeField resignFirstResponder];
}

-(void)resetTextFieldList {
    
    textFieldList = [[NSMutableArray alloc] init];
}

-(void)reloadTextFieldList {

    if( !appDelegate.isIOS5  ){

        [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:textFieldList]];
        [self.keyboardControls setDelegate:self];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    BlindLevel *blindLevel = [blindSet blindLevelByIndex:textField.tag];
    int integerValue       = [textField.text integerValue];
    int minLength          = 0;
    
    if( [textField.placeholder isEqualToString:@"SB"] ){
        blindLevel.smallBlind = integerValue;

        if( blindLevel.bigBlind==0 ){

            blindLevel.bigBlind = integerValue*2;
            UITextField *txtBigBlind = [textField.superview.subviews objectAtIndex:2];
            txtBigBlind.text = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
        }
        
    }
    
    if( [textField.placeholder isEqualToString:@"DUR"] )
        minLength = 1;
    
    if( textField.text.length < minLength )
        return NO;
    
    if( [textField.placeholder isEqualToString:@"DUR"] ){
        
        [blindSet resetLevelNumbers];
        
        [self.tableView reloadData];
        [self performSelector:(@selector(refreshDisplay:)) withObject:nil afterDelay:0.1];
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
        
        if( !appDelegate.isIOS5 )
            [self.tableView footerViewForSection:indexPath.section].textLabel.text = [self tableView:self.tableView titleForFooterInSection:indexPath.section];
    }
    
    return YES;
}

- (void)refreshDisplay:(NSIndexPath *)indexPath {
    
    for( UILabel *lblElapsed in lblElapsedList )
        lblElapsed.text = [[blindSet blindLevelByIndex:lblElapsed.tag] elapsedTime];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if( ![myCharSet characterIsMember:c] )
            return NO;
    }
    
    int maxLength = 6;
    
    if( [textField.placeholder isEqualToString:@"DUR"] )
        maxLength = 2;
    
    /*  limit the users input to only X characters  */
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if( newLength > maxLength )
        return NO;
    
    BlindLevel *blindLevel = [blindSet blindLevelByIndex:textField.tag];
    NSString *newString    = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int integerValue       = [newString integerValue];
    
    if( [textField.placeholder isEqualToString:@"BB"] )
        blindLevel.bigBlind = integerValue;
    else if( [textField.placeholder isEqualToString:@"ANTE"] )
        blindLevel.ante = integerValue;
    else if( [textField.placeholder isEqualToString:@"DUR"] )
        blindLevel.duration = integerValue;
    
    [blindSet resetLevelNumbers];
    
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
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
