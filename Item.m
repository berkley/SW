//
//  Item.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "Item.h"
#import "DBUtil.h"

@implementation Item

@synthesize id, sort, description, done, list_id;

- (void)touched
{
	if([self.done intValue] > 0)
	{
		self.done = [NSNumber numberWithInt: 0];
	}
	else 
	{
		self.done = [NSNumber numberWithInt: 1];
	}
	
	//write the new done value to the db
	sqlite3 *db = [DBUtil getDatabase];
    const char *sql = "update items set done = ? where id = ?";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
    {
		sqlite3_bind_int(statement, 1, [self.done intValue]);
		sqlite3_bind_int(statement, 2, [self.id intValue]);
		sqlite3_step(statement);
		sqlite3_reset(statement);
    }
}

@end
