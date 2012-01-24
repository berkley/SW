//
//  SGPolyline.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/16/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGPolyline.h"

@implementation SGPolyline
@synthesize isAscending, points, pointCount, firstAltitude, lastAltitude;

- (id)initWithPoints:(MKMapPoint*)pts count:(NSInteger)ct isAscending:(BOOL)isAsc withCenterCoord:(CLLocationCoordinate2D)center
{
    self = [super init];
    if(self)
    {
        points = malloc(sizeof(MKMapPoint) * ct);
        double smallestx = 999999999999.0;
        double smallesty = 999999999999.0;
        double largestx = 0;
        double largesty = 0;
        for(int i=0; i<ct; i++)
        {
            points[i] = pts[i];
            if(points[i].x < smallestx)
                smallestx = points[i].x;
            if(points[i].y < smallesty)
                smallesty = points[i].y;
            if(points[i].x > largestx)
                largestx = points[i].x;
            if(points[i].y > largesty)
                largesty = points[i].y;
        }
        pointCount = ct;
        isAscending = isAsc;
        coordinate = center;
        boundingMapRect = MKMapRectMake(smallestx, smallesty, largestx - smallestx, largesty - smallesty);
    }
    return self;
}

- (MKMapPoint*)points
{
    return points;
}

- (NSUInteger)pointCount
{
    return pointCount;
}

- (CLLocationCoordinate2D)coordinate
{
    return coordinate;
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}

- (MKPolyline*)polyline
{
//    for(int i=0; i<pointCount; i++)
//    {
//        NSLog(@"point: %f %f %i", ((MKMapPoint)ps[i]).x, ((MKMapPoint)ps[i]).y, c);
//    }
    return [MKPolyline polylineWithPoints:points count:pointCount];
}

- (BOOL)intersectsMapRect:(MKMapRect)mapRect
{
    return MKMapRectIntersectsRect(boundingMapRect, mapRect);
}

@end
