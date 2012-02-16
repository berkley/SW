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

- (NSString*)testMessage
{
    if(![defaults getObjectWithName:@"testMessage"])
        [defaults setObject:@"I'm testing SafeRoom. Please disregard this message." withName:@"testMessage"];
    return (NSString*)[defaults getObjectWithName:@"testMessage"];
}

- (void)setTestMessage:(NSString *)testMessage
{
    [defaults setObject:testMessage withName:@"testMessage"];
}

- (NSString*)alertMessage
{
    if(![defaults getObjectWithName:@"alertMessage"])
        [defaults setObject:@"I need help! Please find me." withName:@"alertMessage"];
    return (NSString*)[defaults getObjectWithName:@"alertMessage"];
}

- (void)setAlertMessage:(NSString *)alertMessage
{
    [defaults setObject:alertMessage withName:@"alertMessage"];
}

- (BOOL)testMode
{
    NSString *str = (NSString*)[defaults getObjectWithName:@"testMode"];
    return [str isEqualToString:@"YES"];
}

- (void)setTestMode:(BOOL)testMode
{
    if(testMode)
        [defaults setObject:@"YES" withName:@"testMode"];
    else
        [defaults setObject:@"NO" withName:@"testMode"];
}

#pragma mark - service methods

- (void)addService:(PRService*)service
{
    [services addObject:service];
    [NSKeyedArchiver archiveRootObject:self.services toFile:[CommonUtil getDataPathForFileWithName:@"services"]];
}

- (void)removeService:(PRService*)service
{
    [services removeObject:service];
    [NSKeyedArchiver archiveRootObject:self.services toFile:[CommonUtil getDataPathForFileWithName:@"services"]];
}

- (PRService*)serviceWithName:(NSString*)name
{
    for(PRService *service in services)
    {
        if([service.name isEqualToString:name])
            return service;
    }
    return nil;
}

@end
