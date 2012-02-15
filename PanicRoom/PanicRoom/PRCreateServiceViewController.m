//
//  PRCreateServiceViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PRCreateServiceViewController.h"


@implementation PRCreateServiceViewController
@synthesize serviceType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    self.navigationItem.title = @"Create Service";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 105, 100, 30)];
            textField.tag = 9000;
            [cell.contentView addSubview:nameLabel];
            [cell.contentView addSubview:textField];
        }
    }
    else
    {
        cell.textLabel.text = @"Done";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        PRService *service = [[PRService alloc] init];
        UITextField *nameField = (UITextField*)[self.view viewWithTag:9000];
        service.name = nameField.text;
        [[PRSession instance] addServices:service];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
