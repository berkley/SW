//
//  SGSession.m
//  SimpleGPS
//
//  Created by Chad Berkley on 11/29/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGSession.h"

@implementation SGSession
@synthesize currentTrack, defaultsManager, tracks, useMPH, fields, screenAlwaysOn,
currentLocation;

static SGSession *instance = nil; 

#pragma mark - private methods

- (void)setFieldVals
{
    NSMutableArray *arr = (NSMutableArray*)[defaultsManager getObjectWithName:@"fields"];
    if(!arr)
        arr = [NSMutableArray arrayWithObjects:@"off", @"on", @"on", @"off", @"off", @"off", @"on", @"off", @"off", @"on", @"on", @"on", nil];
    self.fields = arr;
    NSLog(@"fields: %@", self.fields);
}

#pragma mark - init

+ (SGSession*)instance
{
    @synchronized(self)
    {
        if(instance == nil)
            instance = [[SGSession alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(locationUpdated:) 
                                                     name:NOTIFICATION_LOCATION_UPDATED 
                                                   object:nil];
        self.defaultsManager = [SGDefaultsManager instance];

        [self setFieldVals];
        self.tracks = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:[SGSession getDocumentPathWithName:TRACKS_KEY]]];
        if(tracks == nil)
            tracks = [[NSMutableDictionary alloc] init];
        [self createNewTrack];
        if(self.screenAlwaysOn)
            [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
    return self;
}

- (void)locationUpdated:(NSNotification*)notification
{
    self.currentLocation = [notification.userInfo objectForKey:@"newLocation"];
}

- (void)saveCurrentTrackWithName:(NSString*)name
{
    //todo: make sure name is unique
    SGTrack *t = [self.currentTrack copy];
    [self.tracks setObject:t forKey:name];
    [NSKeyedArchiver archiveRootObject:self.tracks toFile:[SGSession getDocumentPathWithName:TRACKS_KEY]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_ACTIVITY_INDICATOR object:nil];
}

- (void)createNewTrack
{
    self.currentTrack = [[SGTrack alloc] init];
}

+ (void)zoomToFitLocations:(NSArray*)locations padding:(NSInteger)padding mapView:(MKMapView*)mapView
{
    if([locations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(CLLocation *loc in locations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, loc.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, loc.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, loc.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, loc.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - 
    (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + 
    (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - 
                                     bottomRightCoord.latitude) * padding; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - 
                                      topLeftCoord.longitude) * padding; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

+ (NSString*)getDocumentPathWithName:(NSString*)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:name];
    return writableDBPath;
}

- (void)setField:(NSInteger)field toOn:(BOOL)on;
{
    NSString *onStr = @"off";
    if(on)
        onStr = @"on";
    [fields replaceObjectAtIndex:field withObject:onStr];
    [defaultsManager setObject:fields withName:@"fields"];
}

#pragma mark - custom getters/setters

- (BOOL)cardinalHeading
{
    NSString *ch = (NSString*)[defaultsManager getObjectWithName:@"cardinalHeading"];
    if(ch != nil && [ch isEqualToString:@"false"])
        return NO;
    else
        return YES;
}

- (void)setCardinalHeading:(BOOL)ch
{
    if(ch)
        [defaultsManager setObject:@"true" withName:@"cardinalHeading"];
    else
        [defaultsManager setObject:@"false" withName:@"cardinalHeading"];
}

- (void)setUseMPH:(BOOL)umph
{
    if(umph)
        [defaultsManager setObject:@"true" withName:@"useMPH"];
    else
        [defaultsManager setObject:@"false" withName:@"useMPH"];
}

- (BOOL)useMPH
{
    NSString *umph = (NSString*)[defaultsManager getObjectWithName:@"useMPH"];
    if(umph != nil && [umph isEqualToString:@"false"])
        return NO;
    else
        return YES;
}

- (void)setUseTrueHeading:(BOOL)uth
{
    if(uth)
        [defaultsManager setObject:@"true" withName:@"useTrueHeading"];
    else
        [defaultsManager setObject:@"false" withName:@"useTrueHeading"];
}

- (BOOL)useTrueHeading
{
    NSString *uth = (NSString*)[defaultsManager getObjectWithName:@"useTrueHeading"];
    if(uth != nil && [uth isEqualToString:@"false"])
        return NO;
    else
        return YES;
}

- (void)setScreenAlwaysOn:(BOOL)sao
{
    if(sao)
    {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [defaultsManager setObject:@"true" withName:@"screenAlwaysOn"];
    }
    else
    {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [defaultsManager setObject:@"false" withName:@"screenAlwaysOn"];
    }
}

- (BOOL)screenAlwaysOn
{
    NSString *sao = (NSString*)[defaultsManager getObjectWithName:@"screenAlwaysOn"];
    if(sao != nil && [sao isEqualToString:@"true"])
        return YES;
    else
        return NO;
}

+ (NSString*)formattedElapsedTime:(NSDate*)date1 date2:(NSDate*)date2
{
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSString *result = [NSString stringWithFormat:@"%02d:%02d:%02d", [conversionInfo hour], [conversionInfo minute], [conversionInfo second]];
    return result;
}
@end
