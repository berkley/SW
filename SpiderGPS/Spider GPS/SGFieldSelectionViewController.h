//
//  SGFieldSelectionViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/12/11.
//  Copyright (c) 2011 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSession.h"

@interface SGFieldSelectionViewController : UITableViewController <UITableViewDelegate, UITableViewDelegate>
{
    //section 0
    IBOutlet UIView *screenOnView;
    IBOutlet UIView *trueHeadingView;
    IBOutlet UIView *unitsView;

    //section 1
    IBOutlet UIView *latLonView;
    IBOutlet UIView *headingView;
    IBOutlet UIView *lowAltitudeView;
    IBOutlet UIView *highAltitudeView;
    IBOutlet UIView *currentAltitudeView;
    IBOutlet UIView *lowSpeedView;
    IBOutlet UIView *topSpeedView;
    IBOutlet UIView *avgSpeedView;
    IBOutlet UIView *currentSpeedView;
    IBOutlet UIView *totalDistanceView;
    IBOutlet UIView *totalTimeView;
    IBOutlet UIView *altGainView;
    IBOutlet UIView *altLossView;
    IBOutlet UIView *autoSaveView;
    IBOutlet UIView *mapTypeView;
    
    __weak IBOutlet UISwitch *metricUnitsSwitch;
    __weak IBOutlet UISwitch *trueHeadingSwitch;
    __weak IBOutlet UISwitch *screenAlwaysOnSwitch;
    
    //tagged switches
    __weak IBOutlet UISwitch *totalTimeSwitch;
    __weak IBOutlet UISwitch *highAltitudeSwitch;
    __weak IBOutlet UISwitch *currentSpeedSwitch;
    __weak IBOutlet UISwitch *averageSpeedSwitch;
    __weak IBOutlet UISwitch *topSpeedSwitch;
    __weak IBOutlet UISwitch *lowSpeedSwitch;
    __weak IBOutlet UISwitch *currentAltitudeSwitch;
    __weak IBOutlet UISwitch *latLonSwitch;
    __weak IBOutlet UISwitch *headingSwitch;
    __weak IBOutlet UISwitch *totalDistanceSwitch;
    __weak IBOutlet UISwitch *lowAltitudeSwitch;
    __weak IBOutlet UISwitch *altGainSwitch;
    __weak IBOutlet UISwitch *altLossSwitch;
    __weak IBOutlet UISwitch *autoSaveSwitch;
    __weak IBOutlet UISegmentedControl *mapTypeSegCon;
}

@end
