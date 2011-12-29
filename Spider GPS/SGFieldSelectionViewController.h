//
//  SGFieldSelectionViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/12/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
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
    
}

@end
