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
#import "InfoWindowViewController.h"

@implementation RootViewController

@synthesize infoButton;

UITextField *addField;
UIBarButtonItem *addButton;
ListViewController *lvc;
NSString *textFieldText;

- (void)loadInfoButton
{
	if(self.infoButton == nil)
	{
		self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];		
		[self.infoButton addTarget:self action:@selector(infoButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		self.infoButton.alpha = 0.6;
	}
	else 
	{
		[self.infoButton removeFromSuperview];
	}

	NSInteger x = [Session getScreenWidth] - 30;
	NSInteger y = [Session getScreenHeight] - 30;
	NSLog(@"adding info button at %i, %i", x, y);
	self.infoButton.frame = CGRectMake(x, y, 30, 30);
	[self.navigationController.view addSubview:self.infoButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
								   target:self action:@selector(editButtonPushed:)];
    self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
    self.navigationItem.title = @"Lists";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem = addButton;
	[addButton release];
	
	if([Session sharedInstance].lists == nil)
	{
		[Session sharedInstance].lists = [[NSMutableArray alloc] init];
	}
	
	[self loadInfoButton];
	
	[DBUtil loadLists];
}

- (void)infoButtonTouched:(id)sender
{
	NSLog(@"info button touched");
	InfoWindowViewController *infoWindowController = [[InfoWindowViewController alloc] init];
	[self.navigationController pushViewController:infoWindowController animated:YES];
	[self.infoButton removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self loadInfoButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
	addButton.enabled = YES;
	self.editButtonItem.enabled = YES;
}

- (void)openkeyboard:(id)sender
{
	NSLog(@"opening keyboard");
	[addField becomeFirstResponder];
}

//add an item, this is called when the add itme button is pushed
- (void)addItem:(id)sender 
{
	NSLog(@"add button pushed");
	addButton.enabled = NO;
	self.editButtonItem.enabled = NO;
	ItemList *list = [[ItemList alloc] initWithIdentifier:[NSNumber numberWithInt:-1]];
	[[Session sharedInstance].lists addObject:list];
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
	[self.navigationController setToolbarHidden:YES animated:YES];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Session sharedInstance].lists count];
}

//returns the index of the list with the same name or -1 if none exist with the same name
- (NSInteger) checkForDuplicateListName:(NSString*)name
{
	for(int i=0; i<[[Session sharedInstance].lists count]; i++)
	{
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:i];
		if([list.name isEqualToString:name])
		{
			return i;
		}
	}
	return -1;
}

//change teh name of a list with a given id
- (void)changeName:(NSString*)name id:(int)id
{
	for(int i=0; i<[[Session sharedInstance].lists count]; i++)
	{
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:i];
		if([list.identifier intValue] == id)
		{
			NSString *listName = list.name;
			if(![name isEqualToString:listName])
			{
				[list updateListName:name];
			}
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag > 50000)
	{
		int id = alertView.tag - 50000;
		if(buttonIndex == 0)
		{ //cancel
			
		}
		else if(buttonIndex == 1)
		{ //merge
			
		}
		else if(buttonIndex == 2)
		{ //new list
			[self changeName:textFieldText id:id];
		}
		[self.tableView reloadData];
	}
}

- (void)updateListName:(UITextField*)textField
{
	int id = textField.tag - 20000;
	textFieldText = textField.text;
	
	/*if([self checkForDuplicateListName:textField.text] != -1)
	 {
	 //ask if the user wants to merge the lists or create one with the same name
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Merge?" 
	 message:@"You have chosen a name that already exists.  Would you like to merge the two lists or create a new one with the same name?" 
	 delegate:self 
	 cancelButtonTitle:@"Cancel" 
	 otherButtonTitles:@"Merge Lists", @"New List", nil];
	 alert.tag = id + 50000;
	 [alert show];
	 }
	 else 
	 {*/
	[self changeName:textFieldText id:id];
	//}
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"text field with text %@ finished editing", textField.text);
	[self updateListName:textField];
}

