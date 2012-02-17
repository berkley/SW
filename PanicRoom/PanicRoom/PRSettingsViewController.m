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
    
    testModeCell = [[PROnOffTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:@"testmodecell"];
    [testModeCell setLabelText:@"Test Mode:"];
    
    alertMessageCell = [[PRLabelTextFieldTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                        reuseIdentifier:@"alertmessagecell"];
    [alertMessageCell setLabelText:@"Alert Message:"];
    
    testMessageCell = [[PRLabelTextFieldTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                       reuseIdentifier:@"testmessagecell"];
    [testMessageCell setLabelText:@"Test Message:"];
    
    intervalCell = [[PRLabelTextFieldTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                    reuseIdentifier:@"intervalcell"];
    [intervalCell setLabelText:@"Interval (sec)"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [alertMessageCell setTextFieldText:[PRSession instance].alertMessage];
    [testMessageCell setTextFieldText:[PRSession instance].testMessage];
    [testModeCell setSwitchValue:[PRSession instance].testMode];
    [intervalCell setTextFieldText:[NSString stringWithFormat:@"%i", [PRSession instance].messageInterval]];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [PRSession instance].alertMessage = alertMessageCell.textField.text;
    [PRSession instance].testMessage = testMessageCell.textField.text;
    [PRSession instance].testMode = [testModeCell getSwitchValue];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([intervalCell.textField.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        [PRSession instance].messageInterval = [intervalCell.textField.text intValue];
    }
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
        return 4;
    else if(section == 1)
        return 1 + [[PRSession instance].services count];
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
        if(indexPath.row == 0)
            return testModeCell;
        else if(indexPath.row == 1)
            return testMessageCell;
        else if(indexPath.row == 2)
            return alertMessageCell;
        else if(indexPath.row == 3)
            return intervalCell;
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
            cell.textLabel.text = @"Add a service";
        else
        {
            PRService *service = [[PRSession instance].services objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = service.name;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Settings";
    else if(section == 1)
        return @"Registered Alerts";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        { //add new service
            PRNewServiceViewController *vc = [[PRNewServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        { //show details of current service
            PRService *service = [[PRSession instance].services objectAtIndex:indexPath.row - 1];
            if([service isKindOfClass:[PRFacebookService class]])
            {
                PRFacebookSettingsViewController *vc = [[PRFacebookSettingsViewController alloc] initWithNibName:@"PRFacebookSettingsViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

@end
