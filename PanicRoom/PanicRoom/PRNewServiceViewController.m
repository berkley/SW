//
//  PRNewServiceViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRNewServiceViewController.h"


@implementation PRNewServiceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Add Service";
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
        cell.textLabel.text = @"Facebook";
    else if(indexPath.row == 1)
        cell.textLabel.text = @"Twitter";
    else if(indexPath.row == 2)
        cell.textLabel.text = @"SMS";
    else if(indexPath.row == 3)
        cell.textLabel.text = @"Email";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRCreateServiceViewController *vc = [[PRCreateServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if(indexPath.row == 0)
        vc.serviceType = SERVICE_TYPE_FACEBOOK;
    else if(indexPath.row == 1)
        vc.serviceType = SERVICE_TYPE_TWITTER;
    else if(indexPath.row == 2)
        vc.serviceType = SERVICE_TYPE_SMS;
    else if(indexPath.row == 3)
        vc.serviceType = SERVICE_TYPE_EMAIL;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
