//
//  ConfigLanguageViewController.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-10-03.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "ConfigLanguageViewController.h"

@interface ConfigLanguageViewController ()

@end

@implementation ConfigLanguageViewController

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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    notifyLanguageChange = NO;
    NSString *filePath;
    
    filePath = [[NSBundle mainBundle] pathForResource:@"languages" ofType:@"plist"];
    languageList = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    [self localizeView];
}

-(void)localizeView {
    
    self.title = NSLocalizedString(@"Language", "ConfigLanguageViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return languageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if( !cell )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *menuItem = [languageList objectAtIndex:indexPath.row];

    cell.textLabel.text = menuItem[@"language"];
    
    if( [appDelegate.language isEqualToString:menuItem[@"culture"]] )
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    appDelegate.language = languageList[indexPath.row][@"culture"];
    [appDelegate updateSettings];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSettingsDetailsChange object:nil];
    
    if( !notifyLanguageChange ){
        
        notifyLanguageChange = YES;
       [appDelegate showAlert:NSLocalizedString(@"Language has changed", "ConfigLanguageViewController") message:NSLocalizedString(@"The new selected language will become active after app relaunch", "ConfigLanguageViewController")];

    }
    
    [self.tableView reloadData];
}

@end
