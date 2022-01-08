//
//  iPhoneBlindLevelEditViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-25.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneBlindLevelEditViewController.h"

@interface iPhoneBlindLevelEditViewController ()

@end

@implementation iPhoneBlindLevelEditViewController
@synthesize blindSet;
@synthesize blindLevel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if( !appDelegate.isIOS7 )
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self configureView];
    [self localizeView];
    
    keyboardToolbar.tintColor = [UIColor blackColor];
    
    txtBigBlind.inputAccessoryView   = keyboardToolbar;
    txtSmallBlind.inputAccessoryView = keyboardToolbar;
    txtAnte.inputAccessoryView       = keyboardToolbar;
    txtDuration.inputAccessoryView   = keyboardToolbar;
    
    if( appDelegate.isIOS7 ){
        
        btnNextLevelToolbar.tintColor     = darkRed2Color;
        btnPreviousLevelToolbar.tintColor = darkRed2Color;
        btnAddBlindLevelToolbar.tintColor = darkRed2Color;
    }
    
    [blindSet resetLevelNumbers];
}

-(void)localizeView {
    
    lblMinutes.text       = NSLocalizedString(@"minutes", @"iPhoneBlindLevelEditViewController");
    lblIsBreak.text       = NSLocalizedString(@"Is break", @"iPhoneBlindLevelEditViewController");
    lblLevelNumber.text   = NSLocalizedString(@"Level number", @"iPhoneBlindLevelEditViewController");
    lblSmallBlind.text    = NSLocalizedString(@"Small blind", @"iPhoneBlindLevelEditViewController");
    lblBigBlind.text      = NSLocalizedString(@"Big blind", @"iPhoneBlindLevelEditViewController");
    lblAnte.text          = NSLocalizedString(@"Ante", @"iPhoneBlindLevelEditViewController");
    lblDuration.text      = NSLocalizedString(@"Duration", @"iPhoneBlindLevelEditViewController");
    lblTotalDuration.text = NSLocalizedString(@"Total duration", @"iPhoneBlindLevelEditViewController");
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( blindLevel.isBreak ){
        
        if( indexPath.row==1 || indexPath.row==2 || indexPath.row==3 || indexPath.row==4 )
            return 0;
    }
    
    return 44;
}

-(void)configureView {
    
    lblLevel.text      = [NSString stringWithFormat:@"%i", blindLevel.levelNumber];
    txtSmallBlind.text = [NSString stringWithFormat:@"%i", blindLevel.smallBlind];
    txtBigBlind.text   = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
    txtAnte.text       = [NSString stringWithFormat:@"%i", blindLevel.ante];
    txtDuration.text   = [NSString stringWithFormat:@"%i", blindLevel.duration];
    lblElapsed.text    = blindLevel.elapsedTime;
    isBreak.on         = blindLevel.isBreak;
    
    btnPreviousLevel.enabled        = blindLevel.levelIndex > 0;
    btnPreviousLevelToolbar.enabled = blindLevel.levelIndex > 0;
    btnNextLevel.enabled            = blindLevel.levelIndex < blindSet.blindLevels-1;
    btnNextLevelToolbar.enabled     = blindLevel.levelIndex < blindSet.blindLevels-1;
    
    txtSmallBlind.hidden    = blindLevel.isBreak;
    txtBigBlind.hidden      = blindLevel.isBreak;
    txtAnte.hidden          = blindLevel.isBreak;
    lblTotalDuration.hidden = blindLevel.isBreak;
}

- (void)previousLevel:(id)sender {
    
    blindLevel = [blindSet blindLevelByIndex: blindLevel.levelIndex-1];
    
    NSLog(@"< blindLevel: %@", blindLevel);
    
    [self configureView];
    [self.tableView reloadData];
    
    if( blindLevel.isBreak )
        [txtDuration becomeFirstResponder];
    else if( currentTextField!=nil )
        [currentTextField becomeFirstResponder];
    else
        [txtSmallBlind becomeFirstResponder];
}

- (void)nextLevel:(id)sender {
    
    blindLevel = [blindSet blindLevelByIndex: blindLevel.levelIndex+1];
    
    NSLog(@"> blindLevel: %@", blindLevel);
    
    [self configureView];
    [self.tableView reloadData];
    
    if( blindLevel.isBreak ){
        [txtDuration becomeFirstResponder];
        currentTextField = txtDuration;
    }else if( currentTextField!=nil )
        [currentTextField becomeFirstResponder];
    else
        [txtSmallBlind becomeFirstResponder];
}

