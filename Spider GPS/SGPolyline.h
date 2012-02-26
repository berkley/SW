//
//  SGPolyline.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/16/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SGPolyline : MKPolyline <MKOverlay>
{
    BOOL isAscending;
    MKMapPoint* points;
    NSUInteger pointCount;
    CLLocationCoordinate2D coordinate;
    MKMapRect boundingMapRect;
    double firstAltitude;
    double lastAltitude;
}

@property (nonatomic, assign) BOOL isAscending;
@property (nonatomic, readonly) MKMapPoint *points;
@property (nonatomic, readonly) NSUInteger pointCount;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) double firstAltitude;
@property (nonatomic, assign) double lastAltitude;

//- (id)initWithPoints:(MKMapPoint*)pts count:(NSInteger)ct isAscending:(BOOL)isAsc;
- (id)initWithPoints:(MKMapPoint*)pts count:(NSInteger)ct isAscending:(BOOL)isAsc withCenterCoord:(CLLocationCoordinate2D)center;
- (MKPolyline*)polyline;
- (BOOL)intersectsMapRect:(MKMapRect)mapRect;

@end
