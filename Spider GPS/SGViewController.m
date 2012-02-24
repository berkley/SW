//
//  SGViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGViewController.h"

@implementation SGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        startupLocationCount = 0;
    }
    return self;
}

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

- (void)displayActivityIndicator
{
    [[SGSession instance] showActivityIndicator:self description:@"Saving Track" withProgress:NO];
}

- (void)stopActivityIndicator
{
    [[SGSession instance] hideActivityIndicator];
}

- (void)startActivityIndicator
{
    [self performSelectorOnMainThread:@selector(displayActivityIndicator) withObject:nil waitUntilDone:NO];
}

- (void)collectionDidPause
{
    [UIView beginAnimations:@"changeViewHeight" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.5];
    [self setFields];
    [UIView commitAnimations];
}

- (void)collectionDidUnPause
{
    [UIView beginAnimations:@"changeViewHeight" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.5];
    [self setFields];
    [UIView commitAnimations];
}

#pragma mark - init

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupForCurrentOrientation
{
    [self setFields];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    pointCount = 0;
    paused = NO;
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
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(startActivityIndicator) 
                                                 name:NOTIFICATION_START_ACTIVITY_INDICATOR 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(stopActivityIndicator) 
                                                 name:NOTIFICATION_STOP_ACTIVITY_INDICATOR 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(collectionDidPause) 
                                                 name:NOTIFICATION_LOCATIONS_COLLECTION_PAUSED 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(collectionDidUnPause) 
                                                 name:NOTIFICATION_LOCATIONS_COLLECTION_UNPAUSED 
                                               object:nil];    
    mapView.delegate = self;
    if(![SGSession instance].useMPH)
        unitSegmentedControl.selectedSegmentIndex = 1;
    if(![SGSession instance].useTrueHeading)
        compassSegmentedControl.selectedSegmentIndex = 1;
    
    distance = 0.0;
    
    speedHeadingView = [[HUDView alloc] initWithFrame:CGRectMake(0, 0, 316, 214) 
                                       tlCornerCurved:YES 
                                       trCornerCurved:YES
                                       blCornerCurved:NO 
                                       brCornerCurved:NO 
                                       arrowDirection:ARROW_DIRECTION_NONE];
    speedHeadingView.backgroundColor = [UIColor clearColor];
    
    trackViewController = [[SGTrackViewController alloc] init];
    fieldsViewController = [[SGFieldSelectionViewController alloc] initWithNibName:@"SGFieldSelectionViewController" bundle:nil];
    navcon = [[UINavigationController alloc] initWithRootViewController:trackViewController];
    navcon.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    fieldsNavCon = [[UINavigationController alloc] initWithRootViewController:fieldsViewController];
    fieldsNavCon.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    startTime = [NSDate date];
    lowSpeed = 99999999.99999;
    topAltitude = 0;
    lowAltidude = 99999999.9999;
    topSpeed = 0;
    accuracyTotal = 0.0;
    accuracyCount = 0;
    addPointCount = 0;
    
    [self.view addSubview:showMapButton];
    
//    [SGTest testAltitudeWithTrackName:@"ski bowl jan 16 2012"];
//    [SGTest testAltitudeWithTrackName:@"alberta"];
//    [SGTest testAltitudeWithTrackName:@"to skibowl"];
}

