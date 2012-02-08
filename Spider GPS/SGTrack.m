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
lowAltidude, locations, totalTime, annotations, horizontalAccuracy, 
verticalAccuracy, totalAscent, totalDescent, hasBeenSaved, date;

#pragma mark - private methods

//queue the object and if an object gets bumped off the end, return it.  return nil
//if the queue was not full
- (NSObject*)queueObject:(NSObject*)obj inArray:(NSMutableArray*__strong*)array withCapacity:(NSInteger)cap
{
    NSObject *endObj = nil;
    if([*array count] < cap)
    {
        [*array insertObject:obj atIndex:0];
        return nil;
    }
    
    endObj = [*array objectAtIndex:cap - 1];
    
    for(int i=cap - 1; i>0; i--)
        [*array replaceObjectAtIndex:i withObject:[*array objectAtIndex:i - 1]];
    
    [*array replaceObjectAtIndex:0 withObject:obj];
    
    if(endObj)
        return endObj;
    
    return nil;
}

//if all of the items in the arr are > val, return NSOrderedAscending
//if all of the items in the arr are < val, return NSOrderedDescending
//if it's a mixed bag, return NSOrderedSame
- (NSInteger)analyzeArray:(NSArray*__strong*)arr comparedToValue:(NSInteger)val
{
    BOOL greater = NO;
    BOOL less = NO;
    for(CLLocation *loc in *arr)
    {
        if(loc.altitude > val)
            greater = YES;
        if(loc.altitude < val)
            less = YES;
    }
    
    if(greater && !less)
        return NSOrderedAscending;
    if(!greater && less)
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

//queue n points, and when the queue is full, return the average
- (NSNumber*)queueObjectInVertAccuracyArray:(NSObject*)obj
{
    NSNumber *endObj = nil;
    if([vertAccuracyArray count] < NUM_POINTS_FOR_VERT_ACCURACY)
    {
        [vertAccuracyArray insertObject:obj atIndex:0];
        return nil;
    }
    
    endObj = [vertAccuracyArray objectAtIndex:NUM_POINTS_FOR_VERT_ACCURACY - 1];
    
    for(int i=NUM_POINTS_FOR_VERT_ACCURACY - 1; i>0; i--)
        [vertAccuracyArray replaceObjectAtIndex:i withObject:[vertAccuracyArray objectAtIndex:i - 1]];
    
    [vertAccuracyArray replaceObjectAtIndex:0 withObject:obj];
    
    if(endObj)
    {
        CGFloat total = 0.0;
        for(NSNumber *n in vertAccuracyArray)
        {
            total = total + [n floatValue];
        }
        CGFloat avg = total / NUM_POINTS_FOR_VERT_ACCURACY;
        return [NSNumber numberWithFloat:avg];
    }
    
    return nil;
}

- (BOOL)processVertAccuracy:(CGFloat)accuracy 
{
    NSNumber *num = [[NSNumber alloc] initWithFloat:accuracy];
    NSNumber *retVal = [self queueObjectInVertAccuracyArray:num];
    NSLog(@"accuracy: %f avg: %@", accuracy, retVal);
    if(!retVal)
        return NO;
    
    if(accuracy > [retVal floatValue] + VERT_ACCURACY_THRESHOLD)
        return NO;
    else
        return YES;
}


#pragma mark - init

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
    t.totalDescent = [totalDescent copy];
    t.totalAscent = [totalAscent copy];
    t.date = [date copy];
    
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
        totalAscent = [decoder decodeObjectForKey:ASCENT_KEY];
        totalDescent = [decoder decodeObjectForKey:DESCENT_KEY];
        date = [decoder decodeObjectForKey:DATE_KEY];
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
    [coder encodeObject:totalAscent forKey:ASCENT_KEY];
    [coder encodeObject:totalDescent forKey:DESCENT_KEY];
    [coder encodeObject:date forKey:DATE_KEY];
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
        totalAscent = [NSNumber numberWithDouble:0.0];
        totalDescent = [NSNumber numberWithDouble:0.0];
        previousAltitude = -1.0;
        vertAccuracyArray = [NSMutableArray arrayWithCapacity:NUM_POINTS_FOR_VERT_ACCURACY];
        cachedAltPoints = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS_DETERMINER];
        date = [NSDate date];
        name = nil;
        totalAsc = 0.0;
        totalDes = 0.0;
    }
    return self;
}

