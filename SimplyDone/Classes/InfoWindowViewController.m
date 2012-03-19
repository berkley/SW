    //
//  InfoWindowViewController.m
//  Simply Done
//
//  Created by Chad Berkley on 12/6/10.
//  Copyright 2010 Chad Berkley. All rights reserved.
//

#import "InfoWindowViewController.h"
#import "Session.h"

@implementation InfoWindowViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIImage *backgroundImage = [UIImage imageNamed:@"Default-iPad.png"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	bgImageView.alpha = 0.2;
	bgImageView.frame = CGRectMake(0, 0, [Session getScreenWidth], [Session getScreenHeight]);
	[self.view addSubview:bgImageView];
	[backgroundImage release];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.navigationItem.title = @"About";
	
	UITextView *aboutTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, [Session getScreenWidth] - 20, 200)];
	aboutTextView.editable = NO;
	aboutTextView.backgroundColor = [UIColor clearColor];
	aboutTextView.textColor = [UIColor whiteColor];
	aboutTextView.font = [UIFont fontWithName:@"Arial" size:16];
	aboutTextView.text = @"Simply Done v2.0 is developed by Chad Berkley.  Please direct any bug reports, complaints or compliments to cberkley@gmail.com.  I hope you enjoy using Simply Done.  \n\n I have included the following switch for those of you who prefer the Simply Done v1.0 interface.  When switched on, Simply Done will only show your first list.  You can always get back to the multi-list view by turning the switch off.";
	[self.view addSubview:aboutTextView];
	[aboutTextView release];
	
	UISwitch *singleListSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 220, 100, 30)];
	[singleListSwitch addTarget:self action:@selector(singleListSwitchFlipped:) forControlEvents:UIControlEventValueChanged];
	singleListSwitch.on = NO;
	if([Session sharedInstance].useSingleListInterface)
	{
		singleListSwitch.on = YES;
	}
	[self.view addSubview:singleListSwitch];
	[singleListSwitch release];
																			 
	UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 200, 30)];
	switchLabel.backgroundColor = [UIColor clearColor];
	switchLabel.textColor = [UIColor whiteColor];
	switchLabel.text = @"Single List Interface:";
	[self.view addSubview:switchLabel];
	[switchLabel release];
}

- (void)singleListSwitchFlipped:(id)sender
{
	if([Session sharedInstance].useSingleListInterface)
	{
		[Session sharedInstance].useSingleListInterface = NO;
	}
	else 
	{
		[Session sharedInstance].useSingleListInterface = YES;
	}

	[[Session sharedInstance] writeUserDefaults];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
