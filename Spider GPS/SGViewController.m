//
//  SGViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGViewController.h"

@implementation SGViewController


- (void)enableLocationServices
{
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    mapView.showsUserLocation = YES;
}

- (void)disableLocationServices
{
    [mapView setUserTrackingMode:MKUserTrackingModeNone];
    mapView.showsUserLocation = NO;
}


#pragma mark - init

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupForCurrentOrientation
{
//    if([[SGSession instance] orientationIsPortrait])
//    {
//        speedHeadingView.frame = CGRectMake(0, 460-90, 320, 90);
//        settingsView.frame = CGRectMake(0, 
//                                        speedHeadingView.frame.origin.y, 
//                                        settingsView.frame.size.width, 
//                                        0);
//    }
//    else
//    {
//        speedHeadingView.frame = CGRectMake(0, 320-90-20, 460, 90);
//        settingsView.frame = CGRectMake(0, 
//                                        speedHeadingView.frame.origin.y, 
//                                        settingsView.frame.size.width, 
//                                        0);
//    }
    [self setFields];
    settingsView.alpha = 0.0;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    pointCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:NOTIFICATION_ORIENTATION_CHANGED 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(locationUpdated:) 
                                                 name:NOTIFICATION_LOCATION_UPDATED 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(headingUpdated:) 
                                                 name:NOTIFICATION_HEADING_UPDATED 
                                               object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(disableLocationServices) 
                                                 name:NOTIFICATION_STOP_LOCATION_SERVICES 
                                               object:nil];   
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(speedHeadingViewTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [speedHeadingView addGestureRecognizer:tapRecognizer];
    
    mapView.delegate = self;
    drawerOpen = NO;
    useTrueHeading = [SGSession instance].useTrueHeading;
    useMPH = [SGSession instance].useMPH;
    if(!useMPH)
        unitSegmentedControl.selectedSegmentIndex = 1;
    if(!useTrueHeading)
        compassSegmentedControl.selectedSegmentIndex = 1;
    
    distance = 0.0;
    
    trackViewController = [[SGTrackViewController alloc] init];
    fieldsViewController = [[SGFieldSelectionViewController alloc] initWithNibName:@"SGFieldSelectionViewController" bundle:nil];
    navcon = [[UINavigationController alloc] initWithRootViewController:trackViewController];
    fieldsNavCon = [[UINavigationController alloc] initWithRootViewController:fieldsViewController];
    startTime = [NSDate date];
    lowSpeed = 99999999.99999;
    topAltitude = 0;
    lowAltidude = 99999999.9999;
    topSpeed = 0;
}

- (void)viewDidUnload
{
    mapView = nil;
    speedHeadingView = nil;
    speedLabel = nil;
    headingLabel = nil;
    longitudeLabel = nil;
    latitudeLabel = nil;
    drawerButton = nil;
    settingsView = nil;
    unitSegmentedControl = nil;
    compassSegmentedControl = nil;
    altitudeLabel = nil;
    distanceLabel = nil;
    mapDirectionFollowingSwitch = nil;
    topSpeedLabel = nil;
    lowSpeedLabel = nil;
    averageSpeedLabel = nil;
    timeLabel = nil;
    highAltitudeLabel = nil;
    lowAltitudeLabel = nil;
    latView = nil;
    headingView = nil;
    altView = nil;
    distView = nil;
    speedView = nil;
    topSpeedView = nil;
    lowSpeedView = nil;
    avgSpeedView = nil;
    timeView = nil;
    highAltView = nil;
    lowAltView = nil;
    lonView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupForCurrentOrientation];
    [self enableLocationServices];
}

- (void)removeSubviews
{
    [latView removeFromSuperview];
    [lonView removeFromSuperview];
    [headingView removeFromSuperview];
    [altView removeFromSuperview];
    [distView removeFromSuperview];
    [speedView removeFromSuperview];
    [topSpeedView removeFromSuperview];
    [lowSpeedView removeFromSuperview];
    [avgSpeedView removeFromSuperview];
    [timeView removeFromSuperview];
    [highAltView removeFromSuperview];
    [lowAltView removeFromSuperview];
}

