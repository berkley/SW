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

//create a new ItemList with an id
- (id) initWithIdentifier:(NSNumber*) ident
{
	NSMutableArray *itemArray;
	
    if(self = [super init])
    {
		[self.items release];
        itemArray = [[NSMutableArray alloc] init];
        
        self.identifier = ident;
		if([self.identifier intValue] == -1)
		{
			return self;
		}
        sqlite3 *db = [DBUtil getDatabase];
        char *sql = "select name, sort from lists where id = ? order by sort";
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
        
        [self initItemsFromDB];
    }
    return self;
}

- (void)initItemsFromDB
{
	[self.items release];
	self.items = [[NSMutableArray alloc] init];
	sqlite3 *db = [DBUtil getDatabase];
	sqlite3_stmt *statement;
	const char *sql2 = "select id, description, done, sort from items where list_id = ? order by sort";
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
			NSLog(@"adding item %@ to list %@ with sort %@", i.description, self.name, i.sort);
			[self.items addObject:i];
			[i release];
		}
	}
}

//create a new ItemList in the db and get a new identifier for it
- (id) initWithName:(NSString*)n
{
	NSLog(@"creating new list with name: %@", n);
	if(self = [super init])
    {
		self.name = n;
		self.sort = [NSNumber numberWithInt:[[Session sharedInstance].lists count]];
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

- (void) addItem:(NSString *)description
{
	return [self addItem:description done:NO];
}

- (int) getHighestSortValue
{
	int highest = 0;
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		if([item.sort intValue] > highest)
		{
			highest = [item.sort intValue];
		}
	}
	return highest;
}

- (void) deleteItem:(NSNumber*)id
{
	//delete the items
	//update the sort values for each item in the list
	
	BOOL reorder = NO;
	int remIndex = -1;
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		if([item.id intValue]  == [id intValue])
		{
			[item deleteItem];
			reorder = YES;
			remIndex = i;
		}
		
		if(reorder)
		{
			item.sort = [NSNumber numberWithInt:i - 1];
		}
	}
	
	[self.items removeObjectAtIndex:remIndex];
}

//add an item to this list
- (void) addItem:(NSString*)description done:(BOOL)d
{
	Item *item = [[Item alloc] init];
	item.description = description;
	item.sort = [NSNumber numberWithInt:[self.items count]];
	//item.sort = [NSNumber numberWithInt:[self getHighestSortValue]];
	sqlite3 *db = [DBUtil getDatabase];
	const char *sql = "insert into items (list_id, description, done, sort)  values (?, ?, ?, ?)";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, [self.identifier intValue]);
		sqlite3_bind_text(statement, 2, [item.description UTF8String], -1, SQLITE_TRANSIENT);
		if(d)
		{
			sqlite3_bind_int(statement, 3, 1);
		}
		else 
		{
			sqlite3_bind_int(statement, 3, 0);
		}
		sqlite3_bind_int(statement, 4, [item.sort intValue]);
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

//return the number of done items in this list
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

//delete any item marked as done
- (void) deleteAllDoneItems
{
	NSLog(@"deleting all done items in list %@", self.identifier);
	sqlite3 *db = [DBUtil getDatabase];
	NSMutableArray *removeArr = [[NSMutableArray alloc] init];
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		NSLog(@"might remove item %@ with done value %@", item.description, item.done);
		if([item.done intValue] == 1)
		{
			[removeArr addObject:[NSNumber numberWithInt:i]];
			NSLog(@"removing item %@", item.description);
			
			sqlite3_stmt *statement;
			const char *sql = "delete from items where id = ?";
			if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
			{
				sqlite3_bind_int(statement, 1, [item.id intValue]);
				sqlite3_step(statement);
				sqlite3_reset(statement);
			}
			else 
			{
				NSLog(@"Error deleting item %@ from the DB", item.id);
			}	
		}
	}
	
	[self initItemsFromDB];
}

//delete all of the items in this list
- (void) deleteAllItems
{
	NSLog(@"deleting all items in list %@", self.identifier);
	sqlite3 *db = [DBUtil getDatabase];
	sqlite3_stmt *statement;
	const char *sql = "delete from items where list_id = ?";
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, [self.identifier intValue]);
		sqlite3_step(statement);
		sqlite3_reset(statement);
	}
	else 
	{
		NSLog(@"Error deleting all items from the DB");
	}	
	self.items = [[NSMutableArray alloc] init];
}

//delete this list from the DB
- (void) delete
{
	NSLog(@"deleting list %@", self.identifier);
	sqlite3 *db = [DBUtil getDatabase];
	const char *sql = "delete from lists where id = ?";
	sqlite3_stmt *statement;
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, [self.identifier intValue]);
		sqlite3_step(statement);
		sqlite3_reset(statement);
	}
	else 
	{
		NSLog(@"Error deleting list %@ from the the DB", self.identifier);
	}	
	
	[self deleteAllItems];
}

- (void) updateItemDescription:(NSString*)desc withId:(NSNumber*)id
{
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		if([item.id intValue] == [id intValue])
		{
			[item updateDescription:desc];
		}
	}
}

- (NSString*) createEmailText
{
	NSString *txt = @"";
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		txt = [txt stringByAppendingString:[item toString]];
		txt = [txt stringByAppendingString:@"\n"];
	}
	txt = [txt stringByAppendingString:@"\nCreated with Simply Done\n"];
	return txt;
}

- (NSData*)createEmailAttachment
{
	NSString *txt = [NSString stringWithFormat:@"%@", self.name];
	txt = [txt stringByAppendingString:@"\n"];
	for(int i=0; i<[self.items count]; i++)
	{
		Item *item = [self.items objectAtIndex:i];
		txt = [txt stringByAppendingString:[item export]];
		txt = [txt stringByAppendingString:@"\n"];
	}
	//NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	//NSString *path = [docsDirectory stringByAppendingPathComponent:@"export.txt"];
	//[txt writeToFile:path atomically:YES];
	return [txt dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)dealloc 
{
	[identifier release];
	[name release];
	[sort release];
	[items release];
	[super dealloc];
}

@end

