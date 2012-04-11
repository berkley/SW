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
        store = [[ACAccountStore alloc] init];
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
    ACAccount *acct = [self userAccount];
    NSLog(@"posting with twitter account: %@", acct.username);
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObject:msg forKey:@"status"];
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:url 
                                                 parameters:params 
                                              requestMethod:TWRequestMethodPOST];
    
    // Post the request
    [postRequest setAccount:acct];
    
    // Block handler to manage the response
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
     {
         NSString *consoleMsg;
         if(error)
         {
             consoleMsg = [NSString stringWithFormat:@"Twitter Send Failure: %@", [error localizedDescription]];
             NSLog(@"error: %@", [error localizedDescription]);
         }
         else
         {
             consoleMsg = [NSString stringWithFormat:@"Message sent to Twitter: %@", msg];
         }
//         NSLog(@"consoleMsg: %@", consoleMsg);
         [self performSelectorOnMainThread:@selector(sendConsoleMessage:) withObject:consoleMsg waitUntilDone:NO];
         
         NSError *err;        
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
//         NSLog(@"Twitter response: %@", dict); 
     }];
}

- (void)sendConsoleMessage:(NSString*)consoleMessage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:consoleMessage, @"text", nil]];
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
        return @"I'm testing SafeRoom. Please disregard.";
    else
        return testMessage;
}

//return the userAccount, or nil if it could not be returned from the AccountStore
- (ACAccount*)userAccount
{
    if(!store)
        store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store
                                         accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
    for(ACAccount *acct in twitterAccounts)
    {
        if([acct.username isEqualToString:self.username])
        {
            return acct;
        }
    }
    return nil;
}


@end
