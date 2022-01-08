//
//  AppDelegate.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-19.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindSet.h"
#import "iRate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    
    UIBackgroundTaskIdentifier *bgTask;
    UILocalNotification *localNotification;
}
    
@property(strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) BlindSet *blindSet;
@property(nonatomic, retain) NSMutableArray *blindSetList;
@property(nonatomic, readwrite) NSUserDefaults *userDefaults;
    
@property(nonatomic, retain) NSMutableArray *rootViewControllers;
@property(nonatomic, retain) NSString *blindChangeSound;
@property(nonatomic, retain) NSString *minuteNotifySound;
@property(nonatomic, retain) NSString *language;
@property(nonatomic, readwrite) BOOL playSounds;
@property(nonatomic, readwrite) BOOL runBackground;
@property(nonatomic, readwrite) BOOL preventSleep;
@property(nonatomic, readwrite) BOOL fiveSecondsClock;
@property(nonatomic, readwrite) BOOL longPauseAlert;
@property(nonatomic, readwrite) BOOL shortBlindNumber;
@property(nonatomic, readwrite) BOOL notifyFirstAnte;
@property(nonatomic, readwrite) BOOL inverseColors;
@property(nonatomic, readwrite) int currentBlindSetIndex;
@property(nonatomic, readwrite) BOOL isIOS5;
@property(nonatomic, readwrite) BOOL isIOS7;
@property(nonatomic, readonly) BOOL firstExecution;
    
- (void)showAlert:(NSString *)title message:(NSString *)message;
- (void)pushViewController:(UIViewController *)viewController;
- (void)dismissRootViewController;
    
- (void)notifyBlindChange:(NSNotification *)notification;
- (void)updateSettings;
+ (void)initialize;
@end
