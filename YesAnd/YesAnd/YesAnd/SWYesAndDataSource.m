//
//  SWYesAndDataSource.m
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "SWYesAndDataSource.h"

@implementation SWYesAndDataSource
@synthesize stories;

- (id)init
{
    self = [super init];
    if(self)
    {
        stories = [[NSMutableArray alloc] init];
        SWStory *story1 = [SWStory storyWithName:@"Story 1" parameters:nil];
        SWStory *story2 = [SWStory storyWithName:@"Story 2" parameters:nil];
        SWStory *story3 = [SWStory storyWithName:@"Story 3" parameters:nil];
        [stories addObject:story1];
        [stories addObject:story2];
        [stories addObject:story3];
    }
    return self;
}

- (void)addStory:(SWStory*)story
{
    [stories addObject:story];
}

@end
