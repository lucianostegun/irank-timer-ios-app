
//  AppDelegate.m
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-19.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize blindSet;
@synthesize blindSetList;
@synthesize userDefaults;
@synthesize blindChangeSound;
@synthesize minuteNotifySound;
@synthesize playSounds;
@synthesize runBackground;
@synthesize preventSleep;
@synthesize fiveSecondsClock;
@synthesize longPauseAlert;
@synthesize shortBlindNumber;
@synthesize notifyFirstAnte;
@synthesize inverseColors;
@synthesize currentBlindSetIndex;
@synthesize language;
@synthesize isIOS5;
@synthesize isIOS7;
@synthesize rootViewControllers;
@synthesize firstExecution;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        
        isIOS7 = (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1);
        isIOS5 = (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0);
        
        NSLog(@"kCFCoreFoundationVersionNumber: %f", kCFCoreFoundationVersionNumber);
        
        rootViewControllers = [[NSMutableArray alloc] init];
        // Override point for customization after application launch.
        
        userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL settingsSaved = [userDefaults boolForKey:kSettingsSaved];
        
        firstExecution = NO;
        
        if( !settingsSaved ){
            
            [self createUserDefaults];
            firstExecution = YES;
        }
        
        [self loadSettings];
        
        if( currentBlindSetIndex > blindSetList.count-1 )
            currentBlindSetIndex = blindSetList.count-1;
        
        blindSetList = [BlindSet loadArchivedBlindSetList:YES];
        blindSet     = [blindSetList objectAtIndex:currentBlindSetIndex];
        
        if( inverseColors && IS_IPAD ){
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"iPad_Timer_White" bundle:nil];
            UIViewController* initialView = [storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [self.window setRootViewController:initialView];
        }
        
        [rootViewControllers addObject:self.window.rootViewController];
        
        return YES;
    }
    
- (void)applicationWillResignActive:(UIApplication *)application
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
- (void)applicationDidEnterBackground:(UIApplication *)application
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if( runBackground ){
            
            bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }];
            
            localNotification = [[UILocalNotification alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyBlindChange:) name:kNotificationBlindLevelChange object:nil];
        }
        
        [BlindSet archivedBlindSetList:blindSetList];
    }
    
- (void)applicationWillEnterForeground:(UIApplication *)application
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
- (void)applicationDidBecomeActive:(UIApplication *)application
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBlindLevelChange object:nil];
        
        localNotification.applicationIconBadgeNumber = 0;
        [application setApplicationIconBadgeNumber:0];
        
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    
- (void)applicationWillTerminate:(UIApplication *)application
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        [BlindSet archivedBlindSetList:blindSetList];
        [self updateSettings];
    }
    
-(void)showAlert:(NSString *)title message:(NSString *)message {
    
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
}
    
- (void)pushViewController:(UIViewController *)viewController {
    
    [self.window setRootViewController:viewController];
    
    [rootViewControllers addObject:viewController];
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.window.rootViewController = viewController; }
                    completion:nil];
}
    
- (void)dismissRootViewController {
    
    int index = rootViewControllers.count-1;
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ self.window.rootViewController = [rootViewControllers objectAtIndex: index-1]; }
                    completion:nil];
    
    [rootViewControllers removeObjectAtIndex:index];
}
    
