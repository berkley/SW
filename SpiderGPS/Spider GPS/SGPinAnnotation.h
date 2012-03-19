//
//  SGPinAnnotation.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/10/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define PIN_TITLE_KEY @"SGPinAnnTitle"
#define PIN_SUBTITLE_KEY @"SGPinAnnSubTitle"
#define PIN_LOCATION_KEY @"SGPinAnnLocation"

@interface SGPinAnnotation : NSObject <MKAnnotation, NSCoding>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    CLLocation *location;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) CLLocation *location;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
