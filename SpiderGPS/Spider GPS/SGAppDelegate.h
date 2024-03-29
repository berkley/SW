//
//  SGAppDelegate.h
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/* TODO:
 1.0
 x let user choose map type
 x pause button
 x allow user to turn auto-save on/off
 x spruce up the look of SGTrackDataViewController.view (add small map, change fonts, etc)
 x time view (change color of track every minute or something like that)
 x sort tracks by date
 x add alt gain/loss
 x auto save function
 x if track is saved before, auto-populate the save dialog with the same name
 x warn of overwrite
 x add status indicators for ops that take a while
 x add "are you sure you want to reset your track" popover
 
 1.1
 - run slider control
 - 3D view
 - alt gain/loss plot (profile view)
 - show friends on the map in realtime
 - realtime track friends
 - friends track overlays
 - moving/stopping time
 
 1.2
 - upload tracks to icloud/facebook
 - overlay multiple tracks on one map
 - export files
 
 1.3 
 - add iPad support
 - possibly add web support
 
 Unscheduled
 - smooth the line when the user is in one place so the line doesn't go crazy
 - add user option for setting the radius that the user must move before a new point is collected
 - playback view
 - add photos or other media to track
 - add battery low notification
 
*/

@class SGViewController;

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SGViewController *viewController;

@end
