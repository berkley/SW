//
//  SWStoryContent.m
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Stumpware LLC. All rights reserved.
//

#import "SWStoryContent.h"

@implementation SWStoryContent
@synthesize authorId, content;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        authorId = [decoder decodeObjectForKey:@"authorId"];
        content = [decoder decodeObjectForKey:@"content"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:authorId forKey:@"authorId"];
    [coder encodeObject:content forKey:@"content"];
}

@end
