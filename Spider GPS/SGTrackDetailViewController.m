//
//  SGTrackDetailViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGTrackDetailViewController.h"

@implementation SGTrackDetailViewController
@synthesize style;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trackName:(NSString*)trackName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        track = [[SGSession instance].tracks objectForKey:trackName];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationItem.title = trackName;
        polylineCount = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - infoView.frame.size.height - 35 - 20, 35, 35);
//    [showMapButton setImage:[UIImage imageNamed:@"map2.png"] forState:UIControlStateNormal];
//    [self.view addSubview:showMapButton];
//    dashboardHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
//    if([SGSession instance].useMPH)
//    { //imperial
//        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles", [track.distance floatValue] * METERS_TO_MILES];
//        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.avgSpeed floatValue] * METERS_TO_MPH];
//        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.topSpeed floatValue] * METERS_TO_MPH];
//        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.lowSpeed floatValue] * METERS_TO_MPH];
//        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.topAlitude floatValue] * METERS_TO_FT];
//        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.lowAltidude floatValue] * METERS_TO_FT];
//    }
//    else
//    { //metric
//        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f km", [track.distance floatValue] * METERS_TO_KM];
//        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.avgSpeed floatValue] * METERS_TO_KPH];
//        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.topSpeed floatValue] * METERS_TO_KPH];
//        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.lowSpeed floatValue] * METERS_TO_KPH];
//        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.topAlitude floatValue]];
//        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.lowAltidude floatValue]];        
//    }
//        
//    NSTimeInterval theTimeInterval = [track.totalTime doubleValue];
//    
//    // Create the NSDates
//    NSDate *date1 = [[NSDate alloc] init];
//    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
//    
//    totalTimeLabel.text = [SGSession formattedElapsedTime:date1 date2:date2];

    MKMapPoint* tempPointArr = malloc(sizeof(CLLocationCoordinate2D) * [track.locations count]);
    int pointCount = 0;
    accuracyCount = 0;
    accuracyTotal = 0;
    
    //do accuracy smoothing
    for(CLLocation *loc in track.locations)
    {
        BOOL addPoint = YES;
        //calculate avg accuracy to smooth this line
        if(accuracyCount > NUM_POINTS_FOR_ACCURACY)
        {
            double avgAccuracy = accuracyTotal / (double)accuracyCount;
            if(loc.horizontalAccuracy > avgAccuracy + ACCURACY_THRESHOLD || 
               loc.horizontalAccuracy < avgAccuracy - ACCURACY_THRESHOLD)
            {
                addPoint = NO;
                addPointCount++;
            }
        }
        
        if(addPointCount > ADD_POINT_COUNT_THRESHOLD)
        {  //if all of a sudden the accuracy goes to shit, we don't want to stop adding
            //points forever, so this will reset the accuracy check
            addPointCount = 0;
            accuracyTotal = 0.0;
            accuracyCount = 0;
        }
        
        if(addPoint)
        {
            MKMapPoint newPoint = MKMapPointForCoordinate(loc.coordinate);
            tempPointArr[pointCount] = newPoint;
            pointCount++;
        }
        
        accuracyTotal += loc.horizontalAccuracy;
        accuracyCount++;
    }

    [mapView removeOverlays:mapView.overlays];
    if(style == TRACK_STYLE_NORMAL)
    {
        routeLine = [MKPolyline polylineWithPoints:tempPointArr count:pointCount];
        [mapView addOverlay:routeLine];
        if(tempPointArr)
            free(tempPointArr);        
    }
    else if(style == TRACK_STYLE_RUN)
    {
        NSArray *polylines = [track arrayOfPolylines];        
        [mapView addOverlays:polylines];
    }

    for(SGPinAnnotation *ann in track.annotations)
    {
        [mapView addAnnotation:ann];
    }
    
    [SGSession zoomToFitLocations:track.locations padding:1 mapView:mapView];
}

//- (void)mapTapped:(id)sender
//{
//    [UIView beginAnimations:@"hideInfoBar" context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:.5];
//    if(infoView.hidden)
//    {
//        infoView.hidden = NO;
//        infoView.alpha = 0.8;
//    }
//    else
//    {
//        infoView.alpha = 0.0;
//        [self performSelector:@selector(hideInfoView) withObject:nil afterDelay:1.0];
//    }
//    [UIView commitAnimations];
//}

- (void)viewDidUnload
{
    mapView = nil;
    showMapButton = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    
    if([overlay isKindOfClass:[SGPolyline class]])
    {
        SGPolyline *polyline = (SGPolyline*)overlay;
        routeLineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        
        if(polyline.isAscending)
        {
            routeLineView.fillColor = [UIColor blueColor];
            routeLineView.strokeColor = [UIColor blueColor];
        }
        else
        {
            routeLineView.fillColor = [UIColor redColor];
            routeLineView.strokeColor = [UIColor redColor];
        }
    }
    else
    {
        routeLineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        routeLineView.fillColor = [UIColor blueColor];
        routeLineView.strokeColor = [UIColor blueColor];
    }
    
    polylineCount++;
    routeLineView.lineWidth = 5;
    overlayView = routeLineView;    
    return overlayView;
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[SGPinAnnotation class]])
    {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                                       reuseIdentifier:@"pinAnnotation"];
        pinView.animatesDrop = YES;
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.userInteractionEnabled = YES;
        pinView.canShowCallout = YES;
        pinView.frame = CGRectMake(0, 0, 20, 20);
        return pinView;
    }
    return nil;
}

//- (IBAction)showMapButtonTouched:(id)sender 
//{
//    [UIView beginAnimations:@"hideSpeedHeadingView" context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:.5];
//    if(dashboardHidden)
//    {
//        dashboardHidden = NO;
//        infoView.alpha = 0.8;
//        self.navigationController.navigationBar.alpha = 1.0;
//        [showMapButton setImage:[UIImage imageNamed:@"map2.png"] forState:UIControlStateNormal];
//        showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - infoView.frame.size.height - 35 - 20, 35, 35);
//    }
//    else
//    {
//        dashboardHidden = YES;
//        infoView.alpha = 0.0;
//        self.navigationController.navigationBar.alpha = 0.0;
//        [showMapButton setImage:[UIImage imageNamed:@"dashboard2.png"] forState:UIControlStateNormal];
//        showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - 35 - 20, 35, 35);
//    }
//    [UIView commitAnimations];
//}

@end
