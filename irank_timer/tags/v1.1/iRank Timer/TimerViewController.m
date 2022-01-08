//
//  TimerViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-19.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerLevelCell.h"
#import "TimerMenuCell.h"
#import "TimerEditViewController.h"

@interface UIColor (MyProject)

+(UIColor *) darkRedColor;
+(UIColor *) darkRed2Color;

@end

@implementation UIColor (MyProject)

+(UIColor *) darkRedColor { return [UIColor colorWithRed:0.278 green:0.047 blue:0.016 alpha:0.40]; }
+(UIColor *) darkSilverColor { return [UIColor colorWithRed:0.178 green:0.178 blue:0.178 alpha:0.40]; }
+(UIColor *) darkRed2Color { return [UIColor colorWithRed:0.7 green:0.165 blue:0.114 alpha:1]; }

@end



@implementation TimerViewController

@synthesize
menuTable,
content;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //Find the path for the menu resource and load it into the menu array
    //add some gestures
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    blindSet   = appDelegate.blindSet;
    blindLevel = [blindSet currentBlindLevel];
    
    [blindSet updateNextBreakRemain];
    
    currentElapsedTime = 0;
    timerPauseSeconds  = 0;
    timerEnabled       = NO;
    timerStarted       = NO;
    timerFinished      = NO;
    backgroundColor    = @"blue";
    
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [btnResetButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnResetButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    timer = nil;
    alertView = nil;
    
    [self configureTimeBank];
    [self updateCurrentLevel];
    [self localizeView];
    
    btnPreviousLevel.enabled = (blindSet.currentLevel > 1 );
    btnNextLevel.enabled     = (blindSet.blindLevels > blindSet.currentLevel );
    
    if( appDelegate.inverseColors ){
     
        timerTextColor          = [UIColor blackColor];
        timerShadowColor        = [UIColor grayColor];
        timerWarningShadowColor = [UIColor darkGrayColor];
        warningColor            = [UIColor darkRed2Color];
        
        highlightCellTextColor = [UIColor blackColor];
        cellTextColor          = [UIColor darkGrayColor];
        currentLevelCellBgColor = [UIColor darkSilverColor];
        
        timerBgImageName    = @"timer-white-bg.png";
        timerBgRedImageName = @"timer-red-white-bg.png";
        
        buttonImage = [[UIImage imageNamed:@"whiteOpaqueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        buttonImageHighlight = [[UIImage imageNamed:@"whiteOpaqueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    }else{
        
        timerTextColor          = [UIColor whiteColor];
        timerShadowColor        = [UIColor blackColor];
        timerWarningShadowColor = [UIColor darkRedColor];
        warningColor            = [UIColor darkRed2Color];
        
        highlightCellTextColor  = [UIColor whiteColor];
        cellTextColor           = [UIColor grayColor];
        currentLevelCellBgColor = [UIColor darkRedColor];
        
        timerBgImageName    = @"timer-blue-bg.png";
        timerBgRedImageName = @"timer-red-bg.png";
        
        buttonImage = [[UIImage imageNamed:@"blackOpaqueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        buttonImageHighlight = [[UIImage imageNamed:@"blackOpaqueButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    }
    
    [btnTimerSwitch setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnTimerSwitch setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnPreviousLevel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnPreviousLevel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [btnNextLevel setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnNextLevel setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    NSLog(@"viewDidLoad");
    
    if( appDelegate.isIOS7 ){
        
        if( !appDelegate.inverseColors )
            [self setNeedsStatusBarAppearanceUpdate];
    }else{
        
        menuNavigationBar.tintColor = [UIColor blackColor];
        menuToolbar.tintColor = [UIColor blackColor];
    }
    
    [menuTable setBackgroundColor:[UIColor clearColor]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    if( !appDelegate.inverseColors )
        return UIStatusBarStyleLightContent;
    
    return UIStatusBarStyleDefault;
}

-(void)dealloc {
    
    NSLog(@"dealloc");
}

-(void)localizeView {
    
    lblElapsedTimeLabel.text = NSLocalizedString(@"ELAPSED", @"TimerViewController");
    lblNextBreakLabel.text   = NSLocalizedString(@"NEXT BREAK", @"TimerViewController");
    lblNextLevelLabel.text   = NSLocalizedString(@"NEXT LEVEL", @"TimerViewController");
    lblLevelLabel.text       = NSLocalizedString(@"LEVEL", @"TimerViewController");
    lblDurationLabel.text    = NSLocalizedString(@"DURATION", @"TimerViewController");
    lblElapsedLabel.text     = NSLocalizedString(@"ELAPSED", @"TimerViewController");
    
    [btnPreviousLevel setTitle:NSLocalizedString(@"Previous", @"TimerViewController") forState:UIControlStateNormal];
    [btnNextLevel setTitle:NSLocalizedString(@"Next", @"TimerViewController") forState:UIControlStateNormal];
    
    [btnTimerSwitch setTitle:NSLocalizedString((timerEnabled?@"PAUSE":@"START"), @"TimerViewController") forState:UIControlStateNormal];
    [timerMenuNavigationItem setTitle:NSLocalizedString(@"Blind Sets", @"TimerViewController")];
    [btnSettings setTitle:NSLocalizedString(@"Settings", @"TimerViewController")];
    [btnResetButton setTitle:NSLocalizedString(@"Reset current timer", @"TimerViewController") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateTimerLabel];
    
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
    
    [self hideMenu:YES];
    
    if( menuTable.isEditing )
        [self editBlindSets:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [cell setBackgroundColor:[UIColor darkSilverColor]];
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
    timerEditViewController.blindSet = [appDelegate.blindSetList objectAtIndex:indexPath.row];
    
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


#pragma mark - Actions -
- (IBAction)openCreateMenu:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad_Create_Menu" bundle:nil];
    UIViewController *createMenuViewController = [sb instantiateViewControllerWithIdentifier:@"CreateMenuViewController"];
    
    [appDelegate pushViewController:createMenuViewController];
    [self hideMenu:NO];
}

- (IBAction)openConfig:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad_Config" bundle:nil];
    UIViewController *configViewController = [sb instantiateViewControllerWithIdentifier:@"ConfigViewController"];
    
    [appDelegate pushViewController:configViewController];
    [self hideMenu:NO];
}

- (void)previousLevel:(id)sender {
    
    timerFinished = NO;
    
    currentElapsedTime = 0;
    [blindSet previousLevel];
    [tableViewLevelOverview reloadData];
    [self updateCurrentLevel];

    if( blindSet.currentLevel==1 )
        btnPreviousLevel.enabled = NO;
    else
        btnPreviousLevel.enabled = YES;
    
    if( blindSet.blindLevels > 1 )
        btnNextLevel.enabled = YES;
    else
        btnNextLevel.enabled = NO;
}

- (void)nextLevel:(id)sender {
    
    if( btnNextLevel.enabled==NO ){
        
        if( timerEnabled )
            timerFinished = YES;
        return;
    }
    
    timerFinished = NO;
    
    currentElapsedTime = 0;
    [blindSet nextLevel];
    [tableViewLevelOverview reloadData];
    [self updateCurrentLevel];

    if( blindSet.currentLevel==blindSet.blindLevels )
        btnNextLevel.enabled = NO;
    else
        btnNextLevel.enabled = YES;
    
    if( blindSet.currentLevel > 1 )
        btnPreviousLevel.enabled = YES;
    else
        btnPreviousLevel.enabled = NO;
}

-(void)startStopTimer:(id)sender {
    
    if( timer==nil && !timerStarted )
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    
    if( timerEnabled ){
        
        timerEnabled = NO;
        [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController") forState:UIControlStateNormal];
        [self performSelector:@selector(runPauseTimer) withObject:self afterDelay:1.0];
    }else{
        
        timerEnabled      = YES;
        timerStarted      = YES;
        timerPauseSeconds = 0;
        [btnTimerSwitch setTitle:NSLocalizedString(@"PAUSE", @"TimerViewController") forState:UIControlStateNormal];
    }
    
    [audioPlayer stop];
}

- (void)resetTimer:(id)sender {
    
    NSString *message;
    
    if( sender==nil )
        message = NSLocalizedString(@"Select a different blind set will reset the current timer. Do you want to change?", @"TimerViewController");
    else
        message = NSLocalizedString(@"Are you sure you want to reset the current timer?", @"TimerViewController");
        
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONFIRM", @"TimerViewController") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"TimerViewController") otherButtonTitles:NSLocalizedString(@"Reset Timer", @"TimerViewController"), nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)resetTimer {
    
    timerFinished      = NO;
    timerEnabled       = NO;
    timerStarted       = NO;
    currentElapsedTime = 0;
    
    btnPreviousLevel.enabled = NO;
    btnNextLevel.enabled     = YES;
    
    timerPauseSeconds = 0;
    [btnTimerSwitch setTitle:NSLocalizedString(@"START", @"TimerViewController") forState:UIControlStateNormal];
    
    [blindSet resetLevels];
    [tableViewLevelOverview reloadData];
    [self updateCurrentLevel];
    [audioPlayer stop];
}

-(void)updateCurrentLevel {
    
    blindLevel = [blindSet currentBlindLevel];
    
    if( blindLevel.isBreak ){
        
        lblCurrentLevel.text = @"-";
        lblSmallBlind.text   = @" ";
        lblBigBlind.text     = NSLocalizedString(@"BREAK", @"TimerViewController");
        lblAnte.text         = @" ";
        
//        lblBigBlind.frame = CGRectMake(lblBigBlind.frame.origin.x, lblBigBlind.frame.origin.y, 396*2, lblBigBlind.frame.size.height);
    }else{

        lblCurrentLevel.text = [NSString stringWithFormat:@"%i", blindLevel.levelNumber];
        
        if( appDelegate.shortBlindNumber && blindLevel.smallBlind >= 1000 )
            lblSmallBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.smallBlind/1000)];
        else
            lblSmallBlind.text = [NSString stringWithFormat:@"%i", blindLevel.smallBlind];
        
        if( appDelegate.shortBlindNumber && blindLevel.bigBlind >= 1000 )
            lblBigBlind.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.bigBlind/1000)];
        else
            lblBigBlind.text = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
        
        if( appDelegate.shortBlindNumber && blindLevel.ante >= 1000 )
            lblAnte.text = [NSString stringWithFormat:@"%1.1fK", ((float)blindLevel.ante/1000)];
        else
            lblAnte.text = [NSString stringWithFormat:@"%i", blindLevel.ante];
        
        lblSmallBlind.text = [lblSmallBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblBigBlind.text   = [lblBigBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        lblAnte.text       = [lblAnte.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
//        lblBigBlind.frame = CGRectMake(lblBigBlind.frame.origin.x, lblBigBlind.frame.origin.y, 396, lblBigBlind.frame.size.height);
    }
    
    lblTimer.text = [BlindSet formatTimeString:blindLevel.seconds];
    timerSlider.maximumValue = (float)blindLevel.seconds;
    timerSlider.value        = (float)blindLevel.seconds;

    lblElapsedTime.text = blindSet.elapsedtime;

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
    
    [tableViewLevelOverview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:currentLevel-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self updateTimerLabel];
}

-(void)changeCurrentTime:(id)sender {
    
    currentElapsedTime  = blindLevel.seconds;
    currentElapsedTime -= (int)timerSlider.value;
    [self updateTimerLabel];
    
    [audioPlayer stop];
}

-(void)runTimer {
    
    if( !timerEnabled )
        return;
    
    currentElapsedTime++;
    timerSlider.value = (float)(blindLevel.seconds-currentElapsedTime);
    
    // ------------------TIMEBANK---------------------
//    if( timerSlider.value==30 )
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStartTimeBank object:nil userInfo:nil];
//
//    if( timeBank > 0 )
//        lblTimeBank.text = [NSString stringWithFormat:@"%i", timeBank];
//    else if( timeBank == 0 )
//        lblTimeBank.text = @"FOLD";
//    
//    if( timeBank < -3 )
//        [timeBankView setHidden:YES];
//    else
//        timeBank--;
    // ------------------TEMPORARIO---------------------
    
    
//    NSLog(@"currentElapsedTime: %i", currentElapsedTime);
    
    [self updateTimerLabel];
    
    if( timerSlider.value == 0 && blindSet.blindChangeAlert && !timerFinished ){
        
        [self playSound: appDelegate.blindChangeSound];
        [self nextLevel:nil];
        
        if( [[UIApplication sharedApplication] applicationState] ==UIApplicationStateBackground )
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBlindLevelChange object:blindLevel userInfo:nil];
        
    }else if( timerSlider.value == 60 && blindLevel.seconds > 60 && blindSet.minuteAlert ){
        
        if( !audioPlayer.playing )
            [self playSound: appDelegate.minuteNotifySound];
    }else if( timerSlider.value == 5 && appDelegate.fiveSecondsClock ){
        
        if( !audioPlayer.playing )
            [self playSound: @"clock-tick"];
    }
}

-(void)runPauseTimer {
    
    timerPauseSeconds++;
    
    if( !timerStarted || timerEnabled || !appDelegate.longPauseAlert )
        return;
    
    BOOL continueCounting = YES;
    
    if( timerPauseSeconds % 60 == 0 && timerStarted ){
        
        if( alertView==nil ){
            
            alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TIMER IS PAUSED", @"TimerViewController") message:NSLocalizedString(@"Timer is paused for a long time.\nWould you like to resume timer now?", @"TimerViewController") delegate:self cancelButtonTitle:NSLocalizedString(@"NO", "TimerViewController") otherButtonTitles:NSLocalizedString(@"RESUME", @"TimerViewController"), nil];
            alertView.tag = 0;
            [alertView show];
            
            [self playSound:@"pulse" loops:4];
            
            // Isso é para que só de o alerta uma vez se estiver em segundo plano
            if( [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground )
                continueCounting = NO;
        }
    }
    
    if( continueCounting )
        [self performSelector:@selector(runPauseTimer) withObject:self afterDelay:1.0];
}

- (void)alertView:(UIAlertView *)pAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch( pAlertView.tag ){
        case 0:
            if (buttonIndex == 1)
                [self startStopTimer:nil];
            break;
        case 1:
            if (buttonIndex == 1){
                
                appDelegate.blindSet = blindSet;
                [self resetTimer];
            }else{
                
                blindSet = appDelegate.blindSet;
            }
            break;
    }
    
    [audioPlayer stop];
    
    alertView = nil;
}

-(void)updateTimerLabel {
    
    lblElapsedTime.text = [BlindSet formatTimeString: blindSet.elapsedSeconds+currentElapsedTime];
    lblTimer.text       = [BlindSet formatTimeString:(int)timerSlider.value];
    
    
    if( blindSet.nextBreakRemain < 0 )
        lblNextBreak.text = @"--:--:--";
    else
        lblNextBreak.text = [BlindSet formatTimeString:blindSet.nextBreakRemain-currentElapsedTime];
    
    [self updateTimerColor];
}

-(void)updateTimerColor {
    
    if( timerSlider.value < 10 ){
        
        lblTimer.textColor    = warningColor;
        lblTimer.shadowColor  = timerWarningShadowColor;
        lblTimer.shadowOffset = CGSizeMake(1, 3);
        
        if( [backgroundColor isEqualToString:@"blue"] ){

            backgroundColor = @"red";
            imgMainBg.image = [UIImage imageNamed:timerBgRedImageName];
        }
    }else{
        
        lblTimer.textColor    = timerTextColor;
        lblTimer.shadowColor  = timerShadowColor;
        lblTimer.shadowOffset = CGSizeMake(0, 4);
        
        if( [backgroundColor isEqualToString:@"red"] ){
            
            backgroundColor = @"blue";
            imgMainBg.image = [UIImage imageNamed:timerBgImageName];
        }
    }
}

-(void)playSound:(NSString *)soundName loops:(int)loops {

    if( !appDelegate.playSounds || !blindSet.playSound )
        return;
    
    [audioPlayer stop];
    
    NSLog(@"playSound: %@", soundName);
    
    NSString* blindNotifyAudio = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:blindNotifyAudio]  error:NULL];
    
    audioPlayer.numberOfLoops = loops;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

-(void)playSound:(NSString *)soundName {
    
    [self playSound:soundName loops:0];
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

-(void)configureTimeBank {
    
    timeBankView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    timeBankView.layer.borderWidth = 2.0f;
    [timeBankView.layer setCornerRadius:10.0f];
    // drop shadow
    [timeBankView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [timeBankView.layer setShadowOpacity:0.7];
    [timeBankView.layer setShadowRadius:3.0];
    [timeBankView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimeBank:) name:kNotificationStartTimeBank object:nil];
}

- (void)startTimeBank:(NSNotification *)notification {

    timeBank = 15;
    [timeBankView setHidden:NO];
}

-(void)invalidateTimer {
    
    [timer invalidate];
    timer = nil;
}

@end
