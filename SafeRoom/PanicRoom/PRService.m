//
//  PRService.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRService.h"

@implementation PRService
@synthesize name, testMessage, emergencyMessage;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:testMessage forKey:@"testMessage"];
    [coder encodeObject:emergencyMessage forKey:@"emergencyMessage"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        name = [decoder decodeObjectForKey:@"name"];
        emergencyMessage = [decoder decodeObjectForKey:@"emergencyMessage"];
        testMessage = [decoder decodeObjectForKey:@"testMessage"];
    }
    return self;
}

- (void)sendMessage:(NSString*)msg
{
    NSAssert(FALSE, @"this method should be overridden", nil);
}

@end