- (void)addDataWithLocation:(CLLocation*)location 
                   distance:(double)dist 
                  startTime:(NSDate*)date1 
                   stopTime:(NSDate*)date2
{
    if(location.horizontalAccuracy < 0)
        return; //invalid location
    
    double altitude = location.altitude;
    double speed = location.speed;
    if(speed < 0)
        speed = 0;
    
    [locations addObject:location];
    
    avgVerticalAccuracyTotal += location.verticalAccuracy;
    if([locations count] > 0)
        avgVerticalAccuracy = avgVerticalAccuracyTotal / (CGFloat)[locations count];
    
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
    
    if(previousAltitude == -1)
        previousAltitude = altitude;
    
    //simple method
//    NSLog(@"currentVertAcc: %f",location.verticalAccuracy);
    
//    if([self processVertAccuracy:location.verticalAccuracy])
//    {
//        if(altitude < previousAltitude)
//        {
//            double d = [totalDescent doubleValue];
//            d += previousAltitude - altitude;
//            totalDescent = [NSNumber numberWithDouble:d];
//        }
//        else
//        {
//            double d = [totalAscent doubleValue];
//            d += altitude - previousAltitude;
//            totalAscent = [NSNumber numberWithDouble:d];
//        }
//        previousAltitude = altitude;
//    }
    
//    NSLog(@"topSpeed: %.1f lowSpeed: %.1f topAlt: %.1f lowAlt: %.1f avgSpeed: %.1f", 
//          [topSpeed doubleValue], [lowSpeed doubleValue], [topAlitude doubleValue],
//          [lowAltidude doubleValue], [avgSpeed doubleValue]);
    
    //more complicated method
    CLLocation *lastLoc = (CLLocation*)[self queueObject:location 
                                                 inArray:&cachedAltPoints 
                                            withCapacity:NUMBER_OF_POINTS_DETERMINER];
    
    if(lastLoc/* && [self processVertAccuracy:location.verticalAccuracy]*/)
    {
        NSInteger analize = [self analyzeArray:&cachedAltPoints comparedToValue:lastLoc.altitude];
        if(analize == NSOrderedAscending)
        { //we think we're ascending
            trackIsAscending = YES;
        }
        else if(analize == NSOrderedDescending)
        { //we think we're descending
            trackIsAscending = NO;
        }
        else
        {
            //leave isAscending alone
        }
        
        if(previousAltitude == -1)
            previousAltitude = lastLoc.altitude;
        
//        NSLog(@"lastLoc.alt: %f prevAlt: %f", lastLoc.altitude, previousAltitude);
        
        if(trackIsAscending)
        {
            totalAsc += lastLoc.altitude - previousAltitude;
            if(totalAsc < 1)
                totalAsc *= -1;
        }
        else
        {
            totalDes += previousAltitude - lastLoc.altitude;
            if(totalDes < 1)
                totalDes *= -1;
        }
        
        previousAltitude = lastLoc.altitude;
        
        totalAscent = [NSNumber numberWithDouble:totalAsc];
        totalDescent = [NSNumber numberWithDouble:totalDes];        
    }
}

