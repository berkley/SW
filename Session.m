//
//  Session.m
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize currentListId, itemList, lists, isAddingNewList, path, listName;

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

@end