- (void)viewDidUnload
{
    mapView = nil;
    speedHeadingView = nil;
    speedLabel = nil;
    headingLabel = nil;
    longitudeLabel = nil;
    latitudeLabel = nil;
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
    locationButton = nil;
    altGainView = nil;
    altLossView = nil;
    altGainLabel = nil;
    altLossLabel = nil;
    playButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupForCurrentOrientation];
    [self enableLocationServices];
    
    showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - speedHeadingView.frame.size.height - 40 - 20, 35, 35);
    mapView.frame = CGRectMake(0, 0, 320, 460 - speedHeadingView.frame.size.height);
    [showMapButton setImage:[UIImage imageNamed:@"mapincircle.png"] forState:UIControlStateNormal];
    dashboardHidden = NO;
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
    int fieldViewHeight = 20;
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
            else if(fieldCount == 12)
            { //alt gain
                [fieldViews addObject:altGainView];
            }
            else if(fieldCount == 13)
            { //alt loss
                [fieldViews addObject:altLossView];
            }
                    
        }
    }
    
    float height = (heightCount / 2.0);
    if(abs(height) != height)
        height = abs(height) + 1;
    height = height * fieldViewHeight + 10;
    
    UILabel *pausedLabel = (UILabel*)[speedHeadingView viewWithTag:9999];
    if(!pausedLabel)
    {
        pausedLabel = [[UILabel alloc] init];
        [speedHeadingView addSubview:pausedLabel];
    }
    pausedLabel.tag = 9999;
    pausedLabel.frame = CGRectMake(10, height, speedHeadingView.frame.size.width, 22);
    
    if(paused)
    {
        height += 20;
        pausedLabel.frame = CGRectMake(10, height - 25, speedHeadingView.frame.size.width, 22);
        pausedLabel.alpha = 1.0;
        pausedLabel.textColor = [UIColor redColor];
        pausedLabel.font = [UIFont systemFontOfSize:20.0];
        pausedLabel.backgroundColor = [UIColor clearColor];
        pausedLabel.text = @"Location Collection Paused";
    }
    else
    {
        UIView *pausedLabel = [speedHeadingView viewWithTag:9999];
        pausedLabel.alpha = 0.0;
    }

    speedHeadingView.frame = CGRectMake(0, 480-height-20, 320, height);
    mapView.frame = CGRectMake(0, 0, 320, 460 - speedHeadingView.frame.size.height);
    showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - speedHeadingView.frame.size.height - 40 - 20, 35, 35);
    
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
            
            float y = m * fieldViewHeight + 5;
            view.frame = CGRectMake(x, y, 160, fieldViewHeight);
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
    mapView.mapType = [SGSession instance].mapType;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)orientationDidChange:(NSNotification*)notification
{
    [self setupForCurrentOrientation];
}

//where all the magic happens
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
    
    endTime = [NSDate date];    
    avgSpeed = [SGTrack calculateAvgSpeedForDistance:distance fromDate:startTime toDate:endTime];
    
    if([SGSession instance].useMPH)
    {
        speedLabel.text = [NSString stringWithFormat:@"%.0f mph", newLocation.speed * METERS_TO_MPH];
        altitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", newLocation.altitude * METERS_TO_FT];
        if(newLocation.speed < 0)
            speedLabel.text = @"0 mph";
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.0f mph", lowSpeed * METERS_TO_MPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.0f mph", topSpeed * METERS_TO_MPH];
        lowAltitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", lowAltidude * METERS_TO_FT];
        highAltitudeLabel.text = [NSString stringWithFormat:@"%.0f ft", topAltitude * METERS_TO_FT];
        averageSpeedLabel.text = [NSString stringWithFormat:@"%.1f mph", avgSpeed * METERS_TO_MPH];
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
        averageSpeedLabel.text = [NSString stringWithFormat:@"%.1f kph", avgSpeed * METERS_TO_KPH];
    }
    

    [SGSession instance].currentTrack.totalTime = [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:startTime]];
    timeLabel.text = [SGSession formattedElapsedTime:startTime date2:endTime];
    
    if(newLocation.speed < 0)
        speedLabel.text = @"0";
    
    latitudeLabel.text = [NSString stringWithFormat:@"%.4f\u00b0 %@", lat, latDir];
    longitudeLabel.text = [NSString stringWithFormat:@"%.4f\u00b0 %@", lon, lonDir];
    
    //calc distance
    distance = distance + [newLocation distanceFromLocation:oldLocation]; //calc distance in meters
    if(distance < 0)
        distance = 0;
    if([SGSession instance].useMPH)
    {
        distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", distance * METERS_TO_MILES];
    }
    else
    {
        distanceLabel.text = [NSString stringWithFormat:@"%.2f km", distance * METERS_TO_KM];
    }
    
    BOOL addPoint = YES;
    //calculate avg accuracy to smooth this line
    if(accuracyCount > NUM_POINTS_FOR_ACCURACY)
    {
        double avgAccuracy = accuracyTotal / (double)accuracyCount;
//        NSLog(@"avgAccuracy: %f", avgAccuracy);
        if(newLocation.horizontalAccuracy > avgAccuracy + ACCURACY_THRESHOLD || 
           newLocation.horizontalAccuracy < avgAccuracy - ACCURACY_THRESHOLD)
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
        //draw the route line
        pointCount++;
        CLLocationCoordinate2D *locs = malloc(sizeof(CLLocationCoordinate2D) * 2);
        
        if(previousLocation)
        {
//            NSLog(@"new: %f %f prv: %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude,
//                  previousLocation.coordinate.latitude, previousLocation.coordinate.longitude);
            locs[0] = previousLocation.coordinate;
            locs[1] = newLocation.coordinate;
            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:locs count:2];
            polyline.title = @"new";
            [self performSelectorOnMainThread:@selector(addPoint:) withObject:polyline waitUntilDone:NO];
        }
        
        previousLocation = newLocation;
        
    }
    
