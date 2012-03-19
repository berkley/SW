//
//  SWFileSystemDataSource.h
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Stumpware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWYesAndDataSource.h"
#import "CommonUtil.h"

@interface SWFileSystemDataSource : SWYesAndDataSource 
{
    NSString *filename;
}

@end
