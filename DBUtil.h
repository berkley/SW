//
//  DBUtil.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface DBUtil : NSObject {

}

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void) initializeDatabase;

@end
