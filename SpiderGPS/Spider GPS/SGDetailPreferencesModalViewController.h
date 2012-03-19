//
//  SGDetailPreferencesModalViewController.h
//  Spider GPS
//
//  Created by Chad Berkley on 2/10/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SGSession.h"
#import <MapKit/MapKit.h>

@protocol PrefModalDelegate <NSObject>
- (void)prefModalDidClose;
@end

@interface SGDetailPreferencesModalViewController : UIViewController
{
    IBOutlet UISegmentedControl *mapTypeSegCon;
    IBOutlet UISwitch *ascentDescentSwitch;
    IBOutlet UISwitch *timeLabelSwitch;
    __weak IBOutlet UIActivityIndicatorView *activitySpinner;
    __unsafe_unretained id<PrefModalDelegate> delegate;
}

@property (nonatomic, retain) UISegmentedControl *mapTypeSegCon;
@property (nonatomic, retain) UISwitch *ascentDescentSwitch;
@property (nonatomic, retain) UISwitch *timeLabelSwitch;

@property (nonatomic, assign) id<PrefModalDelegate> delegate;

@end
