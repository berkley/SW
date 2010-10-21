//
//  RootViewController.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright ucsb 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DBUtil.h"
#import "ItemList.h"
#import "ListViewController.h"
#import "Session.h"
#import "Item.h"
#import "ListOptionsViewController.h"

@implementation RootViewController

UITextField *addField;
UIBarButtonItem *addButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Simply Done";
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem = addButton;
	[addButton release];
	
	if([Session sharedInstance].lists == nil)
	{
		[Session sharedInstance].lists = [[NSMutableArray alloc] init];
	}
		
	[DBUtil loadLists];
}

- (void)openkeyboard:(id)sender
{
	NSLog(@"opening keyboard");
	[addField becomeFirstResponder];
}

- (void)addItem:(id)sender 
{
	NSLog(@"add button pushed");
	addButton.enabled = NO;
	self.editButtonItem.enabled = NO;
	[[Session sharedInstance].lists addObject:[[ItemList alloc] initWithIdentifier:[NSNumber numberWithInt:-1]]];
	[self.tableView reloadData];
	NSIndexPath *scrollToIndexPath = [NSIndexPath indexPathForRow:[[Session sharedInstance].lists count] - 1 inSection:0];
	[self.tableView scrollToRowAtIndexPath:scrollToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self performSelector:@selector(openkeyboard:) withObject:self afterDelay:.25];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0;
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.tableView reloadData];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Session sharedInstance].lists count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }*/
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	
	//check to see if the cell has a left over view from the create new item cell, 
	//if it does, remove it
	UIView *v = [cell.contentView viewWithTag:1];
	if(v != nil)
	{
		[v removeFromSuperview];
	}
	[v release];
    
    ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
	
	if([list.identifier intValue] == -1)
	{ //create a cell for adding content
		NSLog(@"creating new content cell");
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
		addField = [[UITextField alloc] initWithFrame:CGRectMake(5, 25, 250, 30)];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		addField.borderStyle = UITextBorderStyleRoundedRect;
		addField.delegate = self;
		addField.keyboardType = UIKeyboardTypeDefault;
		addField.returnKeyType = UIReturnKeyDone;
		//[addField becomeFirstResponder];
		button.backgroundColor = [UIColor blackColor];
		[button setTitle:@"Done" forState:UIControlStateNormal];	
		button.frame = CGRectMake(260, 25, 55, 30);
		[view addSubview:addField];
		[view addSubview:button];
		view.tag = 1;
		[cell.contentView addSubview:view];
		[button addTarget:self action:@selector(newListItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryType =  UITableViewCellAccessoryNone;
	}
	else 
	{ //create a normal cell
		NSLog(@"creating normal cell");
		cell.textLabel.text = list.name;
		[cell.textLabel setTextColor:[UIColor whiteColor]];
		[cell.detailTextLabel setTextColor:[UIColor whiteColor]];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ of %i tasks complete", [list numberDone], [list.items count]];
		cell.imageView.image = [UIImage imageNamed:@"ListIcon-80x80-on-black.png"];
		cell.imageView.frame = CGRectMake(0,0,30,30);
		cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.numberOfLines = 2;
	}

    return cell;
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField 
{
	NSLog(@"done editing");
    [textField resignFirstResponder]; 
	[self newListItemButtonTouched:self];
    return YES;
}

- (void)newListItemButtonTouched:(id)sender
{
	addButton.enabled = YES;
	self.editButtonItem.enabled = YES;
	if(addField.text == nil || [[addField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
	{ //don't add empty strings
		[[Session sharedInstance].lists removeLastObject];
		[self.tableView reloadData];
		return;
	}
	NSLog(@"New list item");
	[[Session sharedInstance].lists removeObjectAtIndex:[[Session sharedInstance].lists count] - 1];
	if([[Session sharedInstance].lists count] > 0)
	{
		NSMutableArray* paths = [[NSMutableArray alloc] init];
		[paths addObject:[NSIndexPath indexPathForRow:[[Session sharedInstance].lists count] - 1 inSection:0]];
		[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	}
	ItemList *item = [[ItemList alloc] initWithName:addField.text];
	[[Session sharedInstance].lists addObject:item];
	[self.tableView reloadData];
	NSIndexPath *scrollToIndexPath = [NSIndexPath indexPathForRow:[[Session sharedInstance].lists count] - 2 inSection:0];
	[self.tableView scrollToRowAtIndexPath:scrollToIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"List selected");
	ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
	if([list.identifier intValue] == -1)
	{
		return;
	}
	ListViewController *lvc = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
	[self.navigationController pushViewController:lvc animated:YES];
	lvc.title = list.name;
	NSLog(@"selected list id %@", list.identifier);
	[Session sharedInstance].currentListId = list.identifier;
	[Session sharedInstance].itemList = list;
	for(int i=0; i<[list.items count]; i++)
	{
		NSLog(@"item: %@", [list.items objectAtIndex:i]);
	}
	[lvc release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Accessory button tapped.");
	ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
	ListOptionsViewController *lovc = [[ListOptionsViewController alloc]initWithNibName:@"ListOptionsViewController" bundle:nil];
	[Session sharedInstance].itemList = list;
	[Session sharedInstance].currentListId = list.identifier;
	[self.navigationController pushViewController:lovc animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
	if([list.identifier intValue] == -1)
	{
		return NO;
	}
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
		[list delete];
		[[Session sharedInstance].lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    ItemList *list = [[Session sharedInstance].lists objectAtIndex:fromCellRow];
	int list_id = [list.identifier intValue];
	NSLog(@"fromCell: %i, toCell: %i", fromCellRow, toCellRow);
	NSLog(@"moving list with id %i", list_id);
	const char *sql;
	if(fromCellRow > toCellRow)
	{
		sql = "select id, sort from lists where sort >= ? and sort <= ?";
	}
	else 
	{
		sql = "select id, sort from lists where sort <= ? and sort >= ?";
	}
	
	if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_bind_int(statement, 1, toCellRow);
		sqlite3_bind_int(statement, 2, fromCellRow);
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			int l_id = sqlite3_column_int(statement, 0);
			int item_sort = sqlite3_column_int(statement, 1);
			if(fromCellRow > toCellRow)
			{
				item_sort++;					
			}
			else
			{
				item_sort--;
			}
			
			const char *update_sql = "update lists set sort = ? where id = ?";
			if(sqlite3_prepare_v2(db, update_sql, -1, &update_statement, NULL) == SQLITE_OK)
			{
				NSLog(@"updating list %i with sort value %i", l_id, item_sort);
				sqlite3_bind_int(update_statement, 1, item_sort);
				sqlite3_bind_int(update_statement, 2, l_id);
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
	const char *update_sql = "update lists set sort = ? where id = ?";
	sqlite3_stmt *update_statement2;
	if(sqlite3_prepare_v2(db, update_sql, -1, &update_statement2, NULL) == SQLITE_OK)
	{
		Item *i = [[Session sharedInstance].itemList.items objectAtIndex:fromCellRow];
		int item_id = [i.id intValue];
		sqlite3_bind_int(update_statement2, 1, toCellRow);
		sqlite3_bind_int(update_statement2, 2, list_id);
		sqlite3_step(update_statement2);
		sqlite3_reset(update_statement2);
		NSLog(@"updated list %i with sort value %i", item_id, toCellRow);
	}
	else 
	{
		NSLog(@"Error updating moved cell.");
	}
	
	[DBUtil loadLists];
}

- (void)dealloc {
    [super dealloc];
}


@end

