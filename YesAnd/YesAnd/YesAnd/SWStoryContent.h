//
//  SWStoryContent.h
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Stumpware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStoryContent : NSObject <NSCoding>
{
    NSString *authorId;
    NSString *content;
}

@property (nonatomic, retain) NSString *authorId;
@property (nonatomic, retain) NSString *content;

@end
