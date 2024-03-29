//
//  Simply_DoneAppDelegate.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright Chad Berkley 2010. All rights reserved.
//

#import "Simply_DoneAppDelegate.h"
#import "RootViewController.h"
#import "DBUtil.h"
#import "Session.h"

@implementation Simply_DoneAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle



- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch 
    [DBUtil createEditableCopyOfDatabaseIfNeeded];
	//[DBTest runTests];
    
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	if([Session sharedInstance].useSingleListInterface)
	{
		if([Session sharedInstance].lists == nil)
		{
			[Session sharedInstance].lists = [[NSMutableArray alloc] init];
		}
				
		[DBUtil loadLists];
		
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:0];
		lvc = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
		lvc.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		[navigationController pushViewController:lvc animated:NO];
		lvc.title = list.name;
		NSLog(@"displayed list id %@", list.identifier);
		[Session sharedInstance].currentListId = list.identifier;
		[Session sharedInstance].itemList = list;
	}
	else 
	{
		rvc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
		[navigationController pushViewController:rvc animated:NO];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"didBecomeActive");
	[DBUtil loadLists];
	[self refreshRootViewController];
	
}

//open simply done by selecting a url or file
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	//[viewController handleURL:url];
	NSLog(@"Handling open url call for url %@", [url absoluteURL]);
	if([Session sharedInstance].lists == nil)
	{
		[Session sharedInstance].lists = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"opening url %@", [url absoluteURL]);
	//get a file handle
	NSData *dataToWrite = [NSData dataWithContentsOfURL:url];
	NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"import.txt"];
	NSLog(@"writing url to path %@", path);
	// Write the file
	[dataToWrite writeToFile:path atomically:YES];
	//import the parse into the DB
	[[DBUtil sharedInstance] importListFile:path];
	return YES;
}

- (void)refreshRootViewController
{
	//if(rvc != nil)
	{
		[rvc.tableView reloadData];
		[rvc reloadListViewController];
	}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@"!!!!!!!!!!!!MEMORY WARNING!!!!!!");
}

//- (void)applicationWillTerminate:(UIApplication *)application {
// Save data if appropriate
//}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[rvc release];
	[super dealloc];
}


@end