- (void)setFields
{
    [self removeSubviews];
    int fieldCount = -1;
    int heightCount = 0;
    NSMutableArray *fieldViews = [[NSMutableArray alloc] init];
    for(NSString *field in [SGSession instance].fields)
    {
        fieldCount++;
        if([field isEqualToString:@"on"])
        {
            heightCount++;
            if(fieldCount == 0)
            { //total time
                [fieldViews addObject:timeView];
            }
            else if(fieldCount == 1)
            { //dist
                [fieldViews addObject:distView];
            }
            else if(fieldCount == 2)
            { //speed
                [fieldViews addObject:speedView];
            }
            else if(fieldCount == 3)
            { //avg speed
                [fieldViews addObject:avgSpeedView];
            }
            else if(fieldCount == 4)
            { //top speed
                [fieldViews addObject:topSpeedView];
            }
            else if(fieldCount == 5)
            { //low speed
                [fieldViews addObject:lowSpeedView];
            }
            else if(fieldCount == 6)
            { //current alt
                [fieldViews addObject:altView];
            }
            else if(fieldCount == 7)
            { //high alt
                [fieldViews addObject:highAltView];
            }
            else if(fieldCount == 8)
            { //low alt
                [fieldViews addObject:lowAltView];
            }
            else if(fieldCount == 9)
            { //lat
                [fieldViews addObject:latView];
            }
            else if(fieldCount == 10)
            { //long
                [fieldViews addObject:lonView];
            }
            else if(fieldCount == 11)
            { //heading
                [fieldViews addObject:headingView];
            }
        }
    }
    
    float height = (heightCount / 2.0);
    if(abs(height) != height)
        height = abs(height) + 1;
    height = height * 33;
    if([[SGSession instance] orientationIsPortrait])
        speedHeadingView.frame = CGRectMake(0, 460 - height, 320, height);
    else
        speedHeadingView.frame = CGRectMake(0, 320-height-20, 460, height);
    
    int m = 0;
    int v = -1;
    int fvCount = [fieldViews count];
    
    float iCount = [fieldViews count] / 2.0;
    if(abs(iCount) != iCount)
        iCount = abs(iCount) + 1;
    while(v < fvCount)
    {
        for(int j=0; j<2; j++)
        {
            v++;
            if(v == fvCount)
                break;
               
            UIView *view = [fieldViews objectAtIndex:v];
            float x = 10.0;
            if(j == 1)
                x = 180.0;
            
            float y = m * 33 + 5;
            view.frame = CGRectMake(x, y, 160, 33);
            [speedHeadingView addSubview:view];
        }
        m++;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(mapView.userTrackingMode == MKUserTrackingModeFollowWithHeading)
        mapDirectionFollowingSwitch.on = YES;
    else
        mapDirectionFollowingSwitch.on = NO;
    [self.view addSubview:speedHeadingView];
    routeArray = [[NSMutableArray alloc] init];
    [self.view addSubview:settingsView];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)orientationDidChange:(NSNotification*)notification
{
    [self setupForCurrentOrientation];
}

- (void)didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    NSString *latDir = @"N";
    NSString *lonDir = @"E";
    CGFloat lon = newLocation.coordinate.longitude;
    CGFloat lat = newLocation.coordinate.latitude;
    if(lat < 0)
    {
        latDir = @"S";
        lat = lat * -1;
    }
    
    if(lon < 0)
    {
        lonDir = @"W";
        lon = lon * -1;
    }
    
    if(newLocation.speed < lowSpeed && newLocation.speed >= 0)
        lowSpeed = newLocation.speed;
    
    if(newLocation.speed > topSpeed)
        topSpeed = newLocation.speed;
    
    if(newLocation.altitude > topAltitude)
        topAltitude = newLocation.altitude;
    
    if(newLocation.altitude < lowAltidude && newLocation.altitude >= 0)
        lowAltidude = newLocation.altitude;
    
    if(useMPH)
    {
        speedLabel.text = [NSString stringWithFormat:@"%.0f mph", newLocation.speed * METERS_TO_MPH];
        altitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", newLocation.altitude * METERS_TO_FT];
        if(newLocation.speed < 0)
            speedLabel.text = @"0 mph";
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.0f mph", lowSpeed * METERS_TO_MPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.0f mph", topSpeed * METERS_TO_MPH];
        lowAltitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", lowAltidude * METERS_TO_FT];
        highAltitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", topAltitude * METERS_TO_FT];
    }
    else
    {
        speedLabel.text = [NSString stringWithFormat:@"%.0f kph", newLocation.speed * METERS_TO_KPH];
        altitudeLabel.text = [NSString stringWithFormat:@"%.0f m", newLocation.altitude];
        if(newLocation.speed < 0)
            speedLabel.text = @"0 kph";
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.0f kph", lowSpeed * METERS_TO_KPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.0f kph", topSpeed * METERS_TO_KPH];
        lowAltitudeLabel.text = [NSString stringWithFormat:@"%.0f m", lowAltidude];
        highAltitudeLabel.text = [NSString stringWithFormat:@"%.0f m", topAltitude];
    }
    
    endTime = [NSDate date];
    [SGSession instance].currentTrack.totalTime = [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:startTime]];
    timeLabel.text = [SGSession formattedElapsedTime:startTime date2:endTime];
    averageSpeedLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:totalSpeed / [[SGSession instance].currentTrack.locations count]]];
    
    if(newLocation.speed < 0)
        speedLabel.text = @"0";
    
    latitudeLabel.text = [NSString stringWithFormat:@"%.4f\u00b0 %@", lat, latDir];
    longitudeLabel.text = [NSString stringWithFormat:@"%.4f\u00b0 %@", lon, lonDir];
    
    MKMapPoint newPoint = MKMapPointForCoordinate(newLocation.coordinate);
    pointCount++;
    MKMapPoint* tempPointArr = malloc(sizeof(CLLocationCoordinate2D) * pointCount);
    for(int i=0; i<pointCount - 1; i++)
    {
        tempPointArr[i] = pointArr[i];
    }
    tempPointArr[pointCount - 1] = newPoint;
    routeLine = [MKPolyline polylineWithPoints:tempPointArr count:pointCount];
    if(pointArr)
        free(pointArr);
    pointArr = tempPointArr;
    NSArray *oldOverlays = mapView.overlays;
    [mapView addOverlay:routeLine];
    [mapView removeOverlays:oldOverlays];
    
    distance = distance + [newLocation distanceFromLocation:oldLocation]; //calc distance in meters
    if(useMPH)
    {
        distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", distance * METERS_TO_MILES];
    }
    else
    {
        distanceLabel.text = [NSString stringWithFormat:@"%.2f km", distance / METERS_TO_KM];
    }
    
    [[SGSession instance].currentTrack addDataWithLocation:newLocation distance:distance];
}

