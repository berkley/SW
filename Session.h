//
//  Session.h
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemList.h"

@interface Session : NSObject 
{
	NSNumber *currentListId;
	ItemList *itemList;
}

@property (nonatomic, retain) NSNumber *currentListId;
@property (nonatomic, retain) ItemList *itemList;

+ (Session*)sharedInstance;

@end
