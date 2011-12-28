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
 - add tab bar (map, tracks, settings)
 - add direction following button on map
 - add "go to current location" button on map
 - add "reset track" button on map
 - add view controller for settings
   - screen never dims
   - units
   - compass (T/M)
 
 - buttons
   - tracks
   - settings
   - current loc
   - direction following (could be same button as current loc)
   - reset track
   - save track (could be in the tracks MVC)
 */

@class SGViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGViewController *viewController;

@end