//returns a dictionary of arrays of CLLocations
//the dict keys are in chronological order where ascent0 is the first
//ascent and descent0 is the first descent and ascentN/descentN are the last
- (NSDictionary*)divideTrackIntoAscentAndDescent
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *cachedPoints = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS_DETERMINER];
    BOOL prevIsAscending = NO;
    BOOL isAscending = NO;
    int ascendDescendCount = 0;
    NSString *ascendKey = @"ascend-0";
    NSString *descendKey = @"descend-0";
    double totalA = 0.0;
    double totalD = 0.0;
    previousAltitude = -1;
    for(int i=0; i<[locations count]; i++)
    {
        CLLocation *lastLoc = (CLLocation*)[self queueObject:[locations objectAtIndex:i] 
                                        inArray:&cachedPoints 
                                   withCapacity:NUMBER_OF_POINTS_DETERMINER];
        if(lastLoc)
        {
            NSInteger analize = [self analyzeArray:&cachedPoints comparedToValue:lastLoc.altitude];
            if(analize == NSOrderedAscending)
            { //we think we're ascending
                isAscending = YES;
            }
            else if(analize == NSOrderedDescending)
            { //we think we're descending
                isAscending = NO;
            }

            if(prevIsAscending && !isAscending)
            { //changed from ascending to descending
                ascendDescendCount++;
                descendKey = [NSString stringWithFormat:@"descend-%i", ascendDescendCount];
            }
            else if(!prevIsAscending && isAscending)
            { //changed from descending to ascending
                ascendDescendCount++;
                ascendKey = [NSString stringWithFormat:@"ascend-%i", ascendDescendCount];
            }
            
            if(previousAltitude == -1)
                previousAltitude = lastLoc.altitude;
            
            if(isAscending)
            {
                totalA += lastLoc.altitude - previousAltitude;
                if(totalA < 1)
                    totalA *= -1;
                NSMutableArray *arr = [dict objectForKey:ascendKey];
                if(!arr)
                    arr = [[NSMutableArray alloc] init];
                [arr addObject:lastLoc];
                [dict setObject:arr forKey:ascendKey];
            }
            else
            {
                totalD += previousAltitude - lastLoc.altitude;
                if(totalD < 1)
                    totalD *= -1;
                
                NSMutableArray *arr = [dict objectForKey:descendKey];
                if(!arr)
                    arr = [[NSMutableArray alloc] init];
                [arr addObject:lastLoc];
                [dict setObject:arr forKey:descendKey];
            }
            previousAltitude = lastLoc.altitude;
            
            totalAscent = [NSNumber numberWithDouble:totalA];
            totalDescent = [NSNumber numberWithDouble:totalD];
            
            prevIsAscending = isAscending;
        }
    }
    return dict;
}

- (MKMapPoint*)singlePolyline
{
    MKMapPoint* tempPointArr = malloc(sizeof(CLLocationCoordinate2D) * [self.locations count]);
    int pointCount = 0;

    for(CLLocation *loc in self.locations)
    {
        MKMapPoint newPoint = MKMapPointForCoordinate(loc.coordinate);
        tempPointArr[pointCount] = newPoint;
        pointCount++;    
    }
    return tempPointArr;
}

- (NSArray*)timeBasedPolylines
{
    NSMutableArray *polylineArray = [[NSMutableArray alloc] init];
    NSInteger prevmin = -1;
    MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * 90);
    int linecount = 0;
    int nummappoints = 0;
    CLLocationCoordinate2D centerPoint;
    unsigned int unitFlags = NSMinuteCalendarUnit;
    NSCalendar *cal = [NSCalendar currentCalendar];
//    @autoreleasepool 
//    {
        for(CLLocation *loc in self.locations)
        {
            NSDateComponents *conversionInfo = [cal components:unitFlags fromDate:loc.timestamp];
//            NSInteger min = [CommonUtil getMinuteFromDate:loc.timestamp];
            NSInteger min = [conversionInfo minute];

            if(prevmin == -1)
            { //bootstrap
                prevmin = min;
                centerPoint = loc.coordinate;
                continue;
            }
            
            MKMapPoint point = MKMapPointForCoordinate(loc.coordinate);
            if(min != prevmin)
            { //make a new polyline
                BOOL isAscending = NO;
                if(linecount % 2 == 0)
                    isAscending = YES;
                SGPolyline *polyline = [[SGPolyline alloc] initWithPoints:mapPoints 
                                                                    count:nummappoints 
                                                              isAscending:isAscending 
                                                          withCenterCoord:centerPoint];
                centerPoint = loc.coordinate;
                [polylineArray addObject:polyline];
                linecount++;
                nummappoints = 0;
            }
            
            mapPoints[nummappoints] = point;
            nummappoints++;
            prevmin = min;
        }
        
        free(mapPoints);
//    }
    
    return polylineArray;
}

