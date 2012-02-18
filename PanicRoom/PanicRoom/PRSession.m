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
        [defaults setObject:@"I'm using SafeRoom to send out alerts in case of emergency. This is a test. Please disregard this message." withName:@"testMessage"];
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

#pragma mark - location services

- (void)startLocationServices
{
    locationUpdateCounter = 0;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)stopLocationServices
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    locationUpdateCounter++;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_CHANGED 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newLocation, @"newLocation", oldLocation, @"oldLocation", nil]];
}

+ (NSString*)createStaticMapURLForLocation:(CLLocation*)location
{
    //markers=color:red%7Clabel:X%7C45.5,-122.5
    NSString *marker = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    NSString *url = [NSString stringWithFormat:@"%@%@", GOOGLE_STATIC_MAP_BASE_URL, marker];
    NSLog(@"url: %@", url);
    return url;
}

+ (NSString*)getShortenedURLForURL:(NSString*)url
{
    NSString *urlString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", 
                           [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *u = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:u];
    [request setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) 
    {
        NSLog(@"Error: %@", error);
    } 
    else 
    {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
        return receivedString;
    }  
    return nil;
}

@end
