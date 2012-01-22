//
//  SGTrackDataViewController.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/21/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGTrackDataViewController.h"


@implementation SGTrackDataViewController
@synthesize track;

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
    self.navigationItem.title = track.name;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if(indexPath.section == 0)
    {
        cell.textLabel.text = track.name;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Track View";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;            
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Run View";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;            
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"3D View";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                        
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    else if(indexPath.section == 1)
    {
        SGTrackDetailViewController *detailViewController = [[SGTrackDetailViewController alloc] initWithNibName:@"SGTrackDetailViewController" bundle:nil trackName:track.name];
        if(indexPath.row == 0)
        {
            detailViewController.style = TRACK_STYLE_NORMAL;
        }
        else if(indexPath.row == 1)
        {
            detailViewController.style = TRACK_STYLE_RUN;
        }
        else if(indexPath.row == 2)
        {
            detailViewController.style = TRACK_STYLE_3D;
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    else
    {
        return 40;
    }
}

@end