- (void)editButtonPushed:(id)sender
{
	if(self.editing)
	{
		[self setEditing:NO animated:YES];
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
									   target:self action:@selector(editButtonPushed:)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		addButton.enabled = YES;
	}
	else 
	{
		[self setEditing:YES animated:YES];
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
									   target:self action:@selector(editButtonPushed:)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		if(!addButton.enabled)
		{
			NSMutableArray* paths = [[NSMutableArray alloc] init];
			[paths addObject:[NSIndexPath indexPathForRow:[[Session sharedInstance].lists count] - 1 inSection:0]];
			[[Session sharedInstance].lists removeLastObject];
			[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
			[paths release];
		}
		addButton.enabled = NO;
	}
	
	[self.tableView reloadData];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
	
	if(self.tableView.editing)
	{
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
		static NSString *EditingCellIdentifier = @"Cell";
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EditingCellIdentifier] autorelease];
		NSLog(@"creating editing cell");
		[cell.textLabel setTextColor:[UIColor whiteColor]];
		[cell.detailTextLabel setTextColor:[UIColor whiteColor]];
		cell.imageView.image = [UIImage imageNamed:@"ListIcon_80x80.png"];
		cell.imageView.frame = CGRectMake(0,0,30,30);
		//cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.textLabel.numberOfLines = 2;
		UITextField *editField = [[UITextField alloc] initWithFrame:CGRectMake(88, 25, 150, 30)];
		editField.tag = [list.identifier intValue] + 20000;
		editField.text = list.name;
		editField.borderStyle = UITextBorderStyleRoundedRect;
		//editField.textColor = [UIColor whiteColor];
		editField.returnKeyType = UIReturnKeyDone;
		editField.delegate = self;
		
		[cell.contentView addSubview:editField];
		[editField release];
		
		//label for number of undone items
		UILabel *notDoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, 25, 20)];
		notDoneLabel.alpha = 0;
		int notDone = [list.items count] - [[list numberDone] intValue];
		notDoneLabel.text = [NSString stringWithFormat:@"%i", notDone];
		notDoneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
		notDoneLabel.textColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
		[cell.contentView addSubview:notDoneLabel];
		[notDoneLabel release];
		
		//label for number of done items
		UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 44, 25, 20)];
		doneLabel.alpha = 0;
		doneLabel.text = [NSString stringWithFormat:@"%i", [[list numberDone] intValue]];
		doneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
		doneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
		[cell.contentView addSubview:doneLabel];
		[doneLabel release];
		
		doneLabel.alpha = 1;
		notDoneLabel.alpha = 1;
		doneLabel.textColor = [UIColor blackColor];
		notDoneLabel.textColor = [UIColor blackColor];
		return cell;
	}
	else 
	{
		static NSString *NormalCellIdentifier = @"Cell";
		static NSString *EditCellIdentifier = @"EditCell";
		ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
		
		if(cell == nil)
		{
			if([list.identifier intValue] == -1)
			{ //edit cell
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:EditCellIdentifier] autorelease];
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
			{ //normal cell
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NormalCellIdentifier] autorelease];
				NSLog(@"creating normal cell");
				cell.textLabel.text = list.name;
				[cell.textLabel setTextColor:[UIColor whiteColor]];
				[cell.detailTextLabel setTextColor:[UIColor whiteColor]];
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ of %i tasks complete", [list numberDone], [list.items count]];
				cell.imageView.image = [UIImage imageNamed:@"ListIcon_80x80.png"];
				cell.imageView.frame = CGRectMake(0,0,30,30);
				//cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.numberOfLines = 2;
				
				//label for number of undone items
				UILabel *notDoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, 25, 20)];
				notDoneLabel.alpha = 0;
				int notDone = [list.items count] - [[list numberDone] intValue];
				notDoneLabel.text = [NSString stringWithFormat:@"%i", notDone];
				notDoneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
				notDoneLabel.textColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
				[cell.contentView addSubview:notDoneLabel];
				[notDoneLabel release];
				
				//label for number of done items
				UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 44, 25, 20)];
				doneLabel.alpha = 0;
				doneLabel.text = [NSString stringWithFormat:@"%i", [[list numberDone] intValue]];
				doneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
				doneLabel.backgroundColor = [UIColor colorWithRed:0.980 green:0.643 blue:0.219 alpha:1.0];
				[cell.contentView addSubview:doneLabel];
				[doneLabel release];
				
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
				[UIView setAnimationDuration:.5];
				doneLabel.alpha = 1;
				notDoneLabel.alpha = 1;
				doneLabel.textColor = [UIColor blackColor];
				notDoneLabel.textColor = [UIColor blackColor];
				[UIView commitAnimations];
			}
		}
		else 
		{
			if([list.identifier intValue] == -1)
			{ //don't need to do anything here
				
			}
			else 
			{
				cell.textLabel.text = list.name;
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ of %i tasks complete", [list numberDone], [list.items count]];
			}
		}
		
		return cell;
	}
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField 
{
	NSLog(@"done editing");
    [textField resignFirstResponder]; 
	if(textField.tag > 20000)
	{
		[self updateListName:textField];
	}
	else 
	{
		[self newListItemButtonTouched:self];
	}
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
		[paths release];
	}
	ItemList *item = [[ItemList alloc] initWithName:addField.text];
	[[Session sharedInstance].lists addObject:item];
	[self.tableView reloadData];
    NSInteger row = [[Session sharedInstance].lists count] - 2;
    if (row < 0) {
        row = 0;
    }
	NSIndexPath *scrollToIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
	[self.tableView scrollToRowAtIndexPath:scrollToIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"List selected");
	if(!addButton.enabled)
	{
		return;
	}
	ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
	if([list.identifier intValue] == -1)
	{
		return;
	}
	lvc = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
	lvc.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self.navigationController pushViewController:lvc animated:YES];
	lvc.title = list.name;
	NSLog(@"selected list id %@", list.identifier);
	[Session sharedInstance].currentListId = list.identifier;
	[Session sharedInstance].itemList = list;
	/*for(int i=0; i<[list.items count]; i++)
	{
		NSLog(@"item: %@", [list.items objectAtIndex:i]);
	}*/
}

- (void)reloadListViewController
{
	NSLog(@"reloading list view controller");
	if(lvc != nil)
	{
		NSLog(@"lvc is not null...reloading");
		if(lvc.tableView != nil)
		{
			[lvc.tableView reloadData];
		}
		NSLog(@"done reloading lvc");
	}
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
		sqlite3_bind_int(update_statement2, 1, toCellRow);
		sqlite3_bind_int(update_statement2, 2, list_id);
		sqlite3_step(update_statement2);
		sqlite3_reset(update_statement2);
		NSLog(@"updated list %i with sort value %i", list_id, toCellRow);
	}
	else 
	{
		NSLog(@"Error updating moved cell.");
	}
	
	[DBUtil loadLists];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadInfoButton];
}

- (void)dealloc {
    [super dealloc];
}


@end

