//
//  SGTrackDetailViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SGTrack.h"
#import "SGSession.h"
#import "SGPinAnnotation.h"

@interface SGTrackDetailViewController :UIViewController <MKMapViewDelegate>
{
    __weak IBOutlet UILabel *totalDistanceLabel;
    __weak IBOutlet UILabel *avgSpeedLabel;
    __weak IBOutlet UILabel *topSpeedLabel;
    __weak IBOutlet UILabel *lowSpeedLabel;
    __weak IBOutlet UILabel *highestAltitudeLabel;
    __weak IBOutlet UILabel *lowestAltitudeLabel;
    __weak IBOutlet UILabel *totalTimeLabel;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *infoView;
    SGTrack *track;
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    int accuracyCount;
    double accuracyTotal;
    int addPointCount;
    
    IBOutlet UIButton *showMapButton;
    BOOL dashboardHidden;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trackName:(NSString*)trackName;

@end
