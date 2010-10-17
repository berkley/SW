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
	//the current id of the ItemList that is active
	NSNumber *currentListId;
	//the itemList that is active
	ItemList *itemList;
	//the array of ItemLists
	NSMutableArray* lists;
}

@property (nonatomic, retain) NSNumber *currentListId;
@property (nonatomic, retain) ItemList *itemList;
@property (nonatomic, retain) NSMutableArray *lists;

+ (Session*)sharedInstance;

@end
