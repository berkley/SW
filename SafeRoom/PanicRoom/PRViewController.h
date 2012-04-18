//
//  PRViewController.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRSettingsViewController.h"

#define ACTIVE_TIME_INTERVAL 1.0

@interface PRViewController : UIViewController
<UIAlertViewDelegate>
{
    __weak IBOutlet UISlider *activationSlider;
    __weak IBOutlet UIBarButtonItem *settingsBarButtonItem;
    __weak IBOutlet UIBarButtonItem *toolbar;
    __weak IBOutlet UILabel *slideLabel;
    __weak IBOutlet UILabel *headingLabel;
    __weak IBOutlet UILabel *distressActiveLabel;
    __weak IBOutlet UITextView *statusTextView;
    __weak IBOutlet UISegmentedControl *testEmergencySegCon;
    NSInteger numTimerFired;
    BOOL distressCallIsActive;
    NSTimer *activeTimer;
    UINavigationController *settingsNavigationController;
    PRSettingsViewController *settingsViewController;
    CLLocation *currentLocation;
    BOOL welcomeShown;
}

@end
