//
//  SGAppDelegate.m
//  SimpleGPS
//
//  Created by Chad Berkley on 11/28/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGAppDelegate.h"

#import "SGViewController.h"

@implementation SGAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[SGViewController alloc] initWithNibName:@"SGViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[SGViewController alloc] initWithNibName:@"SGViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    locationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled] )
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        [self performSelector:@selector(startLocationServices) withObject:nil afterDelay:1];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"application entered background");
//    [locationManager stopUpdatingHeading];
//    [locationManager stopUpdatingLocation];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_LOCATION_SERVICES object:nil userInfo:nil];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"application will terminate");
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STOP_LOCATION_SERVICES object:nil userInfo:nil];
}

#pragma mark - CLLocationManager delegate

- (void)startLocationServices
{        
    NSLog(@"starting location services");
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:newLocation, @"newLocation", oldLocation, @"oldLocation", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_UPDATED object:nil userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:newHeading, @"newHeading", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HEADING_UPDATED object:nil userInfo:userInfo];
}
@end
