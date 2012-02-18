//
//  PRSession.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultsManager.h"
#import "PRService.h"
#import "CommonUtil.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>

@interface PRSession : NSObject <CLLocationManagerDelegate>
{
    DefaultsManager *defaults;
    NSMutableArray *services;
    CLLocationManager *locationManager;
    NSInteger locationUpdateCounter;
}

@property (nonatomic, retain) NSMutableArray *services;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, retain) NSString *testMessage;
@property (nonatomic, retain) NSString *alertMessage;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) NSInteger messageInterval;
@property (nonatomic, assign) NSInteger locationUpdateCounter;

+ (PRSession*)instance;
- (BOOL)addService:(PRService*)service;
- (void)removeService:(PRService*)service;
- (PRService*)serviceWithName:(NSString*)name;
- (void)startLocationServices;
- (void)stopLocationServices;
+ (NSString*)createStaticMapURLForLocation:(CLLocation*)location;
+ (NSString*)getShortenedURLForURL:(NSString*)url;

@end
