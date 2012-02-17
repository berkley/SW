//
//  PRSMSService.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRService.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"

@interface PRSMSService : PRService 
{
    NSString *phoneNumber;
    NSString *senderName;
    NSString *receiverName;
}

@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *receiverName;

@end