- (void)notifyBlindChange:(NSNotification *)notification {
    
    BlindLevel *blindLevel = (BlindLevel*)notification.object;
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertAction = nil;
    
    if( playSounds )
    localNotification.soundName = blindChangeSound;//UILocalNotificationDefaultSoundName;
    
    localNotification.applicationIconBadgeNumber = blindLevel.levelNumber;
    localNotification.repeatInterval=0;
    localNotification.alertAction = @"notification";
    
    if( blindLevel.isBreak ){
        
        localNotification.alertBody = NSLocalizedString(@"Blind levels are on break now", "AppDelegate");
    }else{
        
        NSString *ante = (blindLevel.ante>0?[NSString stringWithFormat:@"/ %i", blindLevel.ante]:@"");
        localNotification.alertBody = [NSString stringWithFormat:@"%@: #%i - %i / %i %@", NSLocalizedString(@"New blind level", "AppDelegate"), blindLevel.levelNumber, blindLevel.smallBlind, blindLevel.bigBlind, ante];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
    
-(void)createUserDefaults {
    
    currentBlindSetIndex = 0;
    
    NSArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    [userDefaults setObject:@"blind-change1" forKey:kSettingsBlindChangeSound];
    [userDefaults setObject:@"minute-alert1" forKey:kSettingsMinuteNotifySound];
    [userDefaults setObject:[appleLanguages objectAtIndex:0] forKey:kSettingsLanguage];
    
    [userDefaults setBool:YES forKey:kSettingsPlaySounds];
    [userDefaults setBool:YES forKey:kSettingsRunBackground];
    [userDefaults setBool:YES forKey:kSettingsPreventSleep];
    [userDefaults setBool:YES forKey:kSettingsFiveSecondsClock];
    [userDefaults setBool:YES forKey:kSettingsLongPauseAlert];
    [userDefaults setBool:NO forKey:kSettingsShortBlindNumber];
    [userDefaults setBool:NO forKey:kSettingsNotifyFirstAnte];
    [userDefaults setBool:NO forKey:kSettingsInverseColors];
    [userDefaults setBool:YES forKey:kSettingsSaved];
    
    if( LITE_VERSION ){
        
        [userDefaults setBool:NO forKey:kSettingsLongPauseAlert];
        [userDefaults setBool:NO forKey:kSettingsRunBackground];
    }
    
    [userDefaults synchronize];
}
    
-(void)loadSettings {
    
    currentBlindSetIndex = [userDefaults integerForKey:kCurrentBlindSetIndex];
    
    blindChangeSound  = [userDefaults objectForKey:kSettingsBlindChangeSound];
    minuteNotifySound = [userDefaults objectForKey:kSettingsMinuteNotifySound];
    language          = [userDefaults objectForKey:kSettingsLanguage];
    
    playSounds       = [userDefaults boolForKey:kSettingsPlaySounds];
    runBackground    = [userDefaults boolForKey:kSettingsRunBackground];
    preventSleep     = [userDefaults boolForKey:kSettingsPreventSleep];
    shortBlindNumber = [userDefaults boolForKey:kSettingsShortBlindNumber];
    notifyFirstAnte  = [userDefaults boolForKey:kSettingsNotifyFirstAnte];
    inverseColors    = [userDefaults boolForKey:kSettingsInverseColors];
    fiveSecondsClock = [userDefaults boolForKey:kSettingsFiveSecondsClock];
    longPauseAlert   = [userDefaults boolForKey:kSettingsLongPauseAlert];
    
    NSLog(@"notifyFirstAnte: %i");
    
    [UIApplication sharedApplication].idleTimerDisabled = preventSleep;
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
    
    NSLog(@"%@ %@ %i %i %i %i %i %i %i %i %@", blindChangeSound, minuteNotifySound, playSounds, runBackground, preventSleep, fiveSecondsClock, longPauseAlert, shortBlindNumber, notifyFirstAnte, inverseColors, language);
}
    
-(void)updateSettings {
    
    [userDefaults setInteger:currentBlindSetIndex forKey:kCurrentBlindSetIndex];
    
    [userDefaults setObject:blindChangeSound forKey:kSettingsBlindChangeSound];
    [userDefaults setObject:minuteNotifySound forKey:kSettingsMinuteNotifySound];
    [userDefaults setObject:language forKey:kSettingsLanguage];
    
    [userDefaults setBool:playSounds forKey:kSettingsPlaySounds];
    [userDefaults setBool:runBackground forKey:kSettingsRunBackground];
    [userDefaults setBool:preventSleep forKey:kSettingsPreventSleep];
    [userDefaults setBool:shortBlindNumber forKey:kSettingsShortBlindNumber];
    [userDefaults setBool:notifyFirstAnte forKey:kSettingsNotifyFirstAnte];
    [userDefaults setBool:inverseColors forKey:kSettingsInverseColors];
    [userDefaults setBool:fiveSecondsClock forKey:kSettingsFiveSecondsClock];
    [userDefaults setBool:longPauseAlert forKey:kSettingsLongPauseAlert];
    [userDefaults synchronize];
    
    [UIApplication sharedApplication].idleTimerDisabled = preventSleep;
    
    NSLog(@"%@ %@ %i %i %i %i %i %i %i %@", blindChangeSound, minuteNotifySound, playSounds, runBackground, preventSleep, fiveSecondsClock, longPauseAlert, shortBlindNumber, inverseColors, language);
    
    //    NSArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
}

//+(void)initialize {
//
//    [iRate sharedInstance].previewMode = YES;
//    [iRate sharedInstance].appStoreID = APP_ID;
//}

@end
