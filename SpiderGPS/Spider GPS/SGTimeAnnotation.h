//
//  SGTimeAnnotation.h
//  Spider GPS
//
//  Created by Chad Berkley on 2/8/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SGTimeAnnotation : NSObject
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    CLLocation *location;
    NSString *time;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, retain)  NSString *time;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord time:(NSString*)t;

@end
