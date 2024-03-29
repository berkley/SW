//
//  ListViewController.m
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 Chad Berkley. All rights reserved.
//

#import "ListViewController.h"
#import "Session.h"
#import "Item.h"
#import "ItemList.h"
#import "DBUtil.h"
#import "InfoWindowViewController.h"

@implementation ListViewController

@synthesize infoButton;

#pragma mark -
#pragma mark View lifecycle

UITextField *addField;
BOOL doneButtonTouched;
int cellCountAdder;
UIToolbar *toolBar;
UITextField	*editingTextField;

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

- (void)infoButtonTouched:(id)sender
{
	NSLog(@"info button touched");
	InfoWindowViewController *infoWindowController = [[InfoWindowViewController alloc] init];
	[self.navigationController pushViewController:infoWindowController animated:YES];
	[self.infoButton removeFromSuperview];
}

- (NSArray*)createToolbarButtonArray
{
	
	UIBarButtonItem *fixedSpacebutton = [[UIBarButtonItem alloc]
										 initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	
	UIBarButtonItem *resetDoneItem = [[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
									  target:self action:@selector(resetButtonItemTouched:)];
	resetDoneItem.title = @"Reset";
	
	UIBarButtonItem *sortByDoneItem = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize 
									   target:self action:@selector(sortByDoneItemTouched:)];
	sortByDoneItem.title = @"Sort";
	
	UIBarButtonItem *emailItem = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
								  target:self action:@selector(emailItemTouched:)];
	emailItem.title = @"Email";
	
	UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
								   target:self action:@selector(deleteItemTouched:)];
	deleteItem.title = @"Delete";
		
	if([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait ||
	   [UIDevice currentDevice].orientation == UIInterfaceOrientationPortraitUpsideDown ||
	   [UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp ||
	   [UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown)
	{
		fixedSpacebutton.width = 63;
		NSArray *arr = [NSArray arrayWithObjects:resetDoneItem, fixedSpacebutton, 
						sortByDoneItem, fixedSpacebutton,
						emailItem, fixedSpacebutton,
						deleteItem,
						nil];
		[fixedSpacebutton release];
		[resetDoneItem release];
		[sortByDoneItem release];
		[emailItem release];
		[deleteItem release];
		return arr;
	}
	else 
	{
		fixedSpacebutton.width = 67;
		NSArray *arr = [NSArray arrayWithObjects:fixedSpacebutton, resetDoneItem, fixedSpacebutton, 
						sortByDoneItem, fixedSpacebutton,
						emailItem, fixedSpacebutton,
						deleteItem,
						nil];
		[fixedSpacebutton release];
		[resetDoneItem release];
		[sortByDoneItem release];
		[emailItem release];
		[deleteItem release];
		return arr;
	}
}

- (void)addToolbar
{
	NSArray *toolBarArray = [self createToolbarButtonArray];
	[self setToolbarItems:toolBarArray animated:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];
	self.navigationController.toolbar.barStyle = UIBarStyleBlack;	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
								   target:self action:@selector(editButtonPushed:)];
    self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	cellCountAdder = 1;
	doneButtonTouched = YES;

	[self addToolbar];
	if([Session sharedInstance].useSingleListInterface)
	{
		[self loadInfoButton];		
	}

}

- (void)viewWillAppear:(BOOL)animated
{
	[self addToolbar];
	if([Session sharedInstance].useSingleListInterface)
	{
		[self loadInfoButton];		
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)resetButtonItemTouched:(id)sender
{
	[self.navigationController setToolbarHidden:YES animated:YES];
	NSLog(@"resetButtonItemTouched button touched.");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"List Options" 
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Reset Completed Items", @"Duplicate List", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 900;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)sortByDoneItemTouched:(id)sender
{
	[self.navigationController setToolbarHidden:YES animated:YES];
	NSLog(@"sortByDoneItemTouched button touched.");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort List Items" 
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Completed First", @"Completed Last", @"Alphabetical", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 901;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)emailItemTouched:(id)sender
{
	[self.navigationController setToolbarHidden:YES animated:YES];
	NSLog(@"emailItemTouched button touched.");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Email List" 
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Email Plain Text", @"Email Attachment", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 902;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)deleteItemTouched:(id)sender
{
	[self.navigationController setToolbarHidden:YES animated:YES];
	NSLog(@"deleteItemTouched button touched.");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete List Items" 
															 delegate:self cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Delete All Items", @"Delete Completed Items", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 903;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Touched button %i of action sheet %i", buttonIndex, actionSheet.tag);
	if(actionSheet.tag == 900)
	{
		if(buttonIndex == 0)
		{ //reset completed items
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
															message:@"Are you sure you want to reset all of your completed items?" 
														   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			alert.tag = 906;
			[alert show];
		}
		else if(buttonIndex == 1)
		{ //duplicate list
			NSString *name = [[Session sharedInstance].itemList.name stringByAppendingString:@" Copy"];
			NSLog(@"copying list to name %@", name);
			[[Session sharedInstance].itemList duplicate:name];
			[DBUtil loadLists];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	else if(actionSheet.tag == 901)
	{ //sort
		if(buttonIndex == 0)
		{ //done first
			[[Session sharedInstance].itemList sortItemsByDone:YES];
			[DBUtil loadLists];
			[self.tableView reloadData];
		}
		else if(buttonIndex == 1)
		{ //done last
			[[Session sharedInstance].itemList sortItemsByDone:NO];
			[DBUtil loadLists];
			[self.tableView reloadData];
		}		
		else if(buttonIndex == 2)
		{ //alpha
			[[Session sharedInstance].itemList sortItemsByAlpha];
			[DBUtil loadLists];
			[self.tableView reloadData];
		}
	}
	else if(actionSheet.tag == 902)
	{ //email
		if(buttonIndex == 0)
		{ //email plain text
			[[Session sharedInstance] emailPlainTextList:self viewController:self];
		}
		else if(buttonIndex == 1)
		{ //simply done file
			[[Session sharedInstance] emailSDList:self viewController:self];
		}
	}
	else if(actionSheet.tag	== 903)
	{ //delete
		if(buttonIndex == 0)
		{ //delete all
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
																message:@"Are you sure you want to delete all items from the list?" 
															   delegate:self 
													  cancelButtonTitle:@"No" 
													  otherButtonTitles:@"Yes", nil];
			alertView.tag = 904;
			[alertView show];
		}
		else if(buttonIndex == 1)
		{ //delete done only
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
																message:@"Are you sure you want to delete all completed items from the list?" 
															   delegate:self 
													  cancelButtonTitle:@"No" 
													  otherButtonTitles:@"Yes", nil];
			alertView.tag = 905;
			[alertView show];
		}
	}
	
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	[self dismissModalViewControllerAnimated:YES];
	[self addToolbar];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 906)
	{ //deselect all X items
		if(buttonIndex == 1)
		{  //NO (cancel) is 0, YES is 1
			for(int i=0; i<[[Session sharedInstance].itemList.items count]; i++)
			{
				Item *item = [[Session sharedInstance].itemList.items objectAtIndex:i];
				if([item.done intValue] == 1)
				{
					NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
					[self tableView:self.tableView didSelectRowAtIndexPath:ip];					
				}
			}
		}
	}
	else if(alertView.tag == 904)
	{ //delete all items
		if(buttonIndex == 1)
		{
			[[Session sharedInstance].itemList deleteAllItems];
			[self.tableView reloadData];			
		}
	}
	else if(alertView.tag == 905)
	{ //delete done items
		if(buttonIndex == 1)
		{
			[[Session sharedInstance].itemList deleteAllDoneItems];
			[self.tableView reloadData];
		}
	}
	[alertView release];
}

- (void)editButtonPushed:(id)sender
{
	if(self.editing)
	{
		cellCountAdder = 1;
		[self setEditing:NO animated:YES];
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
									   target:self action:@selector(editButtonPushed:)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];

		NSIndexPath *ip = [NSIndexPath indexPathForRow:[[Session sharedInstance].itemList.items count] inSection:0];
		NSArray *arr = [NSArray arrayWithObjects:ip, nil];
		[self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
	}
	else 
	{
		cellCountAdder = 0;
		[self setEditing:YES animated:YES];
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
									   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
									   target:self action:@selector(editButtonPushed:)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		
		NSIndexPath *ip = [NSIndexPath indexPathForRow:[[Session sharedInstance].itemList.items count] inSection:0];
		NSArray *arr = [NSArray arrayWithObjects:ip, nil];
		[self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
	}
	//[DBUtil loadLists];
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSArray *buttonArray = [self createToolbarButtonArray];
	[self.navigationController.toolbar setItems:buttonArray animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
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
	}
	else 
	{ //no longer in editing mode
		NSLog(@"no longer editing");
	}
}

- (void)scrollToIndexPath:(NSIndexPath*)indexPath
{
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	editingTextField = textField;
}

- (void)scrollToActiveTextField
{
	NSIndexPath *indexPath;
	if(editingTextField.tag == -1)
	{ //addField text field
		int index = [self.tableView numberOfRowsInSection:0] - 1;
		indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	}
	else 
	{ //field editor text fields
		//indexPath = [self.tableView indexPathForRowAtPoint:editingTextField.frame.origin];
		UITableViewCell *cell = (UITableViewCell*)editingTextField.superview.superview.superview;
		indexPath = [self.tableView indexPathForCell:cell];
	}
		 
	[self performSelector:@selector(scrollToIndexPath:) withObject:indexPath afterDelay:.5];
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
	[self scrollToActiveTextField];
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

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up
{
	NSLog(@"changing frame size for keyboard");
	NSDictionary* userInfo = [aNotification userInfo];
	CGRect keyboardEndFrame;
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	CGRect newFrame = self.view.frame;
	CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	newFrame.size.height -= (keyboardFrame.size.height - self.navigationController.navigationBar.frame.size.height) * (up? 1 : -1);
	self.view.frame = newFrame;
}	


- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    [self moveTextViewForKeyboard:aNotification up:YES];
	[self scrollToActiveTextField];

}

- (void)keyboardWillHide:(NSNotification *)aNotification 
{
	[self moveTextViewForKeyboard:aNotification up:NO]; 
	[self scrollToActiveTextField];
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
				[view release];
			}
			UITextField *addField = (UITextField*)[self.view viewWithTag:-1];
			addField.text = @"";
			[self performSelector:@selector(makeEditCellFirstResponder:) withObject:self afterDelay:.5];
		}
		else
		{ //normal cell
			cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
			/*for(int i=0; i<[[Session sharedInstance].itemList.items count]; i++)
			{
				Item *it = [[Session sharedInstance].itemList.items objectAtIndex:i];
				NSLog(@"item id: %@ desc: %@ list_id: %@", it.id, it.description, it.list_id);
			}*/
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
				//NSLog(@"reusing cell for item %@ with id %@ and sort %@ and done %@", item.description, item.id, item.sort, item.done);
				cell.textLabel.text = item.description;
				NSArray* subviews = [cell.imageView subviews];
				for(int i=0; i<[subviews count]; i++)
				{
					UIView *view = [subviews objectAtIndex:i];
					if([view isKindOfClass:[UIImageView class]])
					{
						[view removeFromSuperview];
					}
					//[view release];
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
			editField.borderStyle = UITextBorderStyleRoundedRect;
//			editField.textColor = [UIColor whiteColor];
			editField.returnKeyType = UIReturnKeyDone;
			editField.delegate = self;
			cell.tag = [item.id intValue];
			[view addSubview:editField];
			[editField release];
			[cell.contentView addSubview:view];
			[view release];
			
			if([item.done intValue] > 0)
			{
				UIImage *image = [UIImage imageNamed:@"CheckedBox_40x40.png"];
				cell.imageView.image = image;
			}
			else 
			{
				UIImage *image = [UIImage imageNamed:@"UnCheckedBox_40x40.png"];
				cell.imageView.image = image;
			}
		}
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
		[[Session sharedInstance].itemList deleteItem:item.id]; 
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
/*	for(int i=0; i<[self.tableView numberOfRowsInSection:0]; i++)
	{
		NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
		NSLog(@"item with id %i is now sorted to row %i", cell.tag, i);
	}*/
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
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

