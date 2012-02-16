//
//  PRFacebookService.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/15/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRService.h"
#import "PRSession.h"
#import "Constants.h"

@interface PRFacebookService : PRService
{
    NSString *accessToken;
    NSDate *expirationDate;
}

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSDate *expirationDate;

@end
