//
//  PRFacebookService.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/15/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRFacebookService.h"

@implementation PRFacebookService
@synthesize expirationDate, accessToken;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        expirationDate = [aDecoder decodeObjectForKey:@"expirationDate"];
        accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:expirationDate forKey:@"expirationDate"];
    [coder encodeObject:accessToken forKey:@"accessToken"];
}

- (void)sendMessage:(NSString*)msg
{
    //send facebook message here
    msg = [NSString stringWithFormat:@"Sending to Facebook: %@", msg];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"text", nil]];
}

@end
