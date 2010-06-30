//
//  DBUtil.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBUtil : NSObject {
    
}

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (sqlite3*) getDatabase;

@end
