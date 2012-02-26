//
//  Constants.h
//  SimpleGPS
//
//  Created by Chad Berkley on 11/29/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_ORIENTATION_CHANGED @"OrientationChanged"
#define NOTIFICATION_STOP_LOCATION_SERVICES @"StopLocationsServices"
#define NOTIFICATION_LOCATION_UPDATED @"LocationUpdated"
#define NOTIFICATION_HEADING_UPDATED @"HeadingUpdated"
#define NOTIFICATION_START_ACTIVITY_INDICATOR @"StartActIndic"
#define NOTIFICATION_STOP_ACTIVITY_INDICATOR @"StopActIndic"
#define NOTIFICATION_DEVICE_ORIENTATION_DID_CHANGE @"UIDeviceOrientationDidChangeNotification"
#define NOTIFICATION_LOCATIONS_COLLECTION_PAUSED @"LocationCollectionPaused"
#define NOTIFICATION_LOCATIONS_COLLECTION_UNPAUSED @"LocationCollectionUnpaused"
#define NOTIFICATION_ASCENT_DESCENT_CHANGED @"AscentDescentChanged"
#define NOTIFICATION_TIME_LABELS_CHANGED @"TimeLabelChanged"
#define NOTIFICATION_DETAILS_MAP_TYPE_CHANGED @"DetailsMapTypeChanged"

#define METERS_TO_MILES 0.000621371192
#define METERS_TO_MPH 2.23693629
#define METERS_TO_FT 3.2808399
#define METERS_TO_KPH 3.6
#define METERS_TO_KM 0.001

//accuracy-based line smoothing
#define NUM_POINTS_FOR_ACCURACY 10 //required number of points averaged before accuracy checking happens
#define ACCURACY_THRESHOLD 20 //+/- in meters
#define ADD_POINT_COUNT_THRESHOLD 30 //number of times we don't add a point before the accuracy check is invalidated

#define NUM_POINTS_FOR_VERT_ACCURACY 20 //required number of points averaged before accuracy checking happens
#define VERT_ACCURACY_THRESHOLD 3 // 3 meters

//ascent/descent detection
#define NUMBER_OF_POINTS_DETERMINER 100

#define DATE_KEY_FORMAT_STRING @"yyyy_MM_dd_HH_mm_ZZZZ"
#define DATE_DISPLAY_FORMAT @"MMM dd, yyyy HH:mm"
#define DATE_ONLY_DISPLAY_FORMAT @"MMM dd, yyyy"
#define TIME_ONLY_DISPLAY_FORMAT @"HH:mm"

#define STARTUP_LOCATION_COUNT_MIN 5
#define KEY_SEPARATOR_STRING @"::"

#define AUTO_SAVE_INTERVAL 10
#define AUTO_SAVE_TRACK_NAME @"Auto-saved Track"
