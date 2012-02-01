//
//  SGTrackViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGTrackViewController.h"


@implementation SGTrackViewController

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

- (void)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Tracks";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self 
                                                                             action:@selector(editButtonTouched:)];
    
//    trackNames = (NSArray*)[[SGSession instance].tracks.allKeys sortedArrayUsingComparator:^NSComparisonResult (id a, id b)
//    {
//        NSDate *adate = (NSDate*)a;
//        NSDate *bdate = (NSDate*)b;
//        return [adate compare:bdate];
//    }];
    
}

- (void)editButtonTouched:(id)sender
{
    if(!self.tableView.isEditing)
    {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.rightBarButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }
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
    [self.tableView reloadData];
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
    return [[SGSession instance].tracks.allKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SGTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SGTrackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *trackName = [[SGSession instance].tracks.allKeys objectAtIndex:indexPath.row];
    NSString *trackKey = [[SGSession instance].tracks objectForKey:trackName];
    NSArray *keyComponents = [trackKey componentsSeparatedByString:@"::"];
    NSString *dateStr;
    if([keyComponents count] == 3)
        dateStr = [keyComponents objectAtIndex:2];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_KEY_FORMAT_STRING];
    NSDate *date = [formatter dateFromString:dateStr];
    [formatter setDateFormat:DATE_DISPLAY_FORMAT];
    cell.dateLabel.text = [formatter stringFromDate:date];
//
    cell.nameLabel.text = trackName;
//    NSString *dateStr = 
//    cell.dateLabel.text = [SGSession formatDate:date withFormat:@"MMM dd yyyy HH:mm ZZZZ"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SGTrackDataViewController *dataViewController = [[SGTrackDataViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSString *trackName = [[SGSession instance].tracks.allKeys objectAtIndex:indexPath.row];
    dataViewController.track = [[SGSession instance] getTrackWithName:trackName];
    dataViewController.track.name = trackName;
    [self.navigationController pushViewController:dataViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView 
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[SGSession instance].tracks.allKeys objectAtIndex:indexPath.row];
    [[SGSession instance].tracks removeObjectForKey:key];
    [[SGSession instance] saveTracks];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

@end
