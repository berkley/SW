//
//  SGTest.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/29/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "SGTest.h"

@implementation SGTest

+ (void)testAltitudeWithTrackName:(NSString*)name 
{
    SGTrack *track = [[SGSession instance] getTrackWithName:name];
    if(!track)
    {
        NSLog(@"test track is nil");
        return;
    }
    SGTrack *newTrack = [[SGTrack alloc] init];
    NSDate *date = [NSDate date];
    for(CLLocation *loc in track.locations)
    {
        [newTrack addDataWithLocation:loc distance:0.0 startTime:date stopTime:[NSDate date]];
        NSLog(@"totalAscent: %f ft totalDescent: %f ft", 
              [newTrack.totalAscent floatValue] * METERS_TO_FT, 
              [newTrack.totalDescent floatValue] * METERS_TO_FT);
    }
    
}

@end
