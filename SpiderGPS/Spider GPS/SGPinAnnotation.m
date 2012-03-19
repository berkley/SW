//
//  SGPinAnnotation.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/10/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "SGPinAnnotation.h"

@implementation SGPinAnnotation 
@synthesize coordinate, title, subtitle, location;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if(self)
    {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

#pragma mark - nscoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        title = [decoder decodeObjectForKey:PIN_TITLE_KEY];
        subtitle = [decoder decodeObjectForKey:PIN_SUBTITLE_KEY];
        location = [decoder decodeObjectForKey:PIN_LOCATION_KEY];
        coordinate = location.coordinate;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:title forKey:PIN_TITLE_KEY];
    [coder encodeObject:subtitle forKey:PIN_SUBTITLE_KEY];
    [coder encodeObject:location forKey:PIN_LOCATION_KEY];
}

@end
