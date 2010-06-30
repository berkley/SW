//
//  Simply_DoneAppDelegate.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright ucsb 2010. All rights reserved.
//

#import "Simply_DoneAppDelegate.h"
#import "RootViewController.h"
#import "DBUtil.h"

@implementation Simply_DoneAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch 
    [DBUtil createEditableCopyOfDatabaseIfNeeded];
	[DBUtil initializeDatabase];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

