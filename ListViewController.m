//
//  ListViewController.m
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import "ListViewController.h"
#import "Session.h"
#import "Item.h"
#import "ItemList.h"
#import "DBUtil.h"

@implementation ListViewController


#pragma mark -
#pragma mark View lifecycle

UITextField *addField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    //self.navigationItem.leftBarButtonItem = addButton;
	//[addButton release];
}

- (void)addItem:(id)sender 
{
	NSLog(@"add button pushed");
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[Session sharedInstance].itemList.items count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}	


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	NSLog(@"loading data for cells.  There are %i items in the items array", [[Session sharedInstance].itemList.items count]);
    static NSString *CellIdentifier = @"Cell";
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }*/
	
    UITableViewCell	*cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	if(indexPath.row == [[Session sharedInstance].itemList.items count])
	{
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		
		addField = [[UITextField alloc] initWithFrame:CGRectMake(5, 4, 275, 31)];
		addField.borderStyle = UITextBorderStyleRoundedRect;
		[view addSubview:addField];
	
		UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
		button.frame = CGRectMake(285, 3, 31, 31);
		[view addSubview:button];
		[button addTarget:self action:@selector(newItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		
		[cell.contentView addSubview:view];
	}
	else
	{
		Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
		NSLog(@"adding cell for item with id %@", item.id);
		cell.textLabel.text = item.description;
		if([item.done intValue] > 0)
		{
			cell.imageView.image = [UIImage imageNamed:@"CheckedBox.png"];		
		}
		else 
		{
			cell.imageView.image = [UIImage imageNamed:@"UncheckedBox.png"];
		}		
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

-(void)newItemButtonTouched:(id)sender
{
	NSLog(@"Add button pushed. text: %@", addField.text);
	[[Session sharedInstance].itemList addItem:addField.text];
	NSLog(@"There are now %i items in the shared item list", [[Session sharedInstance].itemList.items count]);
	[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.row >= [[Session sharedInstance].itemList.items count])
	{
		return;
	}
	Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
	[item touched];
	[self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Accessory button tapped for list item");
	//TODO: put code here for showing the options for the list
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if(indexPath.row >= [[Session sharedInstance].itemList.items count])
	{
		return NO;
	}    
	return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	sqlite3 *db = [DBUtil getDatabase];
	sqlite3_stmt *statement;
	sqlite3_stmt *update_statement;
	int fromCellRow = fromIndexPath.row;
	int toCellRow = toIndexPath.row;
	int list_id = [[Session sharedInstance].itemList.identifier intValue];
	NSLog(@"fromCell: %i, toCell: %i", fromCellRow, toCellRow);

	const char *sql;
	if(fromCellRow > toCellRow)
	{
		sql = "select id, sort from items where sort >= ? and sort <= ? and list_id = ?";
	}
	else 
	{
		sql = "select id, sort from items where sort <= ? and sort >= ? and list_id = ?";
	}

	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, toCellRow);
		sqlite3_bind_int(statement, 2, fromCellRow);
		sqlite3_bind_int(statement, 3, list_id);
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			int item_id = sqlite3_column_int(statement, 0);
			int item_sort = sqlite3_column_int(statement, 1);
			if(fromCellRow > toCellRow)
			{
				item_sort++;					
			}
			else
			{
				item_sort--;
			}

			const char *update_sql = "update items set sort = ? where id = ?";
			if(sqlite3_prepare_v2(db, update_sql, -1, &update_statement, NULL) == SQLITE_OK)
			{
				NSLog(@"updating item %i with sort value %i", item_id, item_sort);
				sqlite3_bind_int(update_statement, 1, item_sort);
				sqlite3_bind_int(update_statement, 2, item_id);
				sqlite3_step(update_statement);
				sqlite3_reset(update_statement);
			}
			else 
			{
				NSLog(@"Error updating sort in ListViewController.moveRowAtIndexPath");
			}
		}
	}
	else 
	{
		NSLog(@"Error select id and sort in ListViewController.moveRowAtIndexPath");
	}
	
	//update the sort for the item that actually moved
	const char *update_sql = "update items set sort = ? where id = ?";
	sqlite3_stmt *update_statement2;
	if(sqlite3_prepare_v2(db, update_sql, -1, &update_statement2, NULL) == SQLITE_OK)
	{
		Item *i = [[Session sharedInstance].itemList.items objectAtIndex:fromCellRow];
		int item_id = [i.id intValue];
		sqlite3_bind_int(update_statement2, 1, toCellRow);
		sqlite3_bind_int(update_statement2, 2, item_id);
		sqlite3_step(update_statement2);
		sqlite3_reset(update_statement2);
		NSLog(@"updated item %i with sort value %i", item_id, toCellRow);
	}
	else 
	{
		NSLog(@"Error updating moved cell.");
	}

	[DBUtil loadLists];
}

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	sqlite3_stmt *statement;
	sqlite3_stmt *update_statement = nil;
	ToDoAppDelegate *appDelegate = (ToDoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int fromCellRow = fromIndexPath.row;
	int toCellRow = toIndexPath.row;
	
	if(fromCellRow > toCellRow)
	{
		//now update all of the other todos and cascade the order change down
		//the list
		//int order = toCell.todo.order;
		//for each cell with fromCellRow < priority > toCellRow, increment order
		const char *sql2 = "select pk, priority, text from todo where priority >= ? and priority <= ?";
		if(sqlite3_prepare_v2(appDelegate.database, sql2, -1, &statement, NULL) != SQLITE_OK)
		{
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(appDelegate.database));
		}
		sqlite3_bind_int(statement, 1, toCellRow);
		sqlite3_bind_int(statement, 2, fromCellRow);
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			int primaryKey = sqlite3_column_int(statement, 0);
			int priority = sqlite3_column_int(statement, 1);
			//char * c = sqlite3_column_text(statement, 2);
			
			priority++;
			
			const char *sql3 = "update todo set priority=? where pk=?;";
			if(sqlite3_prepare_v2(appDelegate.database, sql3, -1, &update_statement, NULL) != SQLITE_OK)
			{
				NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(appDelegate.database));
			}
			
			sqlite3_bind_int(update_statement, 1, priority);
			sqlite3_bind_int(update_statement, 2, primaryKey);
			sqlite3_step(update_statement);
			sqlite3_reset(update_statement);
			sqlite3_finalize(update_statement);
		}
		sqlite3_finalize(statement);
	}
	else //user moved an item down the list
	{
		//now update all of the other todos and cascade the order change down
		//the list
		//int order = toCell.todo.order;
		//for each cell with priority >= toCell.order, increment order
		const char *sql2 = "select pk, priority, text from todo where priority <= ? and priority >= ?";
		if(sqlite3_prepare_v2(appDelegate.database, sql2, -1, &statement, NULL) != SQLITE_OK)
		{
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(appDelegate.database));
		}
		sqlite3_bind_int(statement, 1, toCellRow);
		sqlite3_bind_int(statement, 2, fromCellRow);
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			int primaryKey = sqlite3_column_int(statement, 0);
			int priority = sqlite3_column_int(statement, 1);
			//char * c = sqlite3_column_text(statement, 2);
			
			priority--;
			
			const char *sql3 = "update todo set priority=? where pk=?;";
			if(sqlite3_prepare_v2(appDelegate.database, sql3, -1, &update_statement, NULL) != SQLITE_OK)
			{
				NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(appDelegate.database));
			}
			
			sqlite3_bind_int(update_statement, 1, priority);
			sqlite3_bind_int(update_statement, 2, primaryKey);
			sqlite3_step(update_statement);
			sqlite3_reset(update_statement);
			sqlite3_finalize(update_statement);	
		}
		sqlite3_finalize(statement);	
	}
	
	//now update the priority of the row that moved
	const char *sql = "update todo set priority=? where pk=?;";
	if(sqlite3_prepare_v2(appDelegate.database, sql, -1, &update_statement, NULL) != SQLITE_OK)
	{
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(appDelegate.database));
	}
	int pk = ((Todo *)[appDelegate.todos objectAtIndex:fromCellRow]).primaryKey;
	//sqlite3_bind_int(update_statement, 1, toCell.todo.order);
	sqlite3_bind_int(update_statement, 1, toCellRow);
	//sqlite3_bind_int(update_statement, 2, fromCell.todo.primaryKey);
	sqlite3_bind_int(update_statement, 2, pk);
	sqlite3_step(update_statement);
	sqlite3_reset(update_statement);
	sqlite3_finalize(update_statement);
	
	[appDelegate updateTodos];
}*/
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

