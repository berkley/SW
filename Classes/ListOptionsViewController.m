//
//  ListOptionsViewController.m
//  Simply Done
//
//  Created by Chad Berkley on 10/21/10.
//  Copyright 2010 UCSB. All rights reserved.
//


#import "ListOptionsViewController.h"
#import "Session.h"

@implementation ListOptionsViewController

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(section == 0)
	{
		return 2;
	}
	else 
	{
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return @"List Options";
	}
	else 
	{
		return @"Email Options";
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0)
		{
			//cell.textLabel.text = @"Delete This List";
			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.frame = CGRectMake(55, 8, 200, 30);
			[button setTitle:@"Delete All Items" forState:UIControlStateNormal];
			[button addTarget:self action:@selector(deleteList:) forControlEvents:UIControlEventTouchUpInside];		
			[cell.contentView addSubview:button];
		}
		else
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.frame = CGRectMake(55, 8, 200, 30);
			[button setTitle:@"Delete All Finished Items" forState:UIControlStateNormal];
			[cell.contentView addSubview:button];
			[button addTarget:self action:@selector(deleteAllDone:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
	else if(indexPath.section == 1)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:@"Send" forState:UIControlStateNormal];
		button.frame = CGRectMake(55, 8, 200, 30);
		[button addTarget:self action:@selector(emaillist:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:button];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (IBAction)emaillist:(id)sender
{
	NSLog(@"emailing plain text list");
	[[Session sharedInstance] emailPlainTextList:self viewController:self];
}

- (IBAction)emailSDlist:(id)sender
{
	NSLog(@"emailing SD list");
	[[Session sharedInstance] emailSDList:self viewController:self];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deleteAllDone:(id)sender
{
	NSLog(@"deleteing all done items");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete List Items" message:@"Are you sure you want to delete all of the finished list items?" 
												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	alert.tag = 1000;
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1000)
	{
		NSLog(@"button index: %i", buttonIndex);
		if(buttonIndex == 1)
		{  //NO is 0, YES is 1
			NSLog(@"number done to be removed: %@ of %i", 
				  [[Session sharedInstance].itemList numberDone], [[Session sharedInstance].itemList.items count]);
			[[Session sharedInstance].itemList deleteAllDoneItems];
		}
	}
	else if(alertView.tag == 1001)
	{
		if(buttonIndex == 1)
		{
			[[Session sharedInstance].itemList deleteAllItems];
		}
	}
	else if(alertView.tag == 1002)
	{
		if(buttonIndex == 1)
		{
			[[Session sharedInstance].itemList resetAllItems];
		}
	}

}

- (IBAction)deleteList:(id)sender
{
	NSLog(@"deleting all items");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete List Items" message:@"Are you sure you want to delete all of the list items?" 
												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	alert.tag = 1001;
	[alert show];
}

- (IBAction)resetAllItems:(id)sender
{
	//reset all items to not done
	NSLog(@"deleting all items");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset List Items" message:@"Are you sure you want to reset all list items to 'not done'?" 
												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	alert.tag = 1002;
	[alert show];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
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