//    if(addPoint)
//    {
//        //draw the route line
//        MKMapPoint newPoint = MKMapPointForCoordinate(newLocation.coordinate);
//        pointCount++;
//        MKMapPoint* tempPointArr = malloc(sizeof(CLLocationCoordinate2D) * pointCount);
//        for(int i=0; i<pointCount - 1; i++)
//        {
//            tempPointArr[i] = pointArr[i];
//        }
//        tempPointArr[pointCount - 1] = newPoint;
//        routeLine = [MKPolyline polylineWithPoints:tempPointArr count:pointCount];
//        if(pointArr)
//            free(pointArr);
//        pointArr = tempPointArr;
//        NSArray *oldOverlays = mapView.overlays;
//        [mapView addOverlay:routeLine];
//        [mapView removeOverlays:oldOverlays];
//        
//        //record data
//        [[SGSession instance].currentTrack addDataWithLocation:newLocation 
//                                                      distance:distance 
//                                                     startTime:startTime 
//                                                      stopTime:endTime];    
//    }
    
    if([SGSession instance].useMPH)
    {
        altGainLabel.text = [NSString stringWithFormat:@"%.1f ft", 
                             [[SGSession instance].currentTrack.totalAscent floatValue] * METERS_TO_FT];
        altLossLabel.text = [NSString stringWithFormat:@"%.1f ft", 
                             [[SGSession instance].currentTrack.totalDescent floatValue] * METERS_TO_FT];
    }
    else
    {
        altGainLabel.text = [NSString stringWithFormat:@"%.1f m", 
                             [[SGSession instance].currentTrack.totalAscent floatValue]];
        altLossLabel.text = [NSString stringWithFormat:@"%.1f m", 
                             [[SGSession instance].currentTrack.totalDescent floatValue]];        
    }
    
    accuracyTotal += newLocation.horizontalAccuracy;
    accuracyCount++;
    
}

- (void)removePreviousOverlay:(NSArray*)arr
{
    [mapView removeOverlays:arr];
}

- (void)addPoint:(MKPolyline*)polyline
{
    [mapView addOverlay:polyline];
}

- (void)locationUpdated:(NSNotification*)notification
{
    //throw away the first few points because they're crap
    if(startupLocationCount < STARTUP_LOCATION_COUNT_MIN) 
    {
        startupLocationCount++;
        return;
    }
    
    if(paused)
        return;
    
    [self didUpdateToLocation:[notification.userInfo objectForKey:@"newLocation"] 
                 fromLocation:[notification.userInfo objectForKey:@"oldLocation"]];
}

- (NSString*)getCardinalHeading:(CGFloat)heading
{
    if((heading > 0 && heading <= 22.5) || (heading > 337.5 && heading <= 360))
        return @"N";
    else if(heading > 22.5 && heading <= 67.5)
        return @"NE";
    else if(heading > 67.6 && heading <= 112.5)
        return @"E";
    else if(heading > 112.5 && heading <= 157.5)
        return @"SE";
    else if(heading > 157.5 && heading <= 202.5)
        return @"S";
    else if(heading > 202.5 && heading <= 247.5)
        return @"SW";
    else if(heading > 247.5 && heading <= 292.5)
        return @"W";
    else// if(heading > 292.5 && heading < 337.5)
        return @"NW";
}

