//
//  SGTimeAnnotation.m
//  Spider GPS
//
//  Created by Chad Berkley on 2/8/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "SGTimeAnnotation.h"

@implementation SGTimeAnnotation
@synthesize coordinate, title, subtitle, location, time;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord time:(NSString*)t
{
    self = [super init];
    if(self)
    {
        coordinate = coord;
        time = t;
    }
    return self;
}

@end
