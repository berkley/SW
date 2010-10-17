//
//  Session.m
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import "Session.h"


@implementation Session

@synthesize currentListId, itemList, lists;

static Session *sharedInstance = nil;

- (void)dealloc {
    [super dealloc];
}

+ (Session*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Session alloc] init];
    }
    return sharedInstance;
}


@end
