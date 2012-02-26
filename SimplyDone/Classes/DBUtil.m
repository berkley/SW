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
#import "Simply_DoneAppDelegate.h"

@implementation DBUtil

static DBUtil *sharedInstance;

+ (DBUtil*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[DBUtil alloc] init];
		}		
    }
    return sharedInstance;
}

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
	NSLog(@"db file: %@", writableDBPath); 
	if(success) 
    {
        return;        
    }
    
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQL_FILE];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if(!success)
	{
        NSLog(@"DB file is %@", SQL_FILE);
		NSAssert1(0, @"Failed to create writable database file with message '%s'.", [error localizedDescription]);
	}
}

+ (sqlite3*) getDatabase
{
	return [Session sharedInstance].database;
}

+ (sqlite3*) initializeDatabase
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
		[list release];
        NSLog(@"adding list %@", listId);
    }	
}

//make sure the lists are loaded into the session before calling this
+ (BOOL) listWithNameExists:(NSString*)name
{
	for(int i=0; i<[[Session sharedInstance].lists count]; i++)
	{
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:i];
		if([name isEqualToString:list.name])
		{
			return YES;
		}
	}
	return NO;
}

- (void) importListFileWithListId:(NSNumber*)listId filePath:(NSString*)filePath;
{
	NSLog(@"importing list with id %@ from path %@", listId, filePath);
	NSError *error;
	NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	NSArray *listItems = [fileStr componentsSeparatedByString:@"\n"];
	NSString *name = [listItems objectAtIndex:0];
	NSLog(@"list name: %@", name);
	if(listId == nil)
	{ //create a new list
		NSLog(@"adding new list");
		ItemList *list = [[ItemList alloc] initWithName:name];
		[[Session sharedInstance].lists addObject:list];
		for(int i=1; i<[listItems count]; i++)
		{
			NSString *line = [listItems objectAtIndex:i];
			if([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
			{
				continue;
			}
			NSLog(@"line: %@", line);
			NSArray *fields = [line componentsSeparatedByString:@","];
			NSString *doneStr = (NSString*)[fields objectAtIndex:0];
			NSString *desc = (NSString*)[fields objectAtIndex:1];
			BOOL d = NO;
			if([doneStr isEqualToString:@"1"])
			{
				d = YES;
			}
			[list addItem:desc done:d];
		}
	}
	else 
	{ //import into an existing list
		for(int i=0; i<[[Session sharedInstance].lists count]; i++)
		{
			NSLog(@"importing into current list");
			ItemList *list = [[Session sharedInstance].lists objectAtIndex:i];
			if([list.identifier intValue] == [listId intValue])
			{//add the items to this list
				for(int j=1; j<[listItems count]; j++)
				{
					NSString *line = [listItems objectAtIndex:j];
					NSLog(@"line: %@", line);
					if([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
					{
						continue;
					}
					NSArray *fields = [line componentsSeparatedByString:@","];
					NSString *doneStr = (NSString*)[fields objectAtIndex:0];
					NSString *desc = (NSString*)[fields objectAtIndex:1];
					BOOL d = NO;
					if([doneStr isEqualToString:@"1"])
					{
						d = YES;
					}
					[list addItem:desc done:d];
				}
				break;
			}
		}
	}
}

- (void) importListFile:(NSString*)filePath
{
	NSLog(@"importing list file");
	NSError *error;
	NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	NSArray *listItems = [fileStr componentsSeparatedByString:@"\n"];
	[Session sharedInstance].listName = [listItems objectAtIndex:0];
	//check to see if the list name already exists.  if it does as the user if they would like to merge or create
	//a new list

	[Session sharedInstance].path = filePath;
	
	if([DBUtil listWithNameExists:[Session sharedInstance].listName])
	{
		NSString* msg = [NSString stringWithFormat:@"A list named %@ already exists.  You can merge these lists or create a new list with the same name.", [Session sharedInstance].listName];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merge?" message:msg delegate:self cancelButtonTitle:@"New List" otherButtonTitles:@"Merge", nil];
		[alert show];
	}
	else
	{
		[self importListFileWithListId:nil filePath:filePath];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"handling user input via alertView");
	NSString *path = [Session sharedInstance].path;
	if(buttonIndex == 0)
	{ //new list
		NSLog(@"button 0 clicked");
		NSLog(@"calling imporListFileWithListId:nil filePath:%@", path);
		[self importListFileWithListId:nil filePath:path];
		[DBUtil loadLists];
		Simply_DoneAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate refreshRootViewController];
	}
	else 
	{ //merge
		NSLog(@"button 1 clicked");
		NSNumber *listId = nil;
		for(int i=0; i<[[Session sharedInstance].lists count]; i++)
		{
			ItemList *list = [[Session sharedInstance].lists objectAtIndex:i];
			if([[Session sharedInstance].listName isEqualToString:list.name])
			{
				listId = list.identifier;
				break;
			}
		}
		NSLog(@"calling imporListFileWithListId:%@ filePath:%@", listId, path);
		[self importListFileWithListId:listId filePath:path];
		[DBUtil loadLists];
		Simply_DoneAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate refreshRootViewController];
	}

}

@end
