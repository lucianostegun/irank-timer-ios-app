//
//  ConfigMasterViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigMasterViewController : UITableViewController {
    
    IBOutlet UISwitch *switchPlaySounds;
    IBOutlet UISwitch *switchPreventSleep;
    IBOutlet UISwitch *switchFiveSecondsClock;
    IBOutlet UISwitch *switchLongPauseAlert;
    IBOutlet UISwitch *switchShortBlindNumber;
    IBOutlet UISwitch *switchNotifyFirstAnte;
    IBOutlet UISwitch *switchInverseColors;
    IBOutlet UISwitch *switchRunBackground;
    IBOutlet UILabel *lblBlindChangeSound;
    IBOutlet UILabel *lblLanguage;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UILabel *lblPlaySounds;
    IBOutlet UILabel *lblSounds;
    IBOutlet UILabel *lblFiveSecondsAlert;
    IBOutlet UILabel *lblLongPauseAlert;
    IBOutlet UILabel *lblShortBlindNumber;
    IBOutlet UILabel *lblNotifyFirstAnte;
    IBOutlet UILabel *lblInverseColors;
    IBOutlet UILabel *lblLanguageLabel;
    IBOutlet UILabel *lblPreventSleep;
    IBOutlet UILabel *lblRunBackground;
    
    NSIndexPath *selectedIndexPath;
    // -------------------
}


- (void)changeMasterDetails:(NSNotification *)notification;

-(IBAction)switchSoundSettings:(id)sender;
-(IBAction)saveSettings:(id)sender;
-(IBAction)checkLiteVersion:(id)sender;
-(void)dismiss:(BOOL)defaultDismiss;

@end
