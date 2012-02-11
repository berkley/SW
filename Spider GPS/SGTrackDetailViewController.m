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
    timeAnnotations = [track timeAnnotationsWithInterval:[SGSession instance].timeMarkerInterval];
    [mapView addAnnotations:timeAnnotations];
    
    switch ([SGSession instance].timeMarkerInterval)
    {
        case 1:
            [segmentedControl setSelectedSegmentIndex:0];
            break;
        case 5:
            [segmentedControl setSelectedSegmentIndex:1];
            break;
        case 10:
            [segmentedControl setSelectedSegmentIndex:2];
            break;
        case 15:
            [segmentedControl setSelectedSegmentIndex:3];
            break;
        case 30:
            [segmentedControl setSelectedSegmentIndex:4];
            break;
        case 60:
            [segmentedControl setSelectedSegmentIndex:5];
            break;
        default:
            break;
    }
    
    slider.hidden = YES;
    sliderLabel.hidden = YES;
    sliderValueLabel.hidden = YES;
    segmentedControlLabel.text = @"Interval (minutes)";
    segmentedControl.hidden = NO;
    segmentedControlLabel.hidden = NO;
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
    mapView.mapType = [SGSession instance].detailsMapType;
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
    //add the track's annotations
    [mapView addAnnotations:track.annotations];
    //set view preferences
    [self prefModalDidClose];
    
    [SGSession zoomToFitLocations:track.locations padding:1 mapView:mapView];
    [[SGSession instance] hideActivityIndicator];
}

#pragma mark - notification selectors

- (void)ascentDescentChanged
{
    [mapView removeOverlays:mapView.overlays];
    if([SGSession instance].showAscentDescentView)
        [self addAscentDescentOverlay];
    else
        [self addTrackOverlay];
}

- (void)timeLabelsChanged
{
    if(timeAnnotations)
        [mapView removeAnnotations:timeAnnotations];
    timeAnnotations = nil;
    if([SGSession instance].showTimeMarkers)
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
        [SGSession instance].timeMarkerInterval = 1;
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    { //5
        [SGSession instance].timeMarkerInterval = 5;
    }
    else if(segmentedControl.selectedSegmentIndex == 2)
    { //10
        [SGSession instance].timeMarkerInterval = 10;
    }
    else if(segmentedControl.selectedSegmentIndex == 3)
    { //15
        [SGSession instance].timeMarkerInterval = 15;
    }
    else if(segmentedControl.selectedSegmentIndex == 4)
    { //30
        [SGSession instance].timeMarkerInterval = 30;
    }
    else if(segmentedControl.selectedSegmentIndex == 5)
    { //60
        [SGSession instance].timeMarkerInterval = 60;
    }
    
    timeAnnotations = [track timeAnnotationsWithInterval:[SGSession instance].timeMarkerInterval];
    [mapView addAnnotations:timeAnnotations];
}

- (void)preferenceBarButtonItemTouched
{
    prefViewController = [[SGDetailPreferencesModalViewController alloc] initWithNibName:@"SGDetailPreferencesModalViewController" bundle:nil];
    prefViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    prefViewController.delegate = self;
    
    [self presentModalViewController:prefViewController animated:YES];
}

- (void)prefModalDidClose
{
    mapView.mapType = [SGSession instance].detailsMapType;
    [self ascentDescentChanged];
    [self timeLabelsChanged];
}

@end
