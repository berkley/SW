//
//  SGFieldSelectionViewController.m
//  SimpleGPS
//
//  Created by Chad Berkley on 12/12/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import "SGFieldSelectionViewController.h"

@implementation SGFieldSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalTimeSwitch.tag = 100;
    totalDistanceSwitch.tag = 101;
    currentSpeedSwitch.tag = 102;
    averageSpeedSwitch.tag = 103;
    topSpeedSwitch.tag = 104;
    lowSpeedSwitch.tag = 105;
    currentAltitudeSwitch.tag = 106;
    highAltitudeSwitch.tag = 107;
    latLonSwitch.tag = 109;
    headingSwitch.tag = 111;
    
    self.navigationItem.title = @"Fields";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    latLonView = nil;
    headingView = nil;
    screenOnView = nil;
    trueHeadingView = nil;
    lowAltitudeView = nil;
    highAltitudeView = nil;
    currentAltitudeView = nil;
    lowSpeedView = nil;
    topSpeedView = nil;
    avgSpeedView = nil;
    currentSpeedView = nil;
    totalDistanceView = nil;
    totalTimeView = nil;
    unitsView = nil;
    metricUnitsSwitch = nil;
    trueHeadingSwitch = nil;
    screenAlwaysOnSwitch = nil;
    totalTimeSwitch = nil;
    highAltitudeSwitch = nil;
    currentSpeedSwitch = nil;
    averageSpeedSwitch = nil;
    topSpeedSwitch = nil;
    lowSpeedSwitch = nil;
    currentAltitudeSwitch = nil;
    highAltitudeSwitch = nil;
    latLonSwitch = nil;
    headingSwitch = nil;
    totalDistanceSwitch = nil;
    lowAltitudeSwitch = nil;
    [super viewDidUnload];
}

- (void)setSwitches
{
    NSLog(@"fields: %@", [SGSession instance].fields);
    for(int i=0; i<[[SGSession instance].fields count]; i++)
    {
        NSString *fieldVal = [[SGSession instance].fields objectAtIndex:i];
        UISwitch *s;
        switch (i) {
            case 0:
                s = totalTimeSwitch;
                break;
            case 1:
                s = totalDistanceSwitch;
                break;
            case 2:
                s = currentSpeedSwitch;
                break;
            case 3:
                s = averageSpeedSwitch;
                break;
            case 4:
                s = topSpeedSwitch;
                break;
            case 5:
                s = lowSpeedSwitch;
                break;
            case 6:
                s = currentAltitudeSwitch;
                break;
            case 7:
                s = highAltitudeSwitch;
                break;
            case 8:
                s = lowAltitudeSwitch;
                break;
            case 9:
                s = latLonSwitch;
                break;
            case 11:
                s = headingSwitch;
                break;
            default:
                break;
        }
        
        if([fieldVal isEqualToString:@"on"])
            s.on = YES;
        else
            s.on = NO;
    }
    
    metricUnitsSwitch.on = ![SGSession instance].useMPH;
    trueHeadingSwitch.on = [SGSession instance].useTrueHeading;
    screenAlwaysOnSwitch.on = [SGSession instance].screenAlwaysOn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSwitches];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - switch methods
- (void)switchChanged:(UISwitch*)s
{
    switch (s.tag) {
        case 100:
            [[SGSession instance] setField:0 toOn:s.on];
            break;
        case 101:
            [[SGSession instance] setField:1 toOn:s.on];
            break;
        case 102:
            [[SGSession instance] setField:2 toOn:s.on];
            break;
        case 103:
            [[SGSession instance] setField:3 toOn:s.on];
            break;
        case 104:
            [[SGSession instance] setField:4 toOn:s.on];
            break;
        case 105:
            [[SGSession instance] setField:5 toOn:s.on];
            break;
        case 106:
            [[SGSession instance] setField:6 toOn:s.on];
            break;
        case 107:
            [[SGSession instance] setField:7 toOn:s.on];
            break;
        case 108:
            [[SGSession instance] setField:8 toOn:s.on];
            break;
        case 109: //lat
            [[SGSession instance] setField:9 toOn:s.on];
            [[SGSession instance] setField:10 toOn:s.on];
            break;
        case 110: //lon
            [[SGSession instance] setField:10 toOn:s.on];
            [[SGSession instance] setField:9 toOn:s.on];
            break;
        case 111:
            [[SGSession instance] setField:11 toOn:s.on];
            break;
        default:
            break;
    }
}

#pragma mark - switch value changes

- (IBAction)totalTimeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)totalDistanceChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)currentSpeedChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)averageSpeedChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)topSpeedChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)lowSpeedChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)currentAltitudeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)highestAltitudeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)lowestAltitudeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)latitudeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)longitudeChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)headingChanged:(id)sender {
    [self switchChanged:(UISwitch*)sender];
}

- (IBAction)metricUnitsChanged:(id)sender 
{
    [SGSession instance].useMPH = !metricUnitsSwitch.on;
}

- (IBAction)trueHeadingChanged:(id)sender 
{
    [SGSession instance].useTrueHeading = trueHeadingSwitch.on;
}

- (IBAction)screenAlwaysOnChanged:(id)sender 
{
    [SGSession instance].screenAlwaysOn = screenAlwaysOnSwitch.on;
}

#pragma mark - table del/datasource methods

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    if(indexPath.section == 0)
    {
        switch (indexPath.row) 
        {
            case 0:
                [cell.contentView addSubview:unitsView];
                break;
            case 1:
                [cell.contentView addSubview:trueHeadingView];
                break;
            case 2:
                [cell.contentView addSubview:screenOnView];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) 
        {
            case 0:
                [cell.contentView addSubview:latLonView];
                break;
            case 1:
                [cell.contentView addSubview:headingView];
                break;
            case 2:
                [cell.contentView addSubview:lowAltitudeView];
                break;
            case 3:
                [cell.contentView addSubview:highAltitudeView];
                break;
            case 4:
                [cell.contentView addSubview:currentAltitudeView];
                break;
            case 5:
                [cell.contentView addSubview:currentSpeedView];
                break;
            case 6:
                [cell.contentView addSubview:topSpeedView];
                break;
            case 7:
                [cell.contentView addSubview:lowSpeedView];
                break;
            case 8:
                [cell.contentView addSubview:avgSpeedView];
                break;
            case 9:
                [cell.contentView addSubview:totalTimeView];
                break;
            case 10:
                [cell.contentView addSubview:totalDistanceView];
                break;
            default:
                break;
        }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    else //if(section == 1)
        return 11;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Settings";
    else //if(section == 1)
        return @"Field Selection";
}

@end
