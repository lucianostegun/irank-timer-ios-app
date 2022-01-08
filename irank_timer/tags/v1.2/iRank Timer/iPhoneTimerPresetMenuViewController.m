//
//  iPhoneTimerPresetMenuViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-21.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "iPhoneTimerPresetMenuViewController.h"
#import "TimerPresetViewController.h"

@interface iPhoneTimerPresetMenuViewController ()

@end

@implementation iPhoneTimerPresetMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self localizeView];
}

-(void)localizeView {
    
    self.title = NSLocalizedString(@"Preset blind sets", "TimerPresetViewController");
    lblMicroStack.text  = NSLocalizedString(@"Micro stack", @"CreateMenuViewController");
    lblMediumStack.text = NSLocalizedString(@"Medium stack", @"CreateMenuViewController");
    lblDeepStack.text   = NSLocalizedString(@"Deep stack", @"CreateMenuViewController");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TimerPresetViewController *viewController = (TimerPresetViewController*)segue.destinationViewController;
    
    if( [segue.identifier isEqualToString:@"PresetMicroStackSegue"] ){
        
        viewController.tableView.tag = 0;
        viewController.title = NSLocalizedString(@"Micro stack", @"CreateMenuViewController");
    }else if( [segue.identifier isEqualToString:@"PresetRegularStackSegue"] ){
        
        viewController.tableView.tag = 1;
        viewController.title = NSLocalizedString(@"Medium stack", @"CreateMenuViewController");
    }else if( [segue.identifier isEqualToString:@"PresetDeepStackSegue"] ){
     
        viewController.tableView.tag = 2;
        viewController.title = NSLocalizedString(@"Deep stack", @"CreateMenuViewController");
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return NSLocalizedString(@"Select the proper king of blind set you want to create", @"iPhoneTimerPresetMenuViewController");
}

@end
