//
//  PRSMSService.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRSMSService.h"

@implementation PRSMSService
@synthesize phoneNumber, receiverName, senderName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        receiverName = [aDecoder decodeObjectForKey:@"receiverName"];
        senderName = [aDecoder decodeObjectForKey:@"senderName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:receiverName forKey:@"receiverName"];
    [aCoder encodeObject:senderName forKey:@"senderName"];
}

- (void)sendMessage:(NSString*)msg
{
    NSLog(@"Sending SMS message to %@", self.phoneNumber);
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@%@/%@/SMS/Messages", 
                           TWILIO_ACCOUNT_ID, TWILIO_AUTH_TOKEN, TWILIO_SMS_URL, 
                           TWILIO_ACCOUNT_ID];
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", TWILIO_NUMBER, self.phoneNumber, msg];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) 
    {
        NSLog(@"Error: %@", error);
    } 
    else 
    {
        NSString *receivedString = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"Request sent. %@", receivedString);
    }  
    
    msg = [NSString stringWithFormat:@"Sending SMS: '%@'", msg];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg, @"text", nil]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response: %@", response);
    NSLog(@"url: %@", response.URL);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"did receive data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finished");
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
