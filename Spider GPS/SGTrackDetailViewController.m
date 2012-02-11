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
        track = [[SGSession instance] getTrackWithName:trackName];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationItem.title = trackName;
        optionsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pagecurl.png"]
                                                       style:UIBarButtonItemStylePlain 
                                                      target:self 
                                                      action:@selector(preferenceBarButtonItemTouched)];
        self.navigationItem.rightBarButtonItem = optionsItem;
        self.navigationItem.rightBarButtonItem.width = 30;
        polylineCount = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - overlays and annotations

- (void)addTrackOverlay
{
    MKMapPoint *tempPointArr = [track singlePolyline];
    routeLine = [MKPolyline polylineWithPoints:tempPointArr count:[track.locations count]];
    [mapView addOverlay:routeLine];
    free(tempPointArr);
    slider.hidden = YES;
    sliderLabel.hidden = YES;
    sliderValueLabel.hidden = YES;
    segmentedControl.hidden = YES;
    segmentedControlLabel.hidden = YES;
}

- (void)addAscentDescentOverlay
{
    NSArray *polylines = [track arrayOfPolylines];       
    [mapView addOverlays:polylines];
    slider.hidden = YES;
    sliderLabel.hidden = YES;
    sliderValueLabel.hidden = YES;
    segmentedControl.hidden = YES;
    segmentedControlLabel.hidden = YES;
}

- (void)addTimeLabels
{
    timeAnnotations = [track timeAnnotationsWithInterval:5];
    [mapView addAnnotations:timeAnnotations];
    
    slider.hidden = YES;
    sliderLabel.hidden = YES;
    sliderValueLabel.hidden = YES;
    segmentedControlLabel.text = @"Interval (minutes)";
    segmentedControl.hidden = NO;
    segmentedControlLabel.hidden = NO;
    segmentedControl.selectedSegmentIndex = 1;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    showAscentDescent = NO;
    showTimeLabels = NO;
    mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mapView.mapType = [SGSession instance].mapType;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[SGSession instance] showActivityIndicator:self description:@"Processing Track" withProgress:NO];
    [self performSelectorInBackground:@selector(doViewDidAppear) withObject:nil];
}

- (void)viewDidUnload
{
    mapView = nil;
    showMapButton = nil;
    slider = nil;
    sliderLabel = nil;
    sliderValueLabel = nil;
    segmentedControl = nil;
    segmentedControlLabel = nil;
    [super viewDidUnload];
}

- (void)doViewDidAppear
{
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    [self addTrackOverlay];
    showTimeLabels = NO;
    showAscentDescent = NO;
//    for(SGPinAnnotation *ann in track.annotations)
//    {
//        [mapView addAnnotation:ann];
//    }

    [mapView addAnnotations:track.annotations];
    
    [SGSession zoomToFitLocations:track.locations padding:1 mapView:mapView];
    [[SGSession instance] hideActivityIndicator];
}

#pragma mark - notification selectors

- (void)ascentDescentChanged
{
    showAscentDescent = prefViewController.ascentDescentOn;
    [mapView removeOverlays:mapView.overlays];
    if(showAscentDescent)
        [self addAscentDescentOverlay];
    else
        [self addTrackOverlay];
}

- (void)mapTypeChanged
{
    if(prefViewController.mapTypeSegCon.selectedSegmentIndex == 0)
        mapView.mapType = MKMapTypeStandard;
    else if(prefViewController.mapTypeSegCon.selectedSegmentIndex == 1)
        mapView.mapType = MKMapTypeSatellite;
    else if(prefViewController.mapTypeSegCon.selectedSegmentIndex == 2)
        mapView.mapType = MKMapTypeHybrid;
}

- (void)timeLabelsChanged
{
    
    showTimeLabels = prefViewController.timeLabelOn;
    if(timeAnnotations)
        [mapView removeAnnotations:timeAnnotations];
    timeAnnotations = nil;
    if(showTimeLabels)
    {
        [self addTimeLabels];
        segmentedControl.hidden = NO;
        segmentedControlLabel.hidden = NO;
    }
    else
    {
        segmentedControl.hidden = YES;
        segmentedControlLabel.hidden = YES;
    }
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
    else if([annotation isKindOfClass:[SGTimeAnnotation class]])
    {
        SGTimeAnnotationView *timeAnnView = [[SGTimeAnnotationView alloc] initWithAnnotation:annotation 
                                                                             reuseIdentifier:@"timeAnnotation"];
        timeAnnView.canShowCallout = NO;
        timeAnnView.userInteractionEnabled = NO;
        timeAnnView.frame = CGRectMake(0, 0, 20, 20);
        timeAnnView.backgroundColor = [UIColor clearColor];
        return timeAnnView;
    }
    return nil;
}

- (IBAction)sliderValueChanged:(id)sender 
{
    NSInteger val = [[NSNumber numberWithFloat:slider.value] intValue];
    sliderValueLabel.text = [NSString stringWithFormat:@"%i", val];
}

- (IBAction)segmentedControlValueChanged:(id)sender 
{
    [mapView removeAnnotations:mapView.annotations];
    if(segmentedControl.selectedSegmentIndex == 0)
    { //1
        [mapView addAnnotations:[track timeAnnotationsWithInterval:1]];
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    { //5
        [mapView addAnnotations:[track timeAnnotationsWithInterval:5]];
    }
    else if(segmentedControl.selectedSegmentIndex == 2)
    { //10
        [mapView addAnnotations:[track timeAnnotationsWithInterval:10]];
    }
    else if(segmentedControl.selectedSegmentIndex == 3)
    { //15
        [mapView addAnnotations:[track timeAnnotationsWithInterval:15]];
    }
    else if(segmentedControl.selectedSegmentIndex == 4)
    { //30
        [mapView addAnnotations:[track timeAnnotationsWithInterval:30]];
    }
    else if(segmentedControl.selectedSegmentIndex == 5)
    { //60
        [mapView addAnnotations:[track timeAnnotationsWithInterval:60]];
    }
}

- (void)preferenceBarButtonItemTouched
{
    prefViewController = [[SGDetailPreferencesModalViewController alloc] initWithNibName:@"SGDetailPreferencesModalViewController" bundle:nil];
    prefViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    prefViewController.mapType = mapView.mapType;
    prefViewController.ascentDescentOn = showAscentDescent;
    prefViewController.timeLabelOn = showTimeLabels;
    prefViewController.delegate = self;
    
    [self presentModalViewController:prefViewController animated:YES];
}

- (void)prefModalDidClose
{
    [self ascentDescentChanged];
    [self timeLabelsChanged];
    [self mapTypeChanged];
}

@end
