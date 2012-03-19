//
//  Session.m
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 Chad Berkley. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize currentListId, itemList, lists, isAddingNewList, path, listName, useSingleListInterface;
@synthesize database;

static NSString *useSingleListInterfaceKey = @"simplyDone.useSingleList";
static Session *sharedInstance = nil;


+ (Session*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[Session alloc] init];
		}		
    }
    return sharedInstance;
}

- (id)init
{
	if(self = [super init])
	{
		self.database = [DBUtil initializeDatabase];
		self.useSingleListInterface = NO;
		BOOL usli = [[NSUserDefaults standardUserDefaults] boolForKey:useSingleListInterfaceKey];
		if(usli)
		{
			self.useSingleListInterface = YES;		
		}
	}
	return self;
}

- (void)writeUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:self.useSingleListInterface forKey:useSingleListInterfaceKey];	
}

- (void)emailSDList:(id<MFMailComposeViewControllerDelegate>)delegate viewController:(UIViewController*)viewController
{
	NSLog(@"emailing SD list");
	//[[Session sharedInstance].itemList emailList:emailTextField.text];
	
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;
	NSString *subject = [NSString stringWithFormat:@"Todo List: %@", [Session sharedInstance].itemList.name];
	[controller setSubject:subject];
	NSString *filename = [NSString stringWithFormat:@"%@.simplydone", [Session sharedInstance].itemList.name];
	[controller addAttachmentData:[[Session sharedInstance].itemList createEmailAttachment] 
						 mimeType:@"application/simplydone" 
						 fileName:filename];
	[viewController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)emailPlainTextList:(id<MFMailComposeViewControllerDelegate>)delegate viewController:(UIViewController*)viewController
{
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;
	NSString *subject = [NSString stringWithFormat:@"Todo List: %@", [Session sharedInstance].itemList.name];
	[controller setSubject:subject];
	[controller setMessageBody:[[Session sharedInstance].itemList createEmailText] isHTML:NO]; 
	[viewController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)dealloc 
{
	[currentListId release];
	[itemList release];
	[lists release];
	[path release];
	[listName release];
	[super dealloc];
}

+ (int)getScreenWidth
{
	int screenWidth = [[UIScreen mainScreen] bounds].size.width;
	int screenHeight = [[UIScreen mainScreen] bounds].size.height;
	if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
	   [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
	{
		screenWidth = screenHeight;
	}
	
	//NSLog(@"returning screen width: %i", screenWidth);
	return screenWidth;
}

+ (int)getScreenHeight
{
	int screenWidth = [[UIScreen mainScreen] bounds].size.width;
	int screenHeight = [[UIScreen mainScreen] bounds].size.height;
	if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
	   [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
	{
		screenHeight = screenWidth;
	}
	
	//screenHeight = [[UIScreen mainScreen] bounds].size.height;
	//NSLog(@"returning screen height: %i", screenHeight);
	return screenHeight;
}

@end
