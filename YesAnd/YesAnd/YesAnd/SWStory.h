//
//  SWStory.h
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWStoryContent.h"

@interface SWStory : NSObject <NSCoding>
{
    NSString *name;
    NSMutableArray *content;
    NSDictionary *params;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSArray *content;

- (id)initWithName:(NSString*)n;
- (void)addContent:(SWStoryContent*)c;
+ (SWStory*)storyWithName:(NSString*)name parameters:(NSDictionary*)params;


@end
