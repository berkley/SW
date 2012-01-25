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
 1.0
 - add alt gain/loss
 - run slider control
 - spruce up the look of SGTrackDataViewController.view (add small map, change fonts, etc)
 - auto save function
 - if track is saved before, auto-populate the save dialog with the same name
 
 1.1
 - 3D view
 - show friends on the map in realtime
 - realtime track friends
 - friends track overlays
 
 1.2
 - uploat tracks to icloud/facebook
 - export files
*/

@class SGViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGViewController *viewController;

@end
