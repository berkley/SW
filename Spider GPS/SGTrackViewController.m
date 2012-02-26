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
    NSArray *trackKeys = [SGSession instance].tracks.allValues;
    trackKeys = [trackKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                 {
                     //extract the date from the key 
                     //Track::test::2012_02_02_16_09_GMT-08:00
                     NSString *stra = (NSString*)a;
                     NSString *strb = (NSString*)b;
                     NSArray *keypartsa = [stra componentsSeparatedByString:@"::"];
                     NSArray *keypartsb = [strb componentsSeparatedByString:@"::"];
                     NSDate *datea = [NSDate dateWithTimeIntervalSince1970:0];
                     NSDate *dateb = [NSDate dateWithTimeIntervalSince1970:0];
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:DATE_KEY_FORMAT_STRING];
                     
                     if([keypartsa count] == 3)
                         datea = [formatter dateFromString:[keypartsa objectAtIndex:2]];
                     
                     if([keypartsb count] == 3)
                         dateb = [formatter dateFromString:[keypartsb objectAtIndex:2]];                     
                     
                     return [dateb compare:datea];
                 }];
    NSLog(@"trackKeys: %@", trackKeys);
    
    trackNames = [[NSMutableArray alloc] init];
    for(int i=0; i<[trackKeys count]; i++)
    {
        NSInteger trackIndex = [[SGSession instance].tracks.allValues indexOfObject:[trackKeys objectAtIndex:i]];
        NSString *trackName = [[SGSession instance].tracks.allKeys objectAtIndex:trackIndex];
        [trackNames insertObject:trackName atIndex:i];
    }
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
    
    NSString *trackName = [trackNames objectAtIndex:indexPath.row];
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
//    NSString *trackName = [[SGSession instance].tracks.allKeys objectAtIndex:indexPath.row];
    NSString *trackName = [trackNames objectAtIndex:indexPath.row];
    dataViewController.track = [[SGSession instance] getTrackWithName:trackName];
    NSLog(@"track: %@", dataViewController.track);
    dataViewController.track.name = trackName;
    [self.navigationController pushViewController:dataViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView 
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *trackName = [trackNames objectAtIndex:indexPath.row];
    NSString *trackLocKey = [NSString stringWithFormat:@"%@-%@", LOCATION_KEY, trackName];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[CommonUtil getDataPathForFileWithName:trackLocKey] error:&error];
    
    [[SGSession instance].tracks removeObjectForKey:trackName];
    [trackNames removeObjectAtIndex:indexPath.row];
    [[SGSession instance] saveTracks];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

@end
