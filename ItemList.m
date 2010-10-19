//
//  List.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "ItemList.h"
#import "DBUtil.h"
#import "Item.h"
#import "Session.h"

@implementation ItemList

@synthesize identifier, name, sort, items;

- (id) initWithIdentifier:(NSNumber*) ident
{
	NSMutableArray *itemArray;
	
    if(self = [super init])
    {
        itemArray = [[NSMutableArray alloc] init];
        
        self.identifier = ident;
		if([self.identifier intValue] == -1)
		{
			return self;
		}
        sqlite3 *db = [DBUtil getDatabase];
        char *sql = "select name, sort from lists where id = ?";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(statement, 1, [identifier intValue]);
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                char *n = sqlite3_column_text(statement, 0);
                self.name = [NSString stringWithUTF8String:n];
                int s = sqlite3_column_int(statement, 1);
                self.sort = [NSNumber numberWithInt:s];
            }
        }
        
        const char *sql2 = "select id, description, done, sort from items where list_id = ?";
        if(sqlite3_prepare_v2(db, sql2, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(statement, 1, [self.identifier intValue]);
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                int ident = sqlite3_column_int(statement, 0);
                char *desc = sqlite3_column_text(statement, 1);
                int done = sqlite3_column_int(statement, 2);
                int srt = sqlite3_column_int(statement, 3);
                Item *i = [[Item alloc] init];
                i.id = [NSNumber numberWithInt:ident];
                i.description = [NSString stringWithUTF8String:desc];
                i.done = [NSNumber numberWithInt:done];
                i.sort = [NSNumber numberWithInt:srt];
				NSLog(@"adding item %@ to list %@", i.description, self.identifier);
                [itemArray addObject:i];
				[i release];
            }
        }
		self.items = itemArray;
		[itemArray release];
    }
    return self;
}

/**
 * create a new ItemList in the db and get a new identifier for it
 */
- (id) initWithName:(NSString*)n
{
	NSLog(@"creating new list with name: %@", n);
	if(self = [super init])
    {
		self.name = n;
		self.sort = [NSNumber numberWithInt:[[Session sharedInstance].lists count] + 1];
		sqlite3 *db = [DBUtil getDatabase];
		const char *sql = "insert into lists (name, sort)  values (?, ?)";
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(statement, 1, [self.name UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(statement, 2, [self.sort intValue]);
			sqlite3_step(statement);
			sqlite3_reset(statement);
		}
		else 
		{
			NSLog(@"Error inserting new list into the DB");
		}
		self.identifier = [NSNumber numberWithInt: sqlite3_last_insert_rowid(db)];
		NSLog(@"New ItemList created with id %@", self.identifier);
	}
	
	return self;
}

- (void) addItem:(NSString*)description
{
	Item *item = [[Item alloc] init];
	item.description = description;
	item.sort = [NSNumber numberWithInt:[self.items count] + 1];
	sqlite3 *db = [DBUtil getDatabase];
	const char *sql = "insert into items (list_id, description, done, sort)  values (?, ?, ?, ?)";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, [self.identifier intValue]);
		sqlite3_bind_text(statement, 2, [item.description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(statement, 3, 0);
		sqlite3_bind_int(statement, 4, item.sort);
		sqlite3_step(statement);
		sqlite3_reset(statement);
		item.id = [NSNumber numberWithInt: sqlite3_last_insert_rowid(db)];
	}
	else 
	{
		NSLog(@"Error inserting new list into the DB");
	}
	NSLog(@"item created with id %@", item.id);
	if(self.items == nil)
	{
		self.items = [[NSMutableArray alloc]init];
	}
	[self.items addObject:item];
	NSLog(@"There are now %i items in the item list", [self.items count]);
}

- (NSNumber*) numberDone
{
	int count = 0;
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		if([item.done intValue] > 0)
		{
			count++;
		}
	}
	return [NSNumber numberWithInt:count];
}

@end

