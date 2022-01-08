//
//  iPadTimerViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-16.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPadTimerViewController.h"
#import "TimerLevelCell.h"
#import "TimerMenuCell.h"

@interface iPadTimerViewController ()

@end

@implementation iPadTimerViewController

@synthesize menuTable;
@synthesize content;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    btnTimerSwitchLocal   = (UIButton *)btnTimerSwitch;
    btnPreviousLevelLocal = (UIButton *)btnPreviousLevel;
    btnNextLevelLocal     = (UIButton *)btnNextLevel;
    
    //Find the path for the menu resource and load it into the menu array
    //add some gestures
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [btnResetButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnResetButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    btnPreviousLevelLocal.enabled = (blindSet.currentLevel > 1 );
    btnNextLevelLocal.enabled     = (blindSet.blindLevels > blindSet.currentLevel );
    
    [self localizeView];
    
    if( appDelegate.inverseColors ){
        
        buttonImage = [[UIImage imageNamed:@"whiteOpaqueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        buttonImageHighlight = [[UIImage imageNamed:@"whiteOpaqueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    }else{
        
        buttonImage = [[UIImage imageNamed:@"blackOpaqueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        buttonImageHighlight = [[UIImage imageNamed:@"blackOpaqueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    }
    
    [btnTimerSwitch setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnTimerSwitch setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnPreviousLevel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnPreviousLevel setBackgroundImage:buttonImage forState:UIControlStateDisabled];
    [btnPreviousLevel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnNextLevel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnNextLevel setBackgroundImage:buttonImage forState:UIControlStateDisabled];
    [btnNextLevel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else{
        
        menuNavigationBar.tintColor = [UIColor blackColor];
        menuToolbar.tintColor = [UIColor blackColor];
    }
    
    if( appDelegate.isIOS5 ){
        
        [btnEditTimerMenu setTitle:@"Edit"];
        [btnEditTimerMenu setStyle:UIBarButtonItemStyleBordered];
    }
    
    [menuTable setBackgroundColor:[UIColor clearColor]];
    
    if( LITE_VERSION )
        timerMenuNavigationItem.leftBarButtonItem  = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if( appDelegate.firstExecution ){
        
        [content addSubview:imgHand];
        [imgHand setFrame:CGRectMake(50, 250, imgHand.frame.size.width, imgHand.frame.size.height)];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:appDelegate.currentBlindSetIndex inSection:0];
    [menuTable reloadData];
    [menuTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    if( appDelegate.firstExecution ){
        
        [UIView animateWithDuration:0.75
                         animations:^{
                             
                             [imgHand setFrame:CGRectMake(imgHand.frame.origin.x+imgHand.frame.size.width, imgHand.frame.origin.y, imgHand.frame.size.width, imgHand.frame.size.height)];
                             imgHand.alpha = 0;
                         }
         ];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self hideMenu:YES];
    
    if( menuTable.isEditing )
        [self editBlindSets:nil];
}

-(void)localizeView {

    [super localizeView];
    
    [btnPreviousLevel setTitle:NSLocalizedString(@"Previous", @"TimerViewController") forState:UIControlStateNormal];
    [btnNextLevel setTitle:NSLocalizedString(@"Next", @"TimerViewController") forState:UIControlStateNormal];
    
    [btnTimerSwitch setTitle:NSLocalizedString((timerEnabled?@"PAUSE":@"START"), @"TimerViewController") forState:UIControlStateNormal];
    [timerMenuNavigationItem setTitle:NSLocalizedString(@"Blind Sets", @"TimerViewController")];
    [btnSettings setTitle:NSLocalizedString(@"Settings", @"TimerViewController")];
    [btnResetButton setTitle:NSLocalizedString(@"Reset current timer", @"TimerViewController") forState:UIControlStateNormal];
    
    lblNextLevelLabel.text   = NSLocalizedString(@"NEXT LEVEL", @"TimerViewController");
}

- (void)openCreateMenu:(id)sender {
    
    if( ![super openCreateMenu] )
        return;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad_Create_Menu" bundle:nil];
    UIViewController *createMenuViewController = [sb instantiateViewControllerWithIdentifier:@"CreateMenuViewController"];
    
    [appDelegate pushViewController:createMenuViewController];
    
    [self hideMenu:NO];
}

- (void)openConfig:(id)sender {
    
    [super openConfig:sender];
    [self hideMenu:NO];
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
    
    btnResetButton.frame = CGRectMake(10, 15, 255.0, 44);
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad_Timer_Edit" bundle:nil];
    TimerEditViewController *timerEditViewController = [storyBoard instantiateInitialViewController];
    timerEditViewController.blindSet = [[appDelegate.blindSetList objectAtIndex:indexPath.row] copy];
    
    [appDelegate pushViewController:timerEditViewController];
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


#pragma mark - animations -
-(void)showMenu:(BOOL)animated{
    
    if( animated ){
        
        //slide the content view to the right to reveal the menu
        [UIView animateWithDuration:.25
                         animations:^{
                             
                             [content setFrame:CGRectMake(menuTable.frame.size.width, content.frame.origin.y, content.frame.size.width, content.frame.size.height)];
                         }
         ];
    }else{
        
        [content setFrame:CGRectMake(menuTable.frame.size.width, content.frame.origin.y, content.frame.size.width, content.frame.size.height)];
    }
}

-(void)hideMenu:(BOOL)animated{
    
    if( animated ){
        //slide the content view to the left to hide the menu
        [UIView animateWithDuration:.25
                         animations:^{
                             
                             [content setFrame:CGRectMake(0, content.frame.origin.y, content.frame.size.width, content.frame.size.height)];
                         }
         ];
    }else{
        
        //slide the content view to the left to hide the menu
        [content setFrame:CGRectMake(0, 0, content.frame.size.width, content.frame.size.height)];
    }
    
}

#pragma mark - Gesture handlers -

-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    
    if(content.frame.origin.x != 0)
        [self hideMenu:YES];
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(content.frame.origin.x == 0)
        [self showMenu:YES];
}

- (void)previousLevel:(id)sender {
    
    [super previousLevel:sender];
    
    [tableViewLevelOverview reloadData];
    
    if( blindSet.currentLevel==1 )
        btnPreviousLevelLocal.enabled = NO;
    else
        btnPreviousLevelLocal.enabled = YES;
    
    if( blindSet.blindLevels > 1 )
        btnNextLevelLocal.enabled = YES;
    else
        btnNextLevelLocal.enabled = NO;
}

- (void)nextLevel:(id)sender {
    
    if( btnNextLevelLocal.enabled==NO ){
        
        if( timerEnabled )
            timerFinished = YES;
        return;
    }
    
    [super nextLevel:sender];
    
    [tableViewLevelOverview reloadData];
    
    if( blindSet.currentLevel==blindSet.blindLevels )
        btnNextLevelLocal.enabled = NO;
    else
        btnNextLevelLocal.enabled = YES;
    
    if( blindSet.currentLevel > 1 )
        btnPreviousLevelLocal.enabled = YES;
    else
        btnPreviousLevelLocal.enabled = NO;
}

- (void)resetTimer {
    
    [super resetTimer];
    
    btnPreviousLevelLocal.enabled = NO;
    btnNextLevelLocal.enabled     = YES;
    
    [tableViewLevelOverview reloadData];
}

-(void)updateCurrentLevel {
    
    [super updateCurrentLevel];
    
    int currentLevel = [blindSet currentLevel];
    
    BlindLevel *nextBlindLevel = [blindSet blindLevelByIndex: currentLevel];
    
    if( nextBlindLevel.isBreak ){
        
        lblNextSmallBlind.text   = @"";
        lblNextBigBlind.text     = NSLocalizedString(@"BREAK", @"TimerViewController");
        lblNextAnte.text         = @"";
    }else{
        
        if( appDelegate.shortBlindNumber && nextBlindLevel.smallBlind >= 1000 )
            lblNextSmallBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)nextBlindLevel.smallBlind/1000)];
        else
            lblNextSmallBlind.text = [NSString stringWithFormat:@"%i", nextBlindLevel.smallBlind];
        
        if( appDelegate.shortBlindNumber && nextBlindLevel.bigBlind >= 1000 )
            lblNextBigBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)nextBlindLevel.bigBlind/1000)];
        else
            lblNextBigBlind.text = [NSString stringWithFormat:@"%i", nextBlindLevel.bigBlind];
        
        if( appDelegate.shortBlindNumber && nextBlindLevel.ante >= 1000 )
            lblNextAnte.text = [NSString stringWithFormat:@"%1.1fK", ((float)nextBlindLevel.ante/1000)];
        else
            lblNextAnte.text = [NSString stringWithFormat:@"%i", nextBlindLevel.ante];
        
        lblNextSmallBlind.text = [lblNextSmallBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblNextBigBlind.text   = [lblNextBigBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblNextAnte.text       = [lblNextAnte.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    if( appDelegate.isIOS7 )
        [tableViewLevelOverview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:currentLevel-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    else
        [tableViewLevelOverview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentLevel-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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

-(void)startStopTimer:(id)sender {
    
    if( timerEnabled )
        [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController") forState:UIControlStateNormal];
    else
        [btnTimerSwitch setTitle:NSLocalizedString(@"PAUSE", @"TimerViewController") forState:UIControlStateNormal];
    
    [super startStopTimer:sender];
}

@end
