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
        track = [[SGSession instance] getTrackWithName:trackName];
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
    mapView.mapType = [SGSession instance].mapType;
//    showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - infoView.frame.size.height - 35 - 20, 35, 35);
//    [showMapButton setImage:[UIImage imageNamed:@"map2.png"] forState:UIControlStateNormal];
//    [self.view addSubview:showMapButton];
//    dashboardHidden = NO;
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
    [super viewDidUnload];
}

- (void)doViewDidAppear
{
    //    NSLog(@"loc count: %i track: %@", [track.locations count], track.name);    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    
    if(style == TRACK_STYLE_NORMAL)
    {
        MKMapPoint *tempPointArr = [track singlePolyline];
        routeLine = [MKPolyline polylineWithPoints:tempPointArr count:[track.locations count]];
        [mapView addOverlay:routeLine];
        free(tempPointArr);
    }
    else if(style == TRACK_STYLE_RUN)
    {
        NSArray *polylines = [track arrayOfPolylines];       
        [mapView addOverlays:polylines];
    }
    else if(style == TRACK_STYLE_TIME)
    {
//        NSArray *polylines = [track timeBasedPolylines];
//        [mapView addOverlays:polylines];
        MKMapPoint *tempPointArr = [track singlePolyline];
        routeLine = [MKPolyline polylineWithPoints:tempPointArr count:[track.locations count]];
        [mapView addOverlay:routeLine];
        free(tempPointArr);
        [mapView addAnnotations:[track timeAnnotations]];
    }
    
    for(SGPinAnnotation *ann in track.annotations)
    {
        [mapView addAnnotation:ann];
    }
    
    [SGSession zoomToFitLocations:track.locations padding:1 mapView:mapView];
    [[SGSession instance] hideActivityIndicator];
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
        SGTimeAnnotationView *timeAnnView = [[SGTimeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"timeAnnotation"];
        timeAnnView.canShowCallout = NO;
        timeAnnView.userInteractionEnabled = NO;
        timeAnnView.frame = CGRectMake(0, 0, 20, 20);
        timeAnnView.backgroundColor = [UIColor clearColor];
        return timeAnnView;
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
