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
BOOL doneButtonTouched;
UIBarButtonItem *editButton;
int cellCountAdder;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPushed:)];
    self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	cellCountAdder = 1;
	doneButtonTouched = YES;
}

- (void)editButtonPushed:(id)sender
{
	if(self.editing)
	{
		cellCountAdder = 1;
		[self setEditing:NO animated:YES];
		[editButton setStyle:UIBarButtonItemStylePlain];
	}
	else 
	{
		cellCountAdder = 0;
		[self setEditing:YES animated:YES];
		[editButton setStyle:UIBarButtonItemStyleDone];
	}
	[DBUtil loadLists];
	[self.tableView reloadData];
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
	NSLog(@"%i cells being rendered", [[Session sharedInstance].itemList.items count] + cellCountAdder);
	return [[Session sharedInstance].itemList.items count] + cellCountAdder;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}	

- (void)reload:(id)sender
{
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	if(editing)
	{ //going into editing mode
		NSLog(@"editing");
		//[self.tableView reloadData];
	}
	else 
	{ //no longer in editing mode
		NSLog(@"no longer editing");
		//make sure all change text boxes get updated
		/*for(int i=0; i<[[Session sharedInstance].itemList.items count]; i++)
		{
			Item *item = [[Session sharedInstance].itemList.items objectAtIndex:i];
			NSObject *obj = [self.view viewWithTag:[item.id intValue] + 99];
			NSLog(@"updating item %@ after editing with text %@", item.id, item.description);
			if([obj isKindOfClass:[UITextField class]])
			{
				UITextField *field = (UITextField*)obj;
				NSString *fieldText = field.text;
				
				NSString *descText = item.description;
				NSLog(@"fieldText: %@ descText: %@", fieldText, descText);
				if(![fieldText isEqualToString:descText])
				{
					NSLog(@"Updating item description");
					[[Session sharedInstance].itemList updateItemDescription:fieldText withId:item.id];
				}
			}
			else 
			{
				NSLog(@"ERROR: field not updated because the textField is not of class UITextField");
			}

		}*/
		//[self.tableView reloadData];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"text field with text %@ finished editing", textField.text);
	int id = textField.tag - 99;
	for(int i=0; i<[[Session sharedInstance].itemList.items count]; i++)
	{
		Item *item = [[Session sharedInstance].itemList.items objectAtIndex:i];
		if([item.id intValue] == id)
		{
			NSString *fieldText = textField.text;
			NSString *descText = item.description;
			NSLog(@"fieldText: %@ descText: %@", fieldText, descText);
			if(![fieldText isEqualToString:descText])
			{
				NSLog(@"Updating item description");
				[[Session sharedInstance].itemList updateItemDescription:fieldText withId:item.id];
			}
			break;
		}
	}
}

-(void) addNewCell
{
	if(addField.text == nil || [[addField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
	{
		return;
	}
	NSLog(@"Add button pushed. text: %@", addField.text);
	[[Session sharedInstance].itemList addItem:addField.text];
	NSLog(@"There are now %i items in the shared item list", [[Session sharedInstance].itemList.items count]);
	UITextField *field = (UITextField*)[self.view viewWithTag:-1];
	field.text = @"";
	[self.tableView reloadData];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField 
{
	doneButtonTouched = YES;
	if(textField.tag == -1)
	{
		NSLog(@"done editing the addField");
		[textField resignFirstResponder]; 
		[self addNewCell];
		return YES;
	}
	else 
	{
		NSLog(@"done editing with text field tag %i", textField.tag);
		[textField resignFirstResponder]; 
		return YES;
	}
	doneButtonTouched = YES;
}

- (void) makeEditCellFirstResponder:(id)responder
{
	if(!doneButtonTouched)
	{
		UITextField *field = (UITextField*)[self.view viewWithTag:-1];
		[field becomeFirstResponder];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	NSLog(@"loading data for cells.  There are %i items in the items array", [[Session sharedInstance].itemList.items count]);
    static NSString *NormalCellIdentifier = @"Cell";
	static NSString *EditCellIdentifier = @"EditCell";
	static NSString *ChangeCellIdentifier = @"ChangeCell";
    UITableViewCell *cell = nil;
	
    if(!self.tableView.editing)
	{ //normal cells (not editing)
		if(indexPath.row == [[Session sharedInstance].itemList.items count])
		{ //edit cell
			cell = [tableView dequeueReusableCellWithIdentifier:ChangeCellIdentifier];
			if(cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChangeCellIdentifier] autorelease];
				NSLog(@"creating ChangeCell");
				UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
				
				addField = [[UITextField alloc] initWithFrame:CGRectMake(5, 4, 275, 31)];
				addField.borderStyle = UITextBorderStyleRoundedRect;
				addField.keyboardType = UIKeyboardTypeDefault;
				addField.returnKeyType = UIReturnKeyDone;
				addField.tag = -1;
				addField.delegate = self;
				[view addSubview:addField];
				
				UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
				button.frame = CGRectMake(285, 3, 31, 31);
				[view addSubview:button];
				[button addTarget:self action:@selector(newItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
				[cell.contentView addSubview:view];
			}
			UITextField *addField = (UITextField*)[self.view viewWithTag:-1];
			addField.text = @"";
			[self performSelector:@selector(makeEditCellFirstResponder:) withObject:self afterDelay:.5];
		}
		else
		{ //normal cell
			cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
			Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
			if(cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellIdentifier] autorelease];
				NSLog(@"creating NormalCell");	
				NSLog(@"adding cell for item %@ with id %@ and sort %@", item.description, item.id, item.sort);
				cell.textLabel.text = item.description;
				cell.textLabel.minimumFontSize = 8;
				[cell.textLabel adjustsFontSizeToFitWidth];
				[cell.textLabel setTextColor:[UIColor whiteColor]];
				cell.imageView.image = [UIImage imageNamed:@"UnCheckedBox_40x40.png"];
				UIImageView *xView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrangeX_40x40.png"]];
				xView.tag = [item.id intValue] + 1000;
				[cell.imageView addSubview:xView];
				if([item.done intValue] > 0)
				{
					xView.alpha = 1;
				}
				else 
				{
					xView.alpha = 0;
				}
			}
			else 
			{
				NSLog(@"reusing NormalCell");
				NSLog(@"reusing cell for item %@ with id %@ and sort %@ and done %@", item.description, item.id, item.sort, item.done);
				cell.textLabel.text = item.description;
				NSArray* subviews = [cell.imageView subviews];
				for(int i=0; i<[subviews count]; i++)
				{
					UIView *view = [subviews objectAtIndex:i];
					if([view isKindOfClass:[UIImageView class]])
					{
						[view removeFromSuperview];
					}
					[view release];
				}
				UIImageView *xView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrangeX_40x40.png"]];
				xView.tag = [item.id intValue] + 1000;
				[cell.imageView addSubview:xView];
				if([item.done intValue] > 0)
				{
					xView.alpha = 1;
				}
				else 
				{
					xView.alpha = 0;
				}
			}
		}
	}
	else 
	{ //editing cells
		cell = [tableView dequeueReusableCellWithIdentifier:EditCellIdentifier];
		Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
		//if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EditCellIdentifier] autorelease];
			NSLog(@"creating EditCell");
			NSLog(@"adding editing cell for item with id %@ with sort %@", item.id, item.sort);
			UIView *view = [[UIView alloc]initWithFrame:CGRectMake(45, 5, 200, 35)];
			UITextField *editField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
			editField.tag = [item.id intValue] + 99;
			editField.text = item.description;
			editField.borderStyle = UITextBorderStyleNone;
			editField.textColor = [UIColor whiteColor];
			editField.returnKeyType = UIReturnKeyDone;
			editField.delegate = self;
			//[editField retain];
			[view addSubview:editField];
			[cell.contentView addSubview:view];
			
			if([item.done intValue] > 0)
			{
				cell.imageView.image = [UIImage imageNamed:@"CheckedBox_40x40.png"];		
			}
			else 
			{
				cell.imageView.image = [UIImage imageNamed:@"UnCheckedBox_40x40.png"];
			}
		}
		/*else 
		{
			NSLog(@"reusing EditCell for item: %@", item.description);
			//UITextField *editField = (UITextField*)[self.view viewWithTag:[item.id intValue] + 99];
			UITextField *editField;
			for(int i=0; i<[cell.contentView.subviews count]; i++)
			{
				NSLog(@"looking for editField");
				NSObject *obj = [cell.contentView.subviews objectAtIndex:i];
				if([obj isKindOfClass:[UITextField class]])
				{
					editField = (UITextField*)obj;
					break;
				}
			}
			if(editField == nil)
			{
				NSLog(@"ERROR!  EditField is nil");
			}
			editField.tag = [item.id intValue] + 99;
			editField.text = item.description;
			if([item.done intValue] > 0)
			{
				cell.imageView.image = [UIImage imageNamed:@"CheckedBox_40x40.png"];		
			}
			else 
			{
				cell.imageView.image = [UIImage imageNamed:@"UnCheckedBox_40x40.png"];
			}
		}*/
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSLog(@"returning cell");
    return cell;
}

-(void)newItemButtonTouched:(id)sender
{
	doneButtonTouched = NO;
	[self addNewCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.row >= [[Session sharedInstance].itemList.items count])
	{
		return;
	}
	Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
	[item touched];
	NSLog(@"item %@ touched with id %@ and sort %@ and done %@", item.description, item.id, item.sort, item.done);
	int tag = [item.id intValue] + 1000;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:.25];
	//cell.imageView.alpha = 1;
	if([item.done intValue] > 0)
	{
		[self.view viewWithTag:tag].alpha = 1;		
	}
	else 
	{
		[self.view viewWithTag:tag].alpha = 0;
	}

	[UIView commitAnimations];
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"deleting row at indexPath %i", indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		Item *item = [[Session sharedInstance].itemList.items objectAtIndex:indexPath.row];
		[item deleteItem];
		[[Session sharedInstance].itemList.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
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
				NSLog(@"updating item with id %i with sort value %i", item_id, item_sort);
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