- (void)didUpdateHeading:(CLHeading *)newHeading
{
    if([SGSession instance].useTrueHeading)
    {
        NSString *cardHeading = [self getCardinalHeading:newHeading.trueHeading];
        headingLabel.text = [NSString stringWithFormat:@"%@ (%.0f\u00b0) T", cardHeading, newHeading.trueHeading];
    }
    else
    {
        NSString *cardHeading = [self getCardinalHeading:newHeading.magneticHeading];
        headingLabel.text = [NSString stringWithFormat:@"%@ (%.0f\u00b0) M", cardHeading, newHeading.magneticHeading];
    }
}

- (void)headingUpdated:(NSNotification*)notification
{
    [self didUpdateHeading:[notification.userInfo objectForKey:@"newHeading"]];
}

#pragma mark - mapview delegate methods

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

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{    
    MKPolylineView *routeLineView;
    if([overlay isKindOfClass:[MKPolyline class]] && 
       [((MKPolyline*)overlay).title isEqualToString:@"new"])
    {
        routeLineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline*)overlay];
        routeLineView.fillColor = [UIColor blueColor];
        routeLineView.strokeColor = [UIColor blueColor];
        routeLineView.lineWidth = 5;
        ((MKPolyline*)overlay).title = @"old";
    }
    
    return routeLineView;
}

- (void)mapView:(MKMapView *)mv didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if(mapView.userTrackingMode == MKUserTrackingModeFollowWithHeading)
    {
        locationButton.image = [UIImage imageNamed:@"compass.png"];
    }
    else if(mapView.userTrackingMode == MKUserTrackingModeFollow)
    {
        locationButton.image = [UIImage imageNamed:@"location-arrow.png"];
    }
    else
    {
        locationButton.image = [UIImage imageNamed:@"location-target.png"];
    }
}

- (IBAction)mapDirectionFollowingValueChanged:(id)sender 
{
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    if(mapDirectionFollowingSwitch.on)
        [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 9000)
    { //save track
        if(buttonIndex == 1)
        { //Save
            NSString *name = [alertView textFieldAtIndex:0].text;
            NSString *trackKey = [[SGSession instance].tracks objectForKey:name];
            if(trackKey)
            { //the track name already exists, ask to overwrite
                NSString *msg = [NSString stringWithFormat:@"A track with the name '%@' already exists. Are you sure you want to overwrite it?", name];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Overwrite?" 
                                                                message:msg 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Cancel" 
                                                      otherButtonTitles:@"Save", nil];
                alert.tag = 9003;
                savename = name;
                [alert show];
            }
            else
            {
                if(name == nil || [name isEqualToString:@""])
                    name = @"Untitled Track";

                endTime = [NSDate date];
                [SGSession instance].currentTrack.name = name;
                [SGSession instance].currentTrack.totalTime = [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:startTime]];
                [self startActivityIndicator];
                [[SGSession instance] performSelector:@selector(saveCurrentTrackWithName:) withObject:name afterDelay:.1];
            }
        }
    }
    else if(alertView.tag == 9001)
    { //add annotation
        if(buttonIndex == 1)
        { //save
            SGPinAnnotation *ann = [[SGPinAnnotation alloc] 
                                    initWithCoordinate:[SGSession instance].currentLocation.coordinate];
            NSString *name = [alertView textFieldAtIndex:0].text;
            if(name == nil || [name isEqualToString:@""])
                name = @"Untitled Pin";
            ann.title = name;
            ann.location = [SGSession instance].currentLocation;
            [mapView addAnnotation:ann];
            [[SGSession instance].currentTrack.annotations addObject:ann];
            [self performSelector:@selector(selectAnnoation:) withObject:ann afterDelay:.5];
        }
    }
    else if(alertView.tag == 9002)
    { //are you sure you wan to reset
        if(buttonIndex == 1)
        {
            pointCount = 0;
            [mapView removeOverlays:mapView.overlays];
            distance = 0.0;
            avgSpeed = 0.0;
            topSpeed = 0;
            lowSpeed = 9999999;
            topAltitude = 0.0;
            lowAltidude = 9999999;
            totalSpeed = 0.0;
            [[SGSession instance].tracks removeObjectForKey:@"Auto-saved Track"];
            [[SGSession instance] saveTracks];
            [[SGSession instance] createNewTrack];
            startTime = [NSDate date];
        }
    }
    else if(alertView.tag == 9003)
    { //save after overwrite msg
        if(buttonIndex == 1)
        {
            endTime = [NSDate date];
            [SGSession instance].currentTrack.name = savename;
            [SGSession instance].currentTrack.totalTime = [NSNumber numberWithDouble:[endTime timeIntervalSinceDate:startTime]];
            [self startActivityIndicator];
            [[SGSession instance] performSelector:@selector(saveCurrentTrackWithName:) withObject:savename afterDelay:.1];
        }
    }
    else if(alertView.tag == 9004)
    { //track paused
        if(buttonIndex == 1)
            [SGSession instance].showPauseMessage = NO;
    }
}

