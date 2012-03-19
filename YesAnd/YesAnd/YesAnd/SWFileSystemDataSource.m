//
//  SWFileSystemDataSource.m
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Stumpware LLC. All rights reserved.
//

#import "SWFileSystemDataSource.h"

@implementation SWFileSystemDataSource

- (id)init
{
    self = [super init];
    if(self)
    {
        filename = [CommonUtil getDataPathForFileWithName:@"stories"];        
    }
    return self;
}

- (void)addStory:(SWStory*)story
{
    NSMutableArray *s = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    [s addObject:story];
    [NSKeyedArchiver archiveRootObject:s toFile:filename];
}

- (NSArray*)stories
{
    NSArray *s = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return s;
}

@end
