//
//  SWStory.m
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "SWStory.h"

@implementation SWStory
@synthesize name, params, content;

- (id)initWithName:(NSString*)n
{
    self = [super init];
    if(self)
    {
        self.name = n;
        content = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.params = [decoder decodeObjectForKey:@"params"];
        self.content = [decoder decodeObjectForKey:@"content"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:params forKey:@"params"];
    [coder encodeObject:content forKey:@"content"];
}

- (void)addContent:(SWStoryContent*)c
{
    [content addObject:c];
}

+ (SWStory*)storyWithName:(NSString*)name parameters:(NSDictionary*)params
{
    SWStory *story = [[SWStory alloc] initWithName:name];
    story.params = params;
    return story;
}

@end
