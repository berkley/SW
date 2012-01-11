//
//  SGTrack.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATION_KEY @"locations"
#define DISTANCE_KEY @"distance"
#define AVG_SPEED_KEY @"avgSpeed"
#define TOP_SPEED_KEY @"topSpeed"
#define LOW_SPEED_KEY @"lowSpeed"
#define TOP_ALTITUDE_KEY @"topAltitude"
#define LOW_ALTITUDE_KEY @"lowAltitude"
#define TOTAL_TIME_KEY @"totalTime"
#define NAME_KEY @"name"
#define ANNOTATIONS_KEY @"annotations"

@interface SGTrack : NSObject <NSCoding>
{
    NSMutableArray *locations;
    NSMutableArray *annotations;
    NSNumber *distance;
    NSNumber *avgSpeed;
    NSNumber *topSpeed;
    NSNumber *lowSpeed;
    NSNumber *topAlitude;
    NSNumber *lowAltidude;
    NSString *name;
    NSNumber *totalTime;
}

//all raw values from CLLocationManager, convert to relevant units
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *avgSpeed;
@property (nonatomic, retain) NSNumber *topSpeed;
@property (nonatomic, retain) NSNumber *lowSpeed;
@property (nonatomic, retain) NSNumber *topAlitude;
@property (nonatomic, retain) NSNumber *lowAltidude;
@property (nonatomic, retain) NSMutableArray *locations; //array of CLLocation
@property (nonatomic, retain) NSNumber *totalTime; //treat as an NSTimeInterval (double)
@property (nonatomic, retain) NSMutableArray *annotations;

- (void)addDataWithLocation:(CLLocation*)location distance:(double)dist 
                  startTime:(NSDate*)date1 stopTime:(NSDate*)date2;
+ (double)calculateAvgSpeedForDistance:(NSInteger)distance fromDate:(NSDate*)date1 toDate:(NSDate*)date2;

@end
