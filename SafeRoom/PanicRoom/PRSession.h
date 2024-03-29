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
@property (nonatomic, assign) BOOL isInBackground;
@property (nonatomic, assign) BOOL distressCallIsActive;

+ (PRSession*)instance;
- (BOOL)addService:(PRService*)service;
- (void)removeService:(PRService*)service;
- (PRService*)serviceWithName:(NSString*)name;
- (void)startLocationServices;
- (void)startLowResLocationServices;
- (void)stopLowResLocationServices;
- (void)stopLocationServices;
+ (NSString*)createMessage:(NSString*)msg withLocation:(CLLocation*)currentLocation;
+ (NSInteger)generatedMessageLength;

@end
