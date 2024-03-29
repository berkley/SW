//
//  PRSettingsViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRSettingsViewController.h"

@implementation PRSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        
    }
    return self;
}

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
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                                          style:UIBarButtonItemStyleDone 
                                                                         target:self 
                                                                         action:@selector(doneButtonTouched)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.leftBarButtonItem = doneBarButtonItem;
    self.navigationItem.title = @"Settings";
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshServiceList) 
                                                 name:NOTIFICATION_REFRESH_SERVICE_LIST 
                                               object:nil];
    
    alertMessageCell = [[PRTextAreaTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                        reuseIdentifier:@"alertmessagecell"];
    [alertMessageCell setLabelText:@"Alert Message:"];
    
    testMessageCell = [[PRTextAreaTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                       reuseIdentifier:@"testmessagecell"];
    [testMessageCell setLabelText:@"Test Message:"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [alertMessageCell setTextViewText:[PRSession instance].alertMessage];
    [testMessageCell setTextViewText:[PRSession instance].testMessage];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [PRSession instance].alertMessage = alertMessageCell.textView.text;
    [PRSession instance].testMessage = testMessageCell.textView.text;
}

#pragma mark - selectors

- (void)doneButtonTouched
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)refreshServiceList
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else if(section == 1)
        return [[PRSession instance].services count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"Add a service";        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    }
    else if(indexPath.section == 1)
    {
        PRService *service = [[PRSession instance].services objectAtIndex:indexPath.row];
        if([service isKindOfClass:[PRFacebookService class]])
            cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
        else if([service isKindOfClass:[PRTwitterService class]])
            cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
        else if([service isKindOfClass:[PRSMSService class]])
            cell.imageView.image = [UIImage imageNamed:@"sms.png"];
        cell.imageView.frame = CGRectMake(0, 0, 10, 10);
        cell.textLabel.text = service.name;        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"";
    else if(section == 1)
        return @"Services";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        { //add new service
            PRNewServiceViewController *vc = [[PRNewServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.section == 1)
    {
        PRService *service = [[PRSession instance].services objectAtIndex:indexPath.row];
        if([service isKindOfClass:[PRFacebookService class]])
        {
            PRFacebookSettingsViewController *vc = [[PRFacebookSettingsViewController alloc] initWithNibName:@"PRFacebookSettingsViewController" bundle:nil];
            vc.service = (PRFacebookService*)service;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([service isKindOfClass:[PRSMSService class]])
        {
            PRSMSSettingsViewController *vc = [[PRSMSSettingsViewController alloc] initWithNibName:@"PRSMSSettingsViewController" bundle:nil];
            vc.service = (PRSMSService*)service;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([service isKindOfClass:[PRTwitterService class]])
        {
            PRTwitterSettingsViewController *vc = [[PRTwitterSettingsViewController alloc] initWithNibName:@"PRTwitterSettingsViewController" bundle:nil];
            vc.service = (PRTwitterService*)service;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
