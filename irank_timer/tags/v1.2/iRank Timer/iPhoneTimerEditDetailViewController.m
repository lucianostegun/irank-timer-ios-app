//
//  iPhoneTimerEditDetailViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-24.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneTimerEditDetailViewController.h"
#import "iPhoneBlindLevelEditViewController.h"

@interface iPhoneTimerEditDetailViewController ()

@end

@implementation iPhoneTimerEditDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
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
    
    blindLevel = [self.blindSet blindLevelByIndex:indexPath.row];
    
    if( blindLevel.isBreak ){
        
        [cell.lblLevel setHidden:YES];
        [cell.lblBigBlind setHidden:YES];
        [cell.lblAnte setHidden:YES];
        
        cell.lblSmallBlind.text = NSLocalizedString(@"BREAK", @"");
        
        cell.lblSmallBlind.frame = CGRectMake(cell.lblSmallBlind.frame.origin.x, cell.lblSmallBlind.frame.origin.y, 100, cell.lblSmallBlind.frame.size.height);
    }else{
        
        [cell.lblLevel setHidden:NO];
        [cell.lblBigBlind setHidden:NO];
        [cell.lblAnte setHidden:NO];
        
        int smallBlind = blindLevel.smallBlind;
        int bigBlind   = blindLevel.bigBlind;
        int ante       = blindLevel.ante;
        
        cell.lblLevel.text      = [NSString stringWithFormat:@"%i", blindLevel.levelNumber];
        cell.lblSmallBlind.text = [NSString stringWithFormat:@"%1.1f%@", (smallBlind>=1000?(smallBlind/1000):smallBlind/1.0), (smallBlind>=1000?@"K":@"")];
        cell.lblBigBlind.text   = [NSString stringWithFormat:@"%1.1f%@", (bigBlind>=1000?(bigBlind/1000):bigBlind/1.0), (bigBlind>=1000?@"K":@"")];
        cell.lblAnte.text       = [NSString stringWithFormat:@"%1.1f%@", (ante>=1000?(ante/1000):ante/1.0), (ante>=1000?@"K":@"")];
        
        cell.lblSmallBlind.text = [cell.lblSmallBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        cell.lblBigBlind.text   = [cell.lblBigBlind.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        cell.lblAnte.text       = [cell.lblAnte.text stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        cell.lblSmallBlind.frame = CGRectMake(cell.lblSmallBlind.frame.origin.x, cell.lblSmallBlind.frame.origin.y, 35, cell.lblSmallBlind.frame.size.height);
    }
    
    cell.lblElapsed.tag = indexPath.row;
    
    cell.lblElapsed.text  = blindLevel.elapsedTime;
    cell.lblDuration.text = [NSString stringWithFormat:@"%i", blindLevel.duration];
    
    cell.lblElapsed.hidden = tableView.isEditing;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if( !appDelegate.isIOS7 ){
        
        if( tableView.isEditing )
            return @"        #    SB     BB      A   DUR";
        else
            return @" #     SB    BB      A   DUR   TOTAL";
    }
    
    if( tableView.isEditing )
        return @"         #        SB       BB       A     DUR";
    else
        return @"#        SB       BB       A     DUR     TOTAL";
}

-(void)switchEditLevels:(id)sender {
    
    if( self.blindSet.blindLevels<=1 )
        return;
    
    [self.tableView setEditing:!self.tableView.isEditing];
    [self.tableView reloadData];
    
    if( self.tableView.isEditing )
        createMenuNavigationItem.rightBarButtonItem = btnDoneEditingLevels;
    else
        createMenuNavigationItem.rightBarButtonItem = btnEditLevels;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    blindLevel = [self.blindSet.blindLevelList objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"EditBlindLevel" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    iPhoneBlindLevelEditViewController *viewController = (iPhoneBlindLevelEditViewController *)segue.destinationViewController;
    viewController.blindSet   = self.blindSet;
    viewController.blindLevel = blindLevel;
}

@end
