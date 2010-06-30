//
//  DBTest.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "DBTest.h"
#import "DBUtil.h"
#import "ItemList.h"
#import "Item.h"

@implementation DBTest

+ (void) runListTest
{
    NSArray *listIds = [DBUtil getListIds];
    for(int i=0; i<[listIds count]; i++)
    {
        NSNumber *ident = [listIds objectAtIndex:i];
        ItemList *l = [[ItemList alloc] initWithIdentifier:ident];
        NSLog(@"list %s", l.name);
        
    }
}

+ (void) runTests
{
    [DBTest runListTest];
}

@end
