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

//delete this item from the DB
- (void) deleteItem
{
	sqlite3 *db = [DBUtil getDatabase];
	sqlite3_stmt *statement;
	const char *sql = "delete from items where id = ?";
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, [self.id intValue]);
		sqlite3_step(statement);
		sqlite3_reset(statement);
	}
	else 
	{
		NSLog(@"Error deleting item %@ from the DB", self.id);
	}
}

- (void) updateDescription:(NSString*)desc
{
	sqlite3 *db = [DBUtil getDatabase];
	sqlite3_stmt *statement;
	self.description = desc;
	const char *sql = "update items set description = ? where id = ?";
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_text(statement, 1, [self.description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(statement, 2, [self.id intValue]);
		sqlite3_step(statement);
		sqlite3_reset(statement);
	}
	else 
	{
		NSLog(@"Error deleting item %@ from the DB", self.id);
	}
}

- (NSString*)toString
{
	NSString *d = @"X ";
	if([self.done intValue] == 0)
	{
		d = @"";
	}
	NSString *txt = [NSString stringWithFormat:@"%@%@", d, self.description];
	return txt;
}

- (NSString*)export
{
	NSString *d = @"1";
	if([self.done intValue] == 0)
	{
		d = @"0";
	}

	NSString *txt = [NSString stringWithFormat:@"%@,%@", d, self.description];
	return txt;
}

- (void)dealloc 
{
	[self.id release];
	[description release];
	[sort release];
	[done release];
	[list_id release];
	[super dealloc];
}

@end
