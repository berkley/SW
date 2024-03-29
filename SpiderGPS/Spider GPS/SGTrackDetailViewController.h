//
//  SGTrackDetailViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SGTrack.h"
#import "SGSession.h"
#import "SGPinAnnotation.h"
#import "SGPolyline.h"
#import "SGTimeAnnotation.h"
#import "SGTimeAnnotationView.h"
#import "SGDetailPreferencesModalViewController.h"

@interface SGTrackDetailViewController :UIViewController 
<MKMapViewDelegate, PrefModalDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    SGTrack *track;
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    int accuracyCount;
    double accuracyTotal;
    int addPointCount;
    
    IBOutlet UIButton *showMapButton;
    BOOL dashboardHidden;
    int polylineCount;

    __weak IBOutlet UISlider *slider;
    __weak IBOutlet UILabel *sliderLabel;
    __weak IBOutlet UILabel *sliderValueLabel;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    __weak IBOutlet UILabel *segmentedControlLabel;
    
    UIBarButtonItem *optionsItem;
    
    SGDetailPreferencesModalViewController *prefViewController;
    __strong NSArray *timeAnnotations;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trackName:(NSString*)trackName;

@end
