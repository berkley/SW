//
//  SGPolyline.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/16/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SGPolyline : MKPolyline
{
    BOOL isAscending;
}

@property (nonatomic, assign) BOOL isAscending;

@end
