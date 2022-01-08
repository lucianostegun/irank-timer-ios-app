//
//  CreateMenuViewController.h
//  iRank Timer
//
//  Created by Luciano Stegun on 2013-09-21.
//  Copyright (c) 2013 Stegun.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMenuViewController : UIViewController {
        
    IBOutlet UIButton *btnWizard;
    IBOutlet UIButton *btnPreset;
    IBOutlet UIButton *btnManual;
    IBOutlet UIButton *btnCancel;
    
    // INTERNACIONALIZAÇÃO
    IBOutlet UITextView *lblIntro;
    IBOutlet UILabel *lblWizard;
    IBOutlet UILabel *lblPreset;
    IBOutlet UILabel *lblManual;
    IBOutlet UITextView *lblWizardInfo;
    IBOutlet UITextView *lblPresetInfo;
    IBOutlet UITextView *lblManualInfo;
    // -------------------
}

-(IBAction)createManualTimer:(id)sender;
-(IBAction)dismiss:(id)sender;

@end
