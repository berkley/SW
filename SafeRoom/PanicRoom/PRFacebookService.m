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
    //send facebook message
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POST_TO_FACEBOOK 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                msg, @"message", 
                                                                self.accessToken, @"accessToken",
                                                                self.expirationDate, @"expirationDate", nil]];
    //update the status display
    msg = [NSString stringWithFormat:@"Publishing to Facebook: '%@'", msg];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"text", nil]];
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