- (void)selectAnnoation:(SGPinAnnotation*)ann
{
    [mapView selectAnnotation:ann animated:YES];
}

- (IBAction)gearMenuTouched:(id)sender 
{
    [self presentModalViewController:fieldsNavCon animated:YES];
}

- (IBAction)resetTrackButtonTouched:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" 
                                                    message:@"Are you sure you want to reset the current track?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Reset", nil];
    alert.tag = 9002;
    [alert show];
}

- (IBAction)locationButtonTouched:(id)sender 
{
    if(mapView.userTrackingMode == MKUserTrackingModeFollowWithHeading)
    {
        mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    else if(mapView.userTrackingMode == MKUserTrackingModeFollow)
    {
        mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    }
    else
    {
        mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
}

- (IBAction)playButtonTouched:(id)sender 
{
    if(paused)
    {
        playButton.image = [UIImage imageNamed:@"play.png"];        
        paused = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATIONS_COLLECTION_UNPAUSED 
                                                            object:nil];

    }
    else
    {
        if([SGSession instance].showPauseMessage)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Collection Paused" 
                                                            message:@"You have paused location collection. No locations will be recorded while track collection is paused." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:@"Don't Show Again", nil];
            alert.tag = 9004;
            [alert show];
        }

        playButton.image = [UIImage imageNamed:@"pause.png"];
        paused = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATIONS_COLLECTION_PAUSED 
                                                            object:nil];
    }
}

- (IBAction)pinButtonTouched:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pin Name" 
                                                    message:@"Please name your pin." 
                                                   delegate:self 
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Drop Pin", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 9001;
    [alert show];
}

- (IBAction)tracksButtonTouched:(id)sender 
{
    [self presentModalViewController:navcon animated:YES];
}

- (IBAction)saveButtonTouched:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Track Name" 
                                                    message:@"Please name your track." 
                                                   delegate:self cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if([SGSession instance].currentTrack.hasBeenSaved && 
       ![[SGSession instance].currentTrack.name isEqualToString:@"Auto-saved Track"])
        [alert textFieldAtIndex:0].text = [SGSession instance].currentTrack.name;
    
    alert.tag = 9000;
    [alert show];
}

- (IBAction)showMapButtonTouched:(id)sender 
{
    [UIView beginAnimations:@"hideSpeedHeadingView" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.5];
    if(dashboardHidden)
    {
        dashboardHidden = NO;
        speedHeadingView.alpha = 1.0;
        toolbar.alpha = 1.0;
        [showMapButton setImage:[UIImage imageNamed:@"mapincircle.png"] forState:UIControlStateNormal];
        showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - speedHeadingView.frame.size.height - 40 - 20, 35, 35);
        mapView.frame = CGRectMake(0, 0, 320, 460 - speedHeadingView.frame.size.height);
    }
    else
    {
        dashboardHidden = YES;
        speedHeadingView.alpha = 0.0;
        toolbar.alpha = 0.0;
        [showMapButton setImage:[UIImage imageNamed:@"dashboardincircle.png"] forState:UIControlStateNormal];
        showMapButton.frame = CGRectMake(320 - 35 - 5, 480 - 40 - 20, 35, 35);
        mapView.frame = CGRectMake(0, 0, 320, 460);
    }
    [UIView commitAnimations];
}

@end
