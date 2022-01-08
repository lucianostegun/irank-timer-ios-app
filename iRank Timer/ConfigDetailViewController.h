//
//  ConfigDetailViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-29.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ConfigDetailViewController : UITableViewController <AVAudioPlayerDelegate> {
    
    NSArray *blindChangeSoundList;
    NSArray *minuteAlertSoundList;
    
    AVAudioPlayer *audioPlayer;
}

@end