- (NSArray*)arrayOfPolylines
{
    NSDictionary *dict = [self divideTrackIntoAscentAndDescent];
    NSArray *keys = [[dict allKeys] sortedArrayUsingComparator:^(id a, id b)
                     {
                         NSString *stra = (NSString*)a;
                         NSString *strb = (NSString*)b;
                         NSString *numa = [stra substringFromIndex:[stra rangeOfString:@"-"].location + 1];
                         NSString *numb = [strb substringFromIndex:[strb rangeOfString:@"-"].location + 1];
                         
                         if([numa intValue] > [numb intValue])
                             return NSOrderedDescending;
                         else if([numa intValue] < [numb intValue])
                             return NSOrderedAscending;
                         return NSOrderedSame;
                     }];
    
    NSMutableArray *polylineArray = [NSMutableArray array];
    for(NSString *key in keys)
    {
        NSString *ascdesc = [key substringToIndex:[key rangeOfString:@"-"].location];
        BOOL isAscending = NO;
        if([ascdesc isEqualToString:@"ascend"])
        {
            isAscending = YES;
        }
        
        NSArray *arr = [dict objectForKey:key];
        MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * [arr count]);
        //        NSLog(@"new point with name: %@", key);
        CLLocation *centerLoc = [arr objectAtIndex:0];
        for(int i=0; i<[arr count]; i++)
        {
            CLLocation *loc = [arr objectAtIndex:i];
            MKMapPoint point = MKMapPointForCoordinate(loc.coordinate);
            mapPoints[i] = point;
        }
        SGPolyline *polyline = [[SGPolyline alloc] initWithPoints:mapPoints count:[arr count] 
                                                      isAscending:isAscending 
                                                  withCenterCoord:centerLoc.coordinate];
        CLLocation *firstLoc = [arr objectAtIndex:0];
        CLLocation *lastLoc = [arr objectAtIndex:[arr count] - 1];
        polyline.firstAltitude = firstLoc.altitude;
        polyline.lastAltitude = lastLoc.altitude;
        [polylineArray addObject:polyline];
        free(mapPoints);
    }
    return polylineArray;
}

- (void)calculateAscentAndDescent
{
    [self divideTrackIntoAscentAndDescent];
}
                
//returns avg speed between the two dates for the given distance in meters/second.
//distance must be in meters!
+ (double)calculateAvgSpeedForDistance:(NSInteger)distance fromDate:(NSDate*)date1 toDate:(NSDate*)date2
{
    unsigned int unitFlags = NSMinuteCalendarUnit;
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSInteger seconds = [conversionInfo second];
    return distance / seconds;
}

- (NSArray*)timeAnnotationsWithInterval:(NSInteger)interval
{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    NSInteger prevmin = -1;
    MKMapPoint *mapPoints = malloc(sizeof(MKMapPoint) * 90);
    int linecount = 0;
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSInteger alreadyDone = -1;
    for(CLLocation *loc in self.locations)
    {
        NSDateComponents *conversionInfo = [cal components:unitFlags fromDate:loc.timestamp];
        NSInteger min = [conversionInfo minute];
        NSInteger hr = [conversionInfo hour];
        min = min + (hr * 60);
        
        if(prevmin == -1)
        { //bootstrap
            prevmin = min - 1;
//            continue;
        }
        
        if(min > prevmin && min != alreadyDone)
        { //make a new polyline
            alreadyDone = min;
            if(linecount % interval == 0)
            {
                NSString *timeString;
                if(linecount > 59)
                {
                    NSInteger hours = linecount / 60;
                    NSInteger mins = linecount % 60;
                    timeString = [NSString stringWithFormat:@"%02d:%02d:00", hours, mins];
                }
                else
                    timeString = [NSString stringWithFormat:@"%02d:00", linecount];
                SGTimeAnnotation *ann = [[SGTimeAnnotation alloc] initWithCoordinate:loc.coordinate time:timeString];
                [annotationArray addObject:ann];
            }
            
            linecount++;
        }
        
        prevmin = min;
    }
    
    free(mapPoints);
    
    return annotationArray;
}

@end
