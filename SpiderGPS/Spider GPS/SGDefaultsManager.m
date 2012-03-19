//
//  SGDefaultsManager.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 Chad Berkley. All rights reserved.
//

#import "SGDefaultsManager.h"


@implementation SGDefaultsManager

static SGDefaultsManager *instance = nil;

//singleton accessor
+ (SGDefaultsManager*)instance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        //deserialize any defaults here
        defaults = [[NSUserDefaults standardUserDefaults] objectForKey:ROOT_OBJECT];
        if(defaults == nil)
        {
            defaults = [[NSMutableDictionary alloc] init];       
        }
    }
    return self;
}

- (void)setObject:(NSObject*)obj withName:(NSString*)name
{
//    NSLog(@"obj: %@ name: %@", obj, name);
    if(obj == nil || name == nil)
        return;
    [defaults setObject:obj forKey:name];
    [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:ROOT_OBJECT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSObject*)getObjectWithName:(NSString*)name
{
    return [defaults objectForKey:name];
}

@end

