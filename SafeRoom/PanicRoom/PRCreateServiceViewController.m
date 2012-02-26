//
//  PRCreateServiceViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRCreateServiceViewController.h"


@implementation PRCreateServiceViewController
@synthesize serviceType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        nameCell = [[PRLabelTextFieldTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"namelabeltextcell"];
        nameCell.label = @"Name:";
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
        if(indexPath.row == 0)
        {
            return nameCell;
        }
    }
    else
    {
        cell.textLabel.text = @"Done";
        return cell;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    { //done
        PRService *service = [[PRService alloc] init];
        service.name = nameCell.textField.text;
        if([[PRSession instance] addService:service])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];            
        }
        else
        {
            NSString *msg = [NSString stringWithFormat:@"There is already a service called %@. Please choose a new name", nameCell.textField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate Name" 
                                                            message:msg 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
        }

    }
}

@end
