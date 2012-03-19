//
//  SWYesAndDataSource.h
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWStory.h"

//This class should be extended by different types of data sources
//For instance, there could be an iCloudDataSource or a FileSystemDataSource
//that get their data from different types of sources
//if not extended, this class will just return non-persistent, dummy data
@interface SWYesAndDataSource : NSObject
{
    NSMutableArray *stories;
}

@property (nonatomic, readonly) NSArray *stories;

- (void)addStory:(SWStory*)story;

@end
