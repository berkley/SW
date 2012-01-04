//
//  SGTrackDetailViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGTrackDetailViewController.h"

@implementation SGTrackDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trackName:(NSString*)trackName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        track = [[SGSession instance].tracks objectForKey:trackName];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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

- (void)viewDidAppear:(BOOL)animated
{
    if([SGSession instance].useMPH)
    { //imperial
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles", [track.distance floatValue] * METERS_TO_MILES];
        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.avgSpeed floatValue] * METERS_TO_MPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.topSpeed floatValue] * METERS_TO_MPH];
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.lowSpeed floatValue] * METERS_TO_MPH];
        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.topAlitude floatValue] * METERS_TO_FT];
        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.lowAltidude floatValue] * METERS_TO_FT];
    }
    else
    { //metric
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f km", [track.distance floatValue] * METERS_TO_KM];
        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.avgSpeed floatValue] * METERS_TO_KPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.topSpeed floatValue] * METERS_TO_KPH];
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.lowSpeed floatValue] * METERS_TO_KPH];
        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.topAlitude floatValue]];
        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.lowAltidude floatValue]];        
    }
        
    NSTimeInterval theTimeInterval = [track.totalTime doubleValue];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
    
    totalTimeLabel.text = [SGSession formattedElapsedTime:date1 date2:date2];

    MKMapPoint* tempPointArr = malloc(sizeof(CLLocationCoordinate2D) * [track.locations count]);
    int pointCount = 0;
    for(CLLocation *loc in track.locations)
    {
        MKMapPoint newPoint = MKMapPointForCoordinate(loc.coordinate);
        tempPointArr[pointCount] = newPoint;
        pointCount++;
    }
    routeLine = [MKPolyline polylineWithPoints:tempPointArr count:pointCount];
    if(tempPointArr)
        free(tempPointArr);
    [mapView removeOverlays:mapView.overlays];
    [mapView addOverlay:routeLine];
    [SGSession zoomToFitLocations:track.locations padding:1 mapView:mapView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [mapView addGestureRecognizer:tapRecognizer];
}

- (void)hideInfoView
{
    infoView.hidden = YES;
}

- (void)mapTapped:(id)sender
{
    [UIView beginAnimations:@"hideInfoBar" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.5];
    if(infoView.hidden)
    {
        infoView.hidden = NO;
        infoView.alpha = 0.8;
    }
    else
    {
        infoView.alpha = 0.0;
        [self performSelector:@selector(hideInfoView) withObject:nil afterDelay:1.0];
    }
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    totalDistanceLabel = nil;
    avgSpeedLabel = nil;
    topSpeedLabel = nil;
    lowSpeedLabel = nil;
    highestAltitudeLabel = nil;
    lowestAltitudeLabel = nil;
    totalTimeLabel = nil;
    mapView = nil;
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
    
    if(overlay == routeLine)
    {
        routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
        routeLineView.fillColor = [UIColor blueColor];
        routeLineView.strokeColor = [UIColor blueColor];
        routeLineView.lineWidth = 5;
        overlayView = routeLineView;
    }
    
    return overlayView;
}

@end
