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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



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

