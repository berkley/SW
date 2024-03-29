//
//  PRSession.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRSession.h"

static PRSession *instance;

@implementation PRSession
@synthesize services, locationManager, locationUpdateCounter;
@synthesize isInBackground = _isInBackground;
@synthesize distressCallIsActive = _distressCallIsActive;

+ (PRSession*)instance
{
    if(!instance)
    {
        instance = [[PRSession alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        defaults = [DefaultsManager instance];
        NSString *filename = [CommonUtil getDataPathForFileWithName:@"services"];
        self.services = [NSMutableArray arrayWithArray:
                       [NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
        if(self.services == nil)
            self.services = [[NSMutableArray alloc] init];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

#pragma mark - setters/getters

- (NSString*)testMessage
{
    if(![defaults getObjectWithName:@"testMessage"])
        [defaults setObject:@"I'm testing SafeRoom to send out alerts in case of emergency. Please disregard this message." withName:@"testMessage"];
    return (NSString*)[defaults getObjectWithName:@"testMessage"];
}

- (void)setTestMessage:(NSString *)testMessage
{
    [defaults setObject:testMessage withName:@"testMessage"];
}

- (NSString*)alertMessage
{
    if(![defaults getObjectWithName:@"alertMessage"])
        [defaults setObject:@"I need help! Please find me." withName:@"alertMessage"];
    return (NSString*)[defaults getObjectWithName:@"alertMessage"];
}

- (void)setAlertMessage:(NSString *)alertMessage
{
    [defaults setObject:alertMessage withName:@"alertMessage"];
}

- (BOOL)testMode
{
    NSString *str = (NSString*)[defaults getObjectWithName:@"testMode"];
    return [str isEqualToString:@"YES"];
}

- (void)setTestMode:(BOOL)testMode
{
    if(testMode)
        [defaults setObject:@"YES" withName:@"testMode"];
    else
        [defaults setObject:@"NO" withName:@"testMode"];
}

- (NSInteger)messageInterval
{
    NSNumber *num = (NSNumber*)[defaults getObjectWithName:@"messageInterval"];
    if(!num)
        return PUBLISHING_INTERVAL;
    return [num intValue];
}

- (void)setMessageInterval:(NSInteger)messageInterval
{
    NSNumber *num = [NSNumber numberWithInt:messageInterval];
    [defaults setObject:num  withName:@"messageInterval"];
}

#pragma mark - service methods

//return NO if the name already exists
- (BOOL)addService:(PRService*)service
{
    for(PRService *s in self.services)
    {
        if([[CommonUtil trimString:s.name] isEqualToString:[CommonUtil trimString:service.name]])
        {
            return NO;
        }
    }
    [services addObject:service];
    [NSKeyedArchiver archiveRootObject:self.services toFile:[CommonUtil getDataPathForFileWithName:@"services"]];
    return YES;
}

- (void)removeService:(PRService*)service
{
    [services removeObject:service];
    [NSKeyedArchiver archiveRootObject:self.services toFile:[CommonUtil getDataPathForFileWithName:@"services"]];
}

- (PRService*)serviceWithName:(NSString*)name
{
    for(PRService *service in services)
    {
        if([service.name isEqualToString:name])
            return service;
    }
    return nil;
}

+ (NSString*)createMessage:(NSString*)msg withLocation:(CLLocation*)currentLocation
{
    NSString *mapURL = [CommonUtil getShortenedURLForURL:[CommonUtil createStaticMapURLForLocation:currentLocation]];
    NSString *baseString = [NSString stringWithFormat:@"My location is: lat: %0.6f lon: %0.6f", 
                            currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    //NOTE: if either of the above strings change length, make sure to update generatedMessageLength below!!!
    NSLog(@"base string: %@ length: %i", baseString, [baseString length]);
    NSLog(@"map url %@ length %i", mapURL, [mapURL length]);
    
    msg = [NSString stringWithFormat:@"%@-%@ %@", msg, baseString, mapURL];
    return msg;
}

+ (NSInteger)generatedMessageLength
{
    //the sum of the length of mapURL and baseString above.
    return 47 + 26;
}

#pragma mark - location services

- (void)startLowResLocationServices
{
    locationUpdateCounter = 0;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = LOW_RES_DISTANCE_FILTER;
    [locationManager startUpdatingLocation];
}

- (void)startLocationServices
{
    locationUpdateCounter = 0;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

- (void)stopLowResLocationServices
{
    [locationManager stopMonitoringSignificantLocationChanges];
}

- (void)stopLocationServices
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location did update: %@", newLocation);
    locationUpdateCounter++;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_CHANGED 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newLocation, @"newLocation", oldLocation, @"oldLocation", nil]];
}

@end
