//
//  DBUtil.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "DBUtil.h"
#import "Constants.h"
#import "Session.h"

@implementation DBUtil

+ (void)createEditableCopyOfDatabaseIfNeeded 
{
    //set up the db
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:SQL_FILE];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) 
    {
        return;        
    }
    
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQL_FILE];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if(!success)
	{
        NSLog(@"DB file is %s", SQL_FILE);
		NSAssert1(0, @"Failed to create writable database file with message '%s'.", [error localizedDescription]);
	}
}

+ (sqlite3*) getDatabase
{
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:SQL_FILE];
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        return database;
    }
    else 
    {
        NSLog(@"Failed to get database object.");
        return nil;
    }
}

+ (NSArray*) getListIds
{
    NSMutableArray *listIds = [[NSMutableArray alloc] init];
    sqlite3 *db = [DBUtil getDatabase];
    const char *sql = "select id from lists order by sort";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            int id = sqlite3_column_int(statement, 0);
            NSNumber *num = [NSNumber numberWithInt:id];
            [listIds addObject:num];
        }
    }
    return listIds;
}

+ (void) loadLists
{
	NSLog(@"!!!!!!!!!!Loading lists!");
	NSArray* listIds = [DBUtil getListIds];
	[[Session sharedInstance].lists release];
	[Session sharedInstance].lists = [[NSMutableArray alloc] init];
    for(int i=0; i<[listIds count]; i++)
    {
        NSNumber *listId = [listIds objectAtIndex:i];
		ItemList *list = [[ItemList alloc] initWithIdentifier:listId];
		if([listId intValue] == [[Session sharedInstance].currentListId intValue])
		{
			[Session sharedInstance].itemList = list;
		}
        [[Session sharedInstance].lists addObject:list];
        NSLog(@"adding list %@", listId);
    }	
}

@end
