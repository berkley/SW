//
//  PRSession.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PRSession.h"

static PRSession *instance;

@implementation PRSession

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
    }
    return self;
}

#pragma mark - setters/getters

- (void)addServices:(PRService*)service
{
    NSMutableArray *services = self.services;
    [services addObject:service];
    [defaults setObject:services withName:@"Services"];
}

- (NSMutableArray*)services
{
    NSMutableArray *services = (NSMutableArray*)[defaults getObjectWithName:@"Services"];
    if(!services)
        services = [[NSMutableArray alloc] init];
    
    return services;
}


@end
