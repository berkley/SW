//
//  SGViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Constants.h"
#import "SGSession.h"
#import "SGTrackViewController.h"
#import "SGFieldSelectionViewController.h"
#import "SGPinAnnotation.h"

#define SETTINGS_HEIGHT 269

@interface SGViewController : UIViewController 
<MKMapViewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    IBOutlet UIView *speedHeadingView;
    __weak IBOutlet UILabel *topSpeedLabel;
    __weak IBOutlet UILabel *lowSpeedLabel;
    __weak IBOutlet UILabel *averageSpeedLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *highAltitudeLabel;
    __weak IBOutlet UILabel *lowAltitudeLabel;
    __weak IBOutlet UILabel *speedLabel;
    __weak IBOutlet UILabel *headingLabel;
    __weak IBOutlet UILabel *longitudeLabel;
    __weak IBOutlet UILabel *latitudeLabel;
    __weak IBOutlet UILabel *altitudeLabel;
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet UISwitch *mapDirectionFollowingSwitch;
    IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIView *latView;
    IBOutlet UIView *lonView;
    IBOutlet UIView *headingView;
    IBOutlet UIView *altView;
    IBOutlet UIView *distView;
    IBOutlet UIView *speedView;
    IBOutlet UIView *topSpeedView;
    IBOutlet UIView *lowSpeedView;
    IBOutlet UIView *avgSpeedView;
    IBOutlet UIView *timeView;
    IBOutlet UIView *highAltView;
    IBOutlet UIView *lowAltView;
    
    IBOutlet UIView *activityIndicatorView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    __weak IBOutlet UILabel *activityIndicatorLabel;
    
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    NSMutableArray *routeArray;
    int pointCount;
    MKMapPoint* pointArr;
    __weak IBOutlet UISegmentedControl *unitSegmentedControl;
    __weak IBOutlet UISegmentedControl *compassSegmentedControl;
    double distance;
    double avgSpeed;
    double topSpeed;
    double lowSpeed;
    double topAltitude;
    double lowAltidude;
    double totalSpeed;
    SGTrackViewController *trackViewController;
    SGFieldSelectionViewController *fieldsViewController;
    UINavigationController *navcon;
    UINavigationController *fieldsNavCon;
    NSDate *startTime;
    NSDate *endTime;
    __weak IBOutlet UIBarButtonItem *locationButton;
    __weak IBOutlet UIBarButtonItem *pinButton;
    
    double accuracyTotal;
    int accuracyCount;
    int addPointCount;
}

- (void)setFields;

@end
