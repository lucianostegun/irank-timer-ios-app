//
//  TimerPresetViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-27.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "TimerPresetViewController.h"
#import "TimerEditViewController.h"
#import "TimerEditMasterViewController.h"
#import "TimerMenuCell.h"
#import "BlindSet.h"

@interface TimerPresetViewController ()

@end

@implementation TimerPresetViewController
@synthesize blindSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *filePath;
    
    filePath = [[NSBundle mainBundle] pathForResource:@"microStack" ofType:@"plist"];
    microStackList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"regularStack" ofType:@"plist"];
    regularStackList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"deepStack" ofType:@"plist"];
    deepStackList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    [self localizeView];
}

-(void)localizeView {
    
    if( IS_IPAD )
        self.title = NSLocalizedString(@"Preset blind sets", "TimerPresetViewController");
    
    lblMicroStack.text  = NSLocalizedString(@"Micro stack", "TimerPresetViewController");
    lblMediumStack.text = NSLocalizedString(@"Medium stack", "TimerPresetViewController");
    lblDeepStack.text   = NSLocalizedString(@"Deep stack", "TimerPresetViewController");
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [microStackTableView reloadData];
    [regularStackTableView reloadData];
    [microStackTableView reloadData];
    
    if( IS_IPAD ){
     
        headerColor = [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] textColor];
        
        if( !appDelegate.isIOS5 ){
            
            [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor lightGrayColor]];
            [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setShadowColor:[UIColor blackColor]];
        }else{
            
            microStackTableView.backgroundView = nil;
            regularStackTableView.backgroundView = nil;
            deepStackTableView.backgroundView = nil;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if( IS_IPAD ){

        if( !appDelegate.isIOS5 ){
            
            [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setShadowColor:[UIColor whiteColor]];
            [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:headerColor];
        }
    }
}

#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TimerMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlindSetCell"];
    NSDictionary *menuItem;
    int row = indexPath.row;
    
    row += (indexPath.section*3);
    
    switch( tableView.tag ){
        case 0:
            menuItem = [microStackList objectAtIndex:row];
            break;
        case 1:
            menuItem = [regularStackList objectAtIndex:row];
            break;
        case 2:
            menuItem = [deepStackList objectAtIndex:row];
            break;
    }
    
    int levels = [menuItem[@"levels"] integerValue];
    int breaks = [menuItem[@"breaks"] integerValue];
    
    NSString *strLevels = [NSString stringWithFormat:@"%i %@", levels, NSLocalizedString((levels==1?@"level":@"levels"), @"TimerViewController")];

    NSString *strBreaks;
    if( [menuItem[@"breaks"] integerValue] > 0 )
        strBreaks = [NSString stringWithFormat:@"%i %@", breaks, NSLocalizedString(((breaks==1?@"break":@"breaks")), @"TimerPresetViewController")];
    else
        strBreaks = NSLocalizedString(@"No breaks", @"TimerViewController");
    
    cell.lblBlindSetName.text = menuItem[@"blindSetName"];
    cell.lblLevels.text       = strLevels;
    cell.lblBreaks.text       = strBreaks;
    cell.lblDuration.text     = menuItem[@"duration"];
    
    if( appDelegate.isIOS5 ){
        
        cell.lblBlindSetName.textColor = [UIColor blackColor];
        cell.lblLevels.textColor       = [UIColor darkGrayColor];
        cell.lblBreaks.textColor       = [UIColor darkGrayColor];
        cell.lblDuration.textColor     = [UIColor darkGrayColor];
    }
    
    return cell;
}


#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"didSelectRowAtIndexPath");
    
    NSString *fileName;
    NSString *blindSetName;
    int index = indexPath.row;
    index += (indexPath.section*3);
    
    switch( tableView.tag ){
        case 0:
            fileName = @"preset-microStack";
            blindSetName = microStackList[index][@"blindSetName"];
            break;
        case 1:
            NSLog(@"%@", regularStackList);
            fileName = @"preset-regularStack";
            blindSetName = regularStackList[index][@"blindSetName"];
            break;
        case 2:
            fileName = @"preset-deepStack";
            blindSetName = deepStackList[index][@"blindSetName"];
            break;
    }
    
    NSLog(@"fileName: %@", fileName);
    NSArray *blindSetList = [NSArray arrayWithArray:[BlindSet loadBlindSetListByXml:fileName]];
    
//    NSLog(@"blindSetList: %@", blindSetList);
//    NSLog(@"index: %i", index);
    
    blindSet = [blindSetList objectAtIndex:index];
    blindSet.isNew = YES;
    blindSet.blindSetName = blindSetName;
    [blindSet resetLevelNumbers];
    
    if( !IS_IPAD ){
        
        [self performSegueWithIdentifier:@"OpenTimerEditMaster" sender:nil];
        return;
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPad_Timer_Edit" bundle:nil];
    TimerEditViewController *timerEditViewController = [storyBoard instantiateInitialViewController];
    
    timerEditViewController.blindSet = blindSet;
    
    [appDelegate pushViewController:timerEditViewController];
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    switch( tableView.tag ){
        case 0:
            switch( section ){
                case 0:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"1 / 2 / 5 / 10"];
                case 1:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"5 / 10 / 25 / 50"];
                case 2:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"10 / 25 / 50 / 100"];
            }
        case 1:
            switch( section ){
                case 0:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"25 / 50 / 100 / 500"];
                case 1:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"50 / 100 / 1000"];
                case 2:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"50 / 500 / 1000 / 5000"];
            }
        case 2:
            switch( section ){
                case 0:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"50 / 100 / 1000 / 5000"];
                case 1:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"100 / 500 / 1000 / 5000"];
                case 2:
                    return [NSString stringWithFormat:NSLocalizedString(@"  %@ chips", nil), @"100 / 500 / 1000 / 5000 / 10000"];
            }
    }
    
    return nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TimerEditMasterViewController *viewController = (TimerEditMasterViewController *)segue.destinationViewController;
    viewController.blindSet = blindSet;
    
    NSLog(@"blindSet: %@", blindSet);
    NSLog(@"blindSet.blindLevelList: %@", blindSet.blindLevelList);
    NSLog(@"blindSet.blindLevels: %i", blindSet.blindLevels);
}
@end
