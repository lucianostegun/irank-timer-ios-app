//
//  iPhoneTimerMenuViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-20.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneTimerMenuViewController.h"
#import "TimerEditMasterViewController.h"

@interface iPhoneTimerMenuViewController ()

@end

@implementation iPhoneTimerMenuViewController
@synthesize menuTable;
@synthesize delegate;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    blindSet = appDelegate.blindSet;
    
    NSLog(@"blindSet.blindSetId: %i", blindSet.blindSetId);
    if( appDelegate.inverseColors ){
        
        highlightCellTextColor  = [UIColor blackColor];
        cellTextColor           = [UIColor darkGrayColor];
        currentLevelCellBgColor = darkSilverColor;
    }else{
        
        highlightCellTextColor  = [UIColor whiteColor];
        cellTextColor           = [UIColor grayColor];
        currentLevelCellBgColor = darkRedColor;
    }
    
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [btnResetButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnResetButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    if( appDelegate.isIOS5 ){
        
        [btnEditTimerMenu setTitle:@"Edit"];
        [btnEditTimerMenu setStyle:UIBarButtonItemStyleBordered];
    }
    
    if( LITE_VERSION )
        timerMenuNavigationItem.leftBarButtonItem  = nil;
    
    if( !appDelegate.isIOS7 ){
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.toolbar.tintColor = [UIColor blackColor];
    }
    
    [self localizeView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self.navigationController setToolbarHidden:NO];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:appDelegate.currentBlindSetIndex inSection:0];
    [menuTable reloadData];
    [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

-(void)localizeView {

    [timerMenuNavigationItem setTitle:NSLocalizedString(@"Blind Sets", @"TimerViewController")];
    [btnResetButton setTitle:NSLocalizedString(@"Reset current timer", @"TimerViewController") forState:UIControlStateNormal];
    [btnSettings setTitle:NSLocalizedString(@"Settings", @"TimerViewController")];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableView Datasource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if( tableView.tag==0 )
        return appDelegate.blindSetList.count;
    
    return blindSet.blindLevels;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if( tableView.tag==0 )
        return 1;
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"TimerMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    BlindSet *aBlindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
    
    NSString *levels = [NSString stringWithFormat:@"%i %@", aBlindSet.levels, NSLocalizedString((aBlindSet.levels==1?@"level":@"levels"), @"TimerViewController")];
    
    NSString *breaks;
    if( aBlindSet.breaks > 0 )
        breaks = [NSString stringWithFormat:@"%i %@", aBlindSet.breaks, NSLocalizedString(((aBlindSet.breaks==1?@"break":@"breaks")), @"TimerViewController")];
    else
        breaks = NSLocalizedString(@"No breaks menu", @"TimerViewController");
    
    cell.textLabel.text       = aBlindSet.blindSetName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@  %@", levels, breaks, aBlindSet.duration];
    
    if( appDelegate.isIOS7 ){
        
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor lightGrayColor]];
        [cell setSelectedBackgroundView:bgColorView];
        
        cell.textLabel.highlightedTextColor = [UIColor darkTextColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor darkTextColor];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    if( menuTable.isEditing && indexPath.row!=appDelegate.currentBlindSetIndex )
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setBackgroundColor:darkSilverColor];
    [cell.backgroundView setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( tableView.tag==0 )
        return 44;
    
    return 38;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if( tableView.tag==1 )
        return nil;
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 54)];
    
    btnResetButton.frame = CGRectMake(10, 15, (isShowingLandscapeView?SCREEN_HEIGHT:SCREEN_WIDTH)-20, 44);
    [customView addSubview:btnResetButton];
    
    return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if( tableView.tag==0 )
        return 50;
    
    return 0;
}

