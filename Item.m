//
//  Item.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "Item.h"


@implementation Item

@synthesize id, sort, description, done, list_id;

-(id)initWithInt:(NSInteger)num
{
    if(self = [super init])
    {
        
    }
    return self;
}

@end
