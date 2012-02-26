//
//  PRService.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRService : NSObject <NSCoding>
{
    NSString *name;
    NSString *testMessage;
    NSString *emergencyMessage;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *testMessage;
@property (nonatomic, retain) NSString *emergencyMessage;

- (void)sendMessage:(NSString*)msg;

@end
