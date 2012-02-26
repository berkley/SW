//
//  DBUtil.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBUtil : NSObject <UIAlertViewDelegate> {
    
}

+ (id) sharedInstance;
+ (void) createEditableCopyOfDatabaseIfNeeded;
+ (sqlite3*) getDatabase;
+ (NSArray*) getListIds;
+ (void) loadLists;
- (void) importListFile:(NSString*)filePath;
- (void) importListFileWithListId:(NSNumber*)listId filePath:(NSString*)filePath;
+ (BOOL) listWithNameExists:(NSString*)name;
+ (sqlite3*) initializeDatabase;

@end
