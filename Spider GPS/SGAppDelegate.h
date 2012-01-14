//
//  SGAppDelegate.h
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/* TODO:
 - add alt gain/loss
 - drop a pin button
 - add lines of different color for ascent/descent
 - show friends on the map in realtime
 - smooth lines from large gps errors
*/

@class SGViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGViewController *viewController;

@end