-(void)switchIsBreak:(id)sender {
    
    [blindLevel setIsBreak: isBreak.isOn];
    [blindSet resetLevelNumbers];
    
    [self.tableView reloadData];
    [self configureView];
}

-(void)addBlindLevel:(id)sender {
    
    if( ![self checkLiteVersion] )
        return;
    
    int blindLevels = blindSet.levels;
    BlindLevel *lastBlindLevel = [blindSet blindLevelByNumber:blindLevels];
    
    int smallBlind = 0;
    int bigBlind   = 0;
    int ante       = 0;
    int duration   = lastBlindLevel.duration;
    
    if( blindSet.doublePrevious && lastBlindLevel!=nil ){
        
        smallBlind = lastBlindLevel.smallBlind*2;
        bigBlind   = lastBlindLevel.bigBlind*2;
        ante       = lastBlindLevel.ante;
    }
    
    BlindLevel *newBlindLevel = [[BlindLevel alloc] initWithLevelNumber:blindLevels levelIndex:blindSet.blindLevels smallBlind:smallBlind bigBlind:bigBlind ante:ante duration:duration];
    [blindSet addBlindLevel:newBlindLevel];
    
    blindLevel = newBlindLevel;
    [blindSet resetLevelNumbers];
    
    [self configureView];
    [[self tableView] reloadData];
    
    [txtSmallBlind becomeFirstResponder];
}

-(void)deleteLevel:(id)sender {
    
    int levelIndex = blindLevel.levelIndex;
    
    int action = 0; // -1 = previous, 0 = new, 1 = next
    
    // Se tiver mais pra frente, avança
    if( blindSet.blindLevels-1 > levelIndex )
        action = 1;
    // Se for o último e tiver algum pra tras
    else if( levelIndex > 1 )
        action = -1;
    
    if( action==-1 )
        [self previousLevel:nil];
    else if( action==1 )
        [self nextLevel:nil];
    else
        [self addBlindLevel:nil];
    
    [blindSet.blindLevelList removeObjectAtIndex:levelIndex];
    [blindSet resetLevelNumbers];
    
    NSLog(@"blindSet.blindLevelList: %@", blindSet.blindLevelList);
    
    [self configureView];
    [[self tableView] reloadData];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if( ![myCharSet characterIsMember:c] )
            return NO;
    }
    
    int maxLength = 6;
    
    if( textField.tag==3 )
        maxLength = 2;
    
    /*  limit the users input to only X characters  */
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if( newLength > maxLength )
        return NO;
    
    NSString *newString    = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int integerValue       = [newString integerValue];
    
    if( textField.tag==0 )
        blindLevel.smallBlind = integerValue;
    else if( textField.tag==1 )
        blindLevel.bigBlind = integerValue;
    else if( textField.tag==2 )
        blindLevel.ante = integerValue;
    else if( textField.tag==3 )
        blindLevel.duration = integerValue;
    
    [blindSet resetLevelNumbers];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    int integerValue       = [textField.text integerValue];
    int minLength          = 0;

    if( textField.tag == 3 ) // Se for o campo Duração
        minLength = 1;

    switch( textField.tag ) {
        case 0:
            [txtBigBlind becomeFirstResponder];
            
            if( blindLevel.bigBlind==0 ){
                
                blindLevel.bigBlind = integerValue*2;
                txtBigBlind.text = [NSString stringWithFormat:@"%i", blindLevel.bigBlind];
            }
            break;
        case 1:
            [txtAnte becomeFirstResponder];
            break;
        case 2:
            [txtDuration becomeFirstResponder];
            break;
        case 3:
        default:
            [textField resignFirstResponder];
            break;
    }

    if( textField.text.length < minLength )
        return NO;
    
    if( textField.tag == 3 ){
        
        [blindSet resetLevelNumbers];
        
        [self configureView];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if( [textField.text isEqualToString:@"0"] ){
     
        textField.text = @"";
        
        if( textField.tag==1 && blindLevel.smallBlind > 0 ){

            textField.text = [NSString stringWithFormat:@"%i", (blindLevel.smallBlind*2)];
        }
    }
    
    currentTextField = textField;
}

-(void)dismissKeyboard {
    
    [txtSmallBlind resignFirstResponder];
    [txtBigBlind resignFirstResponder];
    [txtAnte resignFirstResponder];
    [txtDuration resignFirstResponder];
}

@end
