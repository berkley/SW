//
//  SGDetailPreferencesModalViewController.h
//  Spider GPS
//
//  Created by Chad Berkley on 2/10/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <MapKit/MapKit.h>

@interface SGDetailPreferencesModalViewController : UIViewController
{
    IBOutlet UISegmentedControl *mapTypeSegCon;
    IBOutlet UISwitch *ascentDescentSwitch;
    IBOutlet UISwitch *timeLabelSwitch;
    
    NSInteger mapType;
    BOOL ascentDescentOn;
    BOOL timeLabelOn;
}

@property (nonatomic, retain) UISegmentedControl *mapTypeSegCon;
@property (nonatomic, retain) UISwitch *ascentDescentSwitch;
@property (nonatomic, retain) UISwitch *timeLabelSwitch;

@property (nonatomic, assign) NSInteger mapType;
@property (nonatomic, assign) BOOL ascentDescentOn;
@property (nonatomic, assign) BOOL timeLabelOn;

@end
