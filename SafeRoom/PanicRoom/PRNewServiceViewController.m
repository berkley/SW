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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Facebook";
        cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"SMS";
        cell.imageView.image = [UIImage imageNamed:@"sms.png"];
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"Twitter";
        cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        PRFacebookSettingsViewController *vc = [[PRFacebookSettingsViewController alloc] initWithNibName:@"PRFacebookSettingsViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        PRSMSSettingsViewController *vc = [[PRSMSSettingsViewController alloc] initWithNibName:@"PRSMSSettingsViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 2)
    {
        PRTwitterSettingsViewController *vc = [[PRTwitterSettingsViewController alloc] initWithNibName:@"PRTwitterSettingsViewController" 
                                                                                                bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
