//
//  PRTwitterService.m
//  SafeRoom
//
//  Created by Chad Berkley on 3/20/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRTwitterService.h"

@implementation PRTwitterService
@synthesize username;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        username = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:username forKey:@"username"];
}

- (void)sendMessage:(NSString*)msg
{
    //do the message sending here
}

- (NSString*)emergencyMessage
{
    if(emergencyMessage == nil)
        return [PRSession instance].alertMessage;
    else
        return emergencyMessage;
}

- (NSString*)testMessage
{
    if(testMessage == nil)
        return [PRSession instance].testMessage;
    else
        return testMessage;
}


@end
