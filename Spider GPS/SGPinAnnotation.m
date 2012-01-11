//
//  SGPinAnnotation.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/10/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGPinAnnotation.h"

@implementation SGPinAnnotation 
@synthesize coordinate, title, subtitle;

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

@end
