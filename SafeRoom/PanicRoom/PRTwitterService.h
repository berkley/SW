//
//  PRTwitterService.h
//  SafeRoom
//
//  Created by Chad Berkley on 3/20/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRService.h"
#import "PRSession.h"

@interface PRTwitterService : PRService
{
    NSString *username;
}

@property (nonatomic, retain) NSString *username;


@end
