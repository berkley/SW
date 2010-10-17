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

@implementation RootViewController

UITextField *addField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Simply Done";
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem = addButton;
	[addButton release];
	
	if([Session sharedInstance].lists == nil)
	{
		[Session sharedInstance].lists = [[NSMutableArray alloc] init];
	}
	
    NSArray* listIds = [DBUtil getListIds];
    for(int i=0; i<[listIds count]; i++)
    {
        NSNumber *listId = [listIds objectAtIndex:i];
        [[Session sharedInstance].lists addObject:[[ItemList alloc] initWithIdentifier:listId]];
        NSLog(@"adding list %@", listId);
    }
}

- (void)addItem:(id)sender 
{
	NSLog(@"add button pushed");
	[[Session sharedInstance].lists addObject:[[ItemList alloc] initWithIdentifier:[NSNumber numberWithInt:-1]]];
	[self.tableView reloadData];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
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
		addField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 250, 75)];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		addField.borderStyle = UITextBorderStyleRoundedRect;
		button.backgroundColor = [UIColor blackColor];
		[button setTitle:@"Done" forState:UIControlStateNormal];	
		button.frame = CGRectMake(260, 28, 55, 30);
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
	}

    return cell;
}

- (void)newListItemButtonTouched:(id)sender
{
	NSLog(@"New list item");
	[[Session sharedInstance].lists removeObjectAtIndex:[[Session sharedInstance].lists count] - 1];
	NSMutableArray* paths = [[NSMutableArray alloc] init];
	[paths addObject:[NSIndexPath indexPathForRow:[[Session sharedInstance].lists count] - 1 inSection:0]];
	[self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	ItemList *item = [[ItemList alloc] initWithName:addField.text];
	[[Session sharedInstance].lists addObject:item];
	[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"List selected");
	ItemList *list = [[Session sharedInstance].lists objectAtIndex:indexPath.row];
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
	//TODO: put code here for showing the options for the list
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    
}



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

