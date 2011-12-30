//
//  SGSession.h
//  SimpleGPS
//
//  Created by Chad Berkley on 11/29/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SGTrack.h"
#import "SGDefaultsManager.h"
#import <MapKit/MapKit.h>

#define TRACKS_KEY @"Tracks"

@interface SGSession : NSObject
{
    UIInterfaceOrientation currentOrientation;
    SGTrack *currentTrack;
    SGDefaultsManager *defaultsManager;
    NSMutableDictionary *tracks;
    NSMutableArray *fields;
}

@property (nonatomic, retain) SGTrack *currentTrack;
@property (nonatomic, retain) SGDefaultsManager *defaultsManager;
@property (nonatomic, retain) NSMutableDictionary *tracks;
@property (nonatomic, assign) BOOL useMPH;
@property (nonatomic, assign) BOOL useTrueHeading;
@property (nonatomic, assign) BOOL screenAlwaysOn;
@property (nonatomic, retain) NSArray *fields;

- (BOOL)orientationIsPortrait;
+ (SGSession*)instance;
- (void)saveCurrentTrackWithName:(NSString*)name;
- (void)createNewTrack;
+ (void)zoomToFitLocations:(NSArray*)locations padding:(NSInteger)padding mapView:(MKMapView*)mapView;
+ (NSString*)getDocumentPathWithName:(NSString*)name;
- (void)setField:(NSInteger)field toOn:(BOOL)on;
+ (NSString*)formattedElapsedTime:(NSDate*)date1 date2:(NSDate*)date2;

@end
