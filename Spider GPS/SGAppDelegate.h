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
 - show friends on the map in realtime
 - run slider control
 - 3D view
 - spruce up the look of SGTrackDataViewController.view (add small map, change fonts, etc)
 - auto save function
 - if track is saved before, auto-populate the save dialog with the same name
 - realtime track friends
 - friends track overlays
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