#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if( tableView.tag==1 )
        return;
    
    BlindSet *aBlindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
    
    if( blindSet.blindSetId==aBlindSet.blindSetId )
        return;
    
    blindSet = aBlindSet;
    
    [menuTable setEditing:NO animated:NO];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:NSLocalizedString(@"Select a different blind set will reset the current timer. Do you want to change?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"Reset Timer", @"TimerViewController"), nil];
    alertView.tag = indexPath.row;
    [alertView show];
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"EditBlindSetSegue" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If the table view is asking to commit a delete command...
    if( editingStyle == UITableViewCellEditingStyleDelete ){
        
        [appDelegate.blindSetList removeObjectAtIndex:indexPath.row];
        
        // we also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        indexPath = [tableView indexPathForSelectedRow];
        
        if( appDelegate.blindSetList.count==1 && menuTable.isEditing )
            [self editBlindSets:nil];
        
        appDelegate.currentBlindSetIndex = indexPath.row;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // All other rows remain deletable
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( tableView.tag==1 )
        return NO;
    
    BlindSet *aBlindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
    
    if( blindSet.blindSetId==aBlindSet.blindSetId )
        return NO;
    
    // Return NO if you do not want the specified item to be editable.
    return (appDelegate.blindSetList.count > 1 && tableView.isEditing && indexPath.section==0);
}

#pragma mark - Actions -
-(void)openCreateMenu:(id)sender {
    
    if( LITE_VERSION ){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:NSLocalizedString(@"This feature is not enabled in lite version of this app. Would you like to download the full version at App Store?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"Not now", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"DOWNLOAD", @"TimerViewController"), nil];
        alertView.tag = -1;
        [alertView show];
    }else{
        
        [self performSegueWithIdentifier:@"OpenCreateMenu" sender:nil];
    }
}

-(void)editBlindSets:(id)sender {
    
    if( menuTable.isEditing ){
        
        timerMenuNavigationItem.leftBarButtonItem = btnEditTimerMenu;
        
        NSIndexPath *indexPath = [menuTable indexPathForSelectedRow];
        [menuTable setEditing:NO animated:YES];
        [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        menuTable.allowsSelectionDuringEditing = YES;
    }else{
        
        timerMenuNavigationItem.leftBarButtonItem = btnDoneEditingTimerMenu;
        
        NSIndexPath *indexPath = [menuTable indexPathForSelectedRow];
        
        [menuTable setEditing:YES animated:YES];
        
        menuTable.sectionIndexMinimumDisplayRowCount = NSIntegerMax; // Isso corrige um bug do iOS 7 que sobrepõe o botão excluir da celula
        
        
        [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        menuTable.allowsSelectionDuringEditing = NO;
    }
}

- (void)resetTimer:(id)sender {

//    [super resetTimer];
//    
//    btnPreviousLevelLocal.enabled = NO;
//    btnNextLevelLocal.enabled     = YES;
//    
//    [tableViewLevelOverview reloadData];
    
    NSLog(@"delegate: %@", delegate);
    
    [delegate performSelector:@selector(resetTimer:) withObject:self];
    [self dismiss:nil];
}

-(void)dismiss:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)awakeFromNib {
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    isShowingLandscapeView = UIDeviceOrientationIsLandscape(deviceOrientation);
                              
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView){
        
        NSLog(@"Passou por aqui LANDSCAPE");
        
        isShowingLandscapeView = YES;
        
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView) {
        
        NSLog(@"Passou por aqui PORTRAIT");
        
        isShowingLandscapeView = NO;
    }
    
    NSIndexPath *indexPath = [menuTable indexPathForSelectedRow];
    [menuTable reloadData];
    [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)alertView:(UIAlertView *)pAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch( pAlertView.tag ){
        case -1:
            if (buttonIndex == 1){
                
                NSString *appUrl = [NSString stringWithFormat:APP_URL, appDelegate.language];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appUrl]];
            }
            break;
        default:
            if (buttonIndex == 1){
                
                appDelegate.currentBlindSetIndex = pAlertView.tag;
                appDelegate.blindSet = blindSet;
                [delegate performSelector:@selector(setBlindSet:) withObject:blindSet];
                [delegate performSelector:@selector(resetTimer)];
                [self dismiss:nil];
            }else{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:appDelegate.currentBlindSetIndex inSection:0];
                [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                blindSet = [appDelegate.blindSetList objectAtIndex:appDelegate.currentBlindSetIndex];
            }
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if( [segue.identifier isEqualToString:@"EditBlindSetSegue"] ){
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        TimerEditMasterViewController *viewController = (TimerEditMasterViewController *)segue.destinationViewController;
        viewController.blindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
    }
}
@end
