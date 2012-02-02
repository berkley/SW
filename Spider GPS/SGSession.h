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
#import "ActivityIndicatorModalViewController.h"
#import <MapKit/MapKit.h>

#define OLD_TRACKS_KEY @"Tracks"
#define TRACKS_KEY @"Track"

@interface SGSession : NSObject
{
    UIInterfaceOrientation currentOrientation;
    SGTrack *currentTrack;
    SGDefaultsManager *defaultsManager;
    NSMutableDictionary *tracks;
    NSMutableArray *fields;
    CLLocation *currentLocation;
    ActivityIndicatorModalViewController *activityIndicatorViewController;
    NSString *activityIndicatorIsVisible;
    NSTimer *saveTimer;
}

@property (nonatomic, retain) SGTrack *currentTrack;
@property (nonatomic, retain) SGDefaultsManager *defaultsManager;
@property (nonatomic, retain) NSMutableDictionary *tracks;
@property (nonatomic, assign) BOOL useMPH;
@property (nonatomic, assign) BOOL useTrueHeading;
@property (nonatomic, assign) BOOL screenAlwaysOn;
@property (nonatomic, assign) BOOL cardinalHeading;
@property (nonatomic, retain) NSArray *fields;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *activityIndicatorIsVisible;
@property (nonatomic, retain) ActivityIndicatorModalViewController *activityIndicatorViewController;

+ (SGSession*)instance;
- (void)saveCurrentTrackWithName:(NSString*)name;
- (void)createNewTrack;
+ (void)zoomToFitLocations:(NSArray*)locations padding:(NSInteger)padding mapView:(MKMapView*)mapView;
+ (NSString*)getDocumentPathWithName:(NSString*)name;
- (void)setField:(NSInteger)field toOn:(BOOL)on;
+ (NSString*)formattedElapsedTime:(NSDate*)date1 date2:(NSDate*)date2;
- (void)showActivityIndicator:(UIViewController *)container 
                  description:(NSString *)description 
                 withProgress:(BOOL)prog;
- (void)hideActivityIndicator;
- (void)saveTracks;
- (SGTrack*)getTrackWithName:(NSString*)name;
+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString *)format;

@end
