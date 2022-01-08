//
//  TimerMenuViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-20.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerMenuViewController.h"

@interface TimerMenuViewController ()

@end

@implementation TimerMenuViewController
@synthesize menuTable;
@synthesize delegate;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    blindSet = appDelegate.blindSet;
    
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
    
    [self localizeView];
}

-(void)localizeView {
    
    [btnResetButton setTitle:NSLocalizedString(@"Reset current timer", @"TimerViewController") forState:UIControlStateNormal];
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
    
    if( tableView.tag==0 ){
        
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
    
    static NSString *CellIdentifier = @"TimerLevelCell";
    
    int levelNumber = indexPath.row+1;
    
    TimerLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
        cell = [[TimerLevelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    UIFont *normalFont = [UIFont systemFontOfSize:17];
    UIFont *boldFont   = [UIFont boldSystemFontOfSize:17];
    
    BlindLevel *aBlindLevel = [blindSet blindLevelByIndex:indexPath.row];
    
    if( aBlindLevel.isBreak ){
        
        cell.lblLevel.text      = @" ";
        cell.lblSmallBlind.text = @" ";
        cell.lblBigBlind.text   = NSLocalizedString(@"B R E A K", @"TimerViewController");
        cell.lblAnte.text       = @" ";
    }else{
        
        cell.lblLevel.text      = [NSString stringWithFormat:@"%i", aBlindLevel.levelNumber];
        cell.lblSmallBlind.text = [NSString stringWithFormat:@"%i", aBlindLevel.smallBlind];
        cell.lblBigBlind.text   = [NSString stringWithFormat:@"%i", aBlindLevel.bigBlind];
        cell.lblAnte.text       = [NSString stringWithFormat:@"%i", aBlindLevel.ante];
        
        if( appDelegate.shortBlindNumber ){
            
            if( aBlindLevel.smallBlind >= 1000 )
                cell.lblSmallBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)aBlindLevel.smallBlind/1000)];
            
            if( aBlindLevel.bigBlind >= 1000 )
                cell.lblBigBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)aBlindLevel.bigBlind/1000)];
            
            if( aBlindLevel.ante >= 1000 )
                cell.lblAnte.text = [NSString stringWithFormat:@"%1.1fK", ((float)aBlindLevel.ante/1000)];
            
            cell.lblSmallBlind.text = [cell.lblSmallBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
            cell.lblBigBlind.text   = [cell.lblBigBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
            cell.lblAnte.text       = [cell.lblAnte.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    
    cell.lblDuration.text = [NSString stringWithFormat:@"%i %@", aBlindLevel.duration, NSLocalizedString(@"min.", @"TimerViewController")];
    cell.lblElapsed.text  = [NSString stringWithFormat:@"%@", aBlindLevel.elapsedTime];
    
    if( levelNumber==blindSet.currentLevel ){
        
        cell.lblLevel.font      = boldFont;
        cell.lblSmallBlind.font = boldFont;
        cell.lblBigBlind.font   = boldFont;
        cell.lblAnte.font       = boldFont;
        cell.lblDuration.font   = boldFont;
        cell.lblElapsed.font    = boldFont;
        
        cell.lblLevel.textColor      = highlightCellTextColor;
        cell.lblSmallBlind.textColor = highlightCellTextColor;
        cell.lblBigBlind.textColor   = highlightCellTextColor;
        cell.lblAnte.textColor       = highlightCellTextColor;
        cell.lblDuration.textColor   = highlightCellTextColor;
        cell.lblElapsed.textColor    = highlightCellTextColor;
        
        cell.contentView.backgroundColor = currentLevelCellBgColor;
    }else{
        
        cell.lblLevel.font      = normalFont;
        cell.lblSmallBlind.font = normalFont;
        cell.lblBigBlind.font   = normalFont;
        cell.lblAnte.font       = normalFont;
        cell.lblDuration.font   = normalFont;
        cell.lblElapsed.font    = normalFont;
        
        cell.lblLevel.textColor      = cellTextColor;
        cell.lblSmallBlind.textColor = cellTextColor;
        cell.lblBigBlind.textColor   = cellTextColor;
        cell.lblAnte.textColor       = cellTextColor;
        cell.lblDuration.textColor   = cellTextColor;
        cell.lblElapsed.textColor    = cellTextColor;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    if( appDelegate.isIOS7 )
        [cell setBackgroundColor:[UIColor clearColor]];
    
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
    appDelegate.currentBlindSetIndex = indexPath.row;
    
    [menuTable setEditing:NO animated:NO];
    
    [self resetTimer:nil];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad_Timer_Edit" bundle:nil];
//    TimerEditViewController *timerEditViewController = [storyBoard instantiateInitialViewController];
//    timerEditViewController.blindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
//    
//    [appDelegate pushViewController:timerEditViewController];
//}

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
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad_Create_Menu" bundle:nil];
    UIViewController *createMenuViewController = [sb instantiateViewControllerWithIdentifier:@"CreateMenuViewController"];
    
    [appDelegate pushViewController:createMenuViewController];
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
    
    [delegate performSelector:@selector(resetTimer:) withObject:nil];
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
    
    [menuTable reloadData];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView){
        
        NSLog(@"Passou por aqui LANDSCAPE");
        
        isShowingLandscapeView = YES;
        
    }else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView) {
        
        NSLog(@"Passou por aqui PORTRAIT");
        
        isShowingLandscapeView = NO;
    }
}

@end
