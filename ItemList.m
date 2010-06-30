//
//  List.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "ItemList.h"
#import "DBUtil.h"

@implementation ItemList

@synthesize identifier, name, sort, items;

-(id)initWithIdentifier:(NSNumber*)ident
{
    if(self = [super init])
    {
        self.identifier = ident;
        sqlite3 *db = [DBUtil getDatabase];
        const char *sql = "select name, sort from lists where id = ?";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(statement, 1, [identifier intValue]);
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                char * desc = sqlite3_column_text(statement, 0);
                int s = sqlite3_column_int(statement, 1);
                self.name = [NSString stringWithUTF8String:desc];
                self.sort = [NSNumber numberWithInt:s];
            }
        }
    }
    
    return self;
}

-(id)initWithNum:(NSInteger)num
{
    if(self = [super init])
    {
    }
    return self;
}

@end

