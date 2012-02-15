//
//  PRSession.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRSession.h"

static PRSession *instance;

@implementation PRSession
@synthesize services;

+ (PRSession*)instance
{
    if(!instance)
    {
        instance = [[PRSession alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        defaults = [DefaultsManager instance];
        NSString *filename = [CommonUtil getDataPathForFileWithName:@"services"];
        self.services = [NSMutableArray arrayWithArray:
                       [NSKeyedUnarchiver unarchiveObjectWithFile:filename]];
        if(self.services == nil)
            self.services = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - setters/getters

- (void)addService:(PRService*)service
{
    [services addObject:service];
    [NSKeyedArchiver archiveRootObject:self.services toFile:[CommonUtil getDataPathForFileWithName:@"services"]];
}


@end
