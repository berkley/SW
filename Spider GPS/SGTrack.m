//
//  SGTrack.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGTrack.h"

@implementation SGTrack
@synthesize name, distance, avgSpeed, lowSpeed, topSpeed, topAlitude, 
lowAltidude, locations, totalTime, annotations, horizontalAccuracy, verticalAccuracy;

- (id)copy
{
    SGTrack *t = [[SGTrack alloc] init];
    t.locations = [locations copy];
    t.distance = [distance copy];
    t.avgSpeed = [avgSpeed copy];
    t.topSpeed = [topSpeed copy];
    t.lowSpeed = [lowSpeed copy];
    t.topAlitude = [topAlitude copy];
    t.lowAltidude = [lowAltidude copy];
    t.totalTime = [totalTime copy];
    t.name = [name copy];
    t.annotations = [annotations copy];
    t.horizontalAccuracy = [horizontalAccuracy copy];
    t.verticalAccuracy = [verticalAccuracy copy];
    
    return t;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        locations = [decoder decodeObjectForKey:LOCATION_KEY];
        distance = [decoder decodeObjectForKey:DISTANCE_KEY];
        avgSpeed = [decoder decodeObjectForKey:AVG_SPEED_KEY];
        topSpeed = [decoder decodeObjectForKey:TOP_SPEED_KEY];
        lowSpeed = [decoder decodeObjectForKey:LOW_SPEED_KEY];
        topAlitude = [decoder decodeObjectForKey:TOP_ALTITUDE_KEY];
        lowAltidude = [decoder decodeObjectForKey:LOW_ALTITUDE_KEY];
        totalTime = [decoder decodeObjectForKey:TOTAL_TIME_KEY];
        name = [decoder decodeObjectForKey:NAME_KEY];
        annotations = [decoder decodeObjectForKey:ANNOTATIONS_KEY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:locations forKey:LOCATION_KEY];
    [coder encodeObject:distance forKey:DISTANCE_KEY];
    [coder encodeObject:avgSpeed forKey:AVG_SPEED_KEY];
    [coder encodeObject:topSpeed forKey:TOP_SPEED_KEY];
    [coder encodeObject:lowSpeed forKey:LOW_SPEED_KEY];
    [coder encodeObject:topAlitude forKey:TOP_ALTITUDE_KEY];
    [coder encodeObject:lowAltidude forKey:LOW_ALTITUDE_KEY];
    [coder encodeObject:totalTime forKey:TOTAL_TIME_KEY];
    [coder encodeObject:name forKey:NAME_KEY];
    [coder encodeObject:annotations forKey:ANNOTATIONS_KEY];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        locations = [[NSMutableArray alloc] init];
        annotations = [[NSMutableArray alloc] init];
        distance = [NSNumber numberWithDouble:0.0];
        avgSpeed = [NSNumber numberWithDouble:0.0];
        topSpeed = [NSNumber numberWithDouble:0.0];
        lowSpeed = [NSNumber numberWithDouble:99999.0];
        topAlitude = [NSNumber numberWithDouble:0.0];
        lowAltidude = [NSNumber numberWithDouble:99999.0];
        totalTime = [NSNumber numberWithDouble:0.0];
        name = nil;
    }
    return self;
}

- (void)addDataWithLocation:(CLLocation*)location 
                   distance:(double)dist 
                  startTime:(NSDate*)date1 
                   stopTime:(NSDate*)date2
{
    if(location.verticalAccuracy < 0)
        return; //invalid location
    
    double altitude = location.altitude;
    double speed = location.speed;
    if(speed < 0)
        speed = 0;
    
    [locations addObject:location];
    distance = [NSNumber numberWithDouble:dist];
    if(speed > [topSpeed doubleValue])
        topSpeed = [NSNumber numberWithDouble:speed];
    if(speed < [lowSpeed doubleValue])
        lowSpeed = [NSNumber numberWithDouble:speed];
    if(altitude > [topAlitude doubleValue])
        topAlitude = [NSNumber numberWithDouble:altitude];
    if(altitude < [lowAltidude doubleValue])
        lowAltidude = [NSNumber numberWithDouble:altitude];
    avgSpeed = [NSNumber numberWithDouble:[SGTrack calculateAvgSpeedForDistance:dist fromDate:date1 toDate:date2]]; 
    
    
//    NSLog(@"topSpeed: %.1f lowSpeed: %.1f topAlt: %.1f lowAlt: %.1f avgSpeed: %.1f", 
//          [topSpeed doubleValue], [lowSpeed doubleValue], [topAlitude doubleValue],
//          [lowAltidude doubleValue], [avgSpeed doubleValue]);
}
                
//returns avg speed between the two dates for the given distance in meters/second.
//distance must be in meters!
+ (double)calculateAvgSpeedForDistance:(NSInteger)distance fromDate:(NSDate*)date1 toDate:(NSDate*)date2
{
    unsigned int unitFlags = NSSecondCalendarUnit;
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSInteger seconds = [conversionInfo second];
    return distance / seconds;
}

@end