- (void)locationUpdated:(NSNotification*)notification
{
    [self didUpdateToLocation:[notification.userInfo objectForKey:@"newLocation"] 
                 fromLocation:[notification.userInfo objectForKey:@"oldLocation"]];
}


- (void)didUpdateHeading:(CLHeading *)newHeading
{
    if(useTrueHeading)
        headingLabel.text = [NSString stringWithFormat:@"%.0f\u00b0 (T)", newHeading.trueHeading];
    else
        headingLabel.text = [NSString stringWithFormat:@"%.0f\u00b0 (M)", newHeading.magneticHeading];
}

- (void)headingUpdated:(NSNotification*)notification
{
    [self didUpdateHeading:[notification.userInfo objectForKey:@"newHeading"]];
}

#pragma mark - mapview delegate methods

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

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if(mode == MKUserTrackingModeFollowWithHeading)
        mapDirectionFollowingSwitch.on = YES;
    else
        mapDirectionFollowingSwitch.on = NO;
}

- (IBAction)resetBreadcrumbButtonTouched:(id)sender 
{
    free(pointArr);
    pointArr = malloc(sizeof(CLLocationCoordinate2D) * 1);
    pointCount = 0;
    [mapView removeOverlays:mapView.overlays];
    distance = 0.0;
    [[SGSession instance] createNewTrack];
    startTime = [NSDate date];
}

- (IBAction)saveTracksButtonTouched:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Track Name" 
                                                    message:@"Please name your track." 
                                                   delegate:self cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)showTracksButtonTouched:(id)sender 
{
    [self presentModalViewController:navcon animated:YES];
}

- (IBAction)setFieldsButtonTouched:(id)sender 
{
    [self presentModalViewController:fieldsNavCon animated:YES];
}

- (IBAction)mapDirectionFollowingValueChanged:(id)sender 
{
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    if(mapDirectionFollowingSwitch.on)
        [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

- (IBAction)drawerButtonTouched:(id)sender 
{
    drawerOpen = !drawerOpen;
    [UIView beginAnimations:@"animateDrawer" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1];
    if(drawerOpen)
    {
        if([[SGSession instance] orientationIsPortrait])
            settingsView.frame = CGRectMake(0, 
                                            speedHeadingView.frame.origin.y - SETTINGS_HEIGHT, 
                                            settingsView.frame.size.width, 
                                            SETTINGS_HEIGHT);
        else
            settingsView.frame = CGRectMake(0, 
                                            speedHeadingView.frame.origin.y - SETTINGS_HEIGHT, 
                                            settingsView.frame.size.width, 
                                            SETTINGS_HEIGHT);
        settingsView.alpha = .8;
    }
    else
    {
        if([[SGSession instance] orientationIsPortrait])
            settingsView.frame = CGRectMake(0, 
                                            speedHeadingView.frame.origin.y, 
                                            settingsView.frame.size.width, 
                                            0);
        else
            settingsView.frame = CGRectMake(0, 
                                            speedHeadingView.frame.origin.y, 
                                            settingsView.frame.size.width, 
                                            0);
        settingsView.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)speedHeadingViewTapped:(id)sender
{
    [self drawerButtonTouched:sender];
}

- (IBAction)unitsSegmentValueChanged:(id)sender 
{
    if(unitSegmentedControl.selectedSegmentIndex == 0)
        useMPH = YES;
    else
        useMPH = NO;
    [SGSession instance].useMPH = useMPH;
}

- (IBAction)compassSegmentValueChanged:(id)sender 
{
    if(compassSegmentedControl.selectedSegmentIndex == 0)
        useTrueHeading = YES;
    else
        useTrueHeading = NO;
    [SGSession instance].useTrueHeading = useTrueHeading;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    { //Save
        NSString *name = [alertView textFieldAtIndex:0].text;
        if(name == nil || [name isEqualToString:@""])
        {
            //TODO
        }
        else
        {
            endTime = [NSDate date];
            [SGSession instance].currentTrack.totalTime = [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:startTime]];
            [[SGSession instance] saveCurrentTrackWithName:name];
        }
    }
}

@end
