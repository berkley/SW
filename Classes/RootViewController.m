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

@implementation RootViewController

NSMutableArray* lists;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Simply Done";
    
    lists = [[NSMutableArray alloc] init];
    NSArray* listIds = [DBUtil getListIds];
    for(int i=0; i<[listIds count]; i++)
    {
        NSNumber *listId = [listIds objectAtIndex:i];
        [lists addObject:[[ItemList alloc] initWithIdentifier:listId]];
        NSLog(@"adding list %@", listId);
    }
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
    return [lists count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ItemList *list = [lists objectAtIndex:indexPath.row];
	
    cell.textLabel.text = list.name;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
	[cell.detailTextLabel setTextColor:[UIColor whiteColor]];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ of %i tasks complete", [list numberDone], [list.items count]];
    cell.imageView.image = [UIImage imageNamed:@"ListIcon-80x80-on-black.png"];
	cell.imageView.frame = CGRectMake(0,0,30,30);
	cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"List selected");
	ItemList *list = [lists objectAtIndex:indexPath.row];
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
	ItemList *list = [lists objectAtIndex:indexPath.row];
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

