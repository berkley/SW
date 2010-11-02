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
