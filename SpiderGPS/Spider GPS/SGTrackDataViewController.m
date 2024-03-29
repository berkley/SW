//
//  SGTrackDataViewController.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/21/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
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
    returnFromMapView = NO;
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
    if(!returnFromMapView)
    {
        self.navigationItem.title = track.name;
        trackInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INFO_CELL_WIDTH, INFO_CELL_HEIGHT)];
        [[SGSession instance] showActivityIndicator:self.navigationController description:@"Processing Track" withProgress:NO];
        [self performSelectorInBackground:@selector(createTrackInfoView) withObject:nil];
    }
    else
        returnFromMapView = NO;
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
        return 1;
    else
        return 1;
}

- (UIView*)createTrackInfoView
{
    NSInteger x = 10;
    NSInteger x2 = 150;
    NSInteger y = 0;
    NSInteger w = 290 / 2;
    NSInteger h = 23;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -10, INFO_CELL_WIDTH, INFO_CELL_HEIGHT)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *totalDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *avgSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *topSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *lowSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *highestAltitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *lowestAltitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *totalAscentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    UILabel *totalDescentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, y += h, w, h)];
    
    y = 0;
    UILabel *dateLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    dateLabelLabel.text = @"Date Started:";
    UILabel *timeLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    timeLabelLabel.text = @"Time Started:";
    UILabel *totalDistanceLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    totalDistanceLabelLabel.text = @"Total Distance:";
    UILabel *avgSpeedLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    avgSpeedLabelLabel.text = @"Avg. Speed:";
    UILabel *topSpeedLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    topSpeedLabelLabel.text = @"Top Speed:";
    UILabel *lowSpeedLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    lowSpeedLabelLabel.text = @"Low Speed:";
    UILabel *highestAltitudeLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    highestAltitudeLabelLabel.text = @"High Altitude:";
    UILabel *lowestAltitudeLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    lowestAltitudeLabelLabel.text = @"Low Altitude:";
    UILabel *totalTimeLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    totalTimeLabelLabel.text = @"Total Time:";
    UILabel *totalAscentLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    totalAscentLabelLabel.text = @"Total Ascent:";
    UILabel *totalDescentLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y += h, w, h)];
    totalDescentLabelLabel.text = @"Total Descent:";

    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabelLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabelLabel setBackgroundColor:[UIColor clearColor]];
    [totalDistanceLabelLabel setBackgroundColor:[UIColor clearColor]];
    [totalDistanceLabel setBackgroundColor:[UIColor clearColor]];
    [avgSpeedLabelLabel setBackgroundColor:[UIColor clearColor]];
    [avgSpeedLabel setBackgroundColor:[UIColor clearColor]];
    [topSpeedLabelLabel setBackgroundColor:[UIColor clearColor]];
    [topSpeedLabel setBackgroundColor:[UIColor clearColor]];
    [lowSpeedLabelLabel setBackgroundColor:[UIColor clearColor]];
    [lowSpeedLabel setBackgroundColor:[UIColor clearColor]];
    [highestAltitudeLabelLabel setBackgroundColor:[UIColor clearColor]];
    [highestAltitudeLabel setBackgroundColor:[UIColor clearColor]];
    [lowestAltitudeLabelLabel setBackgroundColor:[UIColor clearColor]];
    [lowestAltitudeLabel setBackgroundColor:[UIColor clearColor]];
    [totalTimeLabelLabel setBackgroundColor:[UIColor clearColor]];
    [totalTimeLabel setBackgroundColor:[UIColor clearColor]];
    [totalAscentLabel setBackgroundColor:[UIColor clearColor]];
    [totalDescentLabel setBackgroundColor:[UIColor clearColor]];
    [totalAscentLabelLabel setBackgroundColor:[UIColor clearColor]];
    [totalDescentLabelLabel setBackgroundColor:[UIColor clearColor]];
    
    [view addSubview:dateLabel];
    [view addSubview:timeLabel];
    [view addSubview:totalDistanceLabel];
    [view addSubview:avgSpeedLabel];
    [view addSubview:topSpeedLabel];
    [view addSubview:lowSpeedLabel];
    [view addSubview:highestAltitudeLabel];
    [view addSubview:lowestAltitudeLabel];
    [view addSubview:totalTimeLabel];
    [view addSubview:totalAscentLabel];
    [view addSubview:totalDescentLabel];
    
    [view addSubview:dateLabelLabel];
    [view addSubview:timeLabelLabel];
    [view addSubview:totalDistanceLabelLabel];
    [view addSubview:avgSpeedLabelLabel];
    [view addSubview:topSpeedLabelLabel];
    [view addSubview:lowSpeedLabelLabel];
    [view addSubview:highestAltitudeLabelLabel];
    [view addSubview:lowestAltitudeLabelLabel];
    [view addSubview:totalTimeLabelLabel];
    [view addSubview:totalAscentLabelLabel];
    [view addSubview:totalDescentLabelLabel];
    
    if([track.totalAscent doubleValue] == 0.0 &&
       [track.totalAscent doubleValue] == 0.0)
    {
        [track calculateAscentAndDescent];
    }
    
    if([SGSession instance].useMPH)
    { //imperial
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles", [track.distance floatValue] * METERS_TO_MILES];
        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.avgSpeed floatValue] * METERS_TO_MPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.topSpeed floatValue] * METERS_TO_MPH];
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f mph", [track.lowSpeed floatValue] * METERS_TO_MPH];
        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.topAlitude floatValue] * METERS_TO_FT];
        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f ft", [track.lowAltidude floatValue] * METERS_TO_FT];
        totalAscentLabel.text = [NSString stringWithFormat:@"%.1f ft", [track.totalAscent floatValue] * METERS_TO_FT];
        totalDescentLabel.text = [NSString stringWithFormat:@"%.1f ft", [track.totalDescent floatValue] * METERS_TO_FT];
    }
    else
    { //metric
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f km", [track.distance floatValue] * METERS_TO_KM];
        avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.avgSpeed floatValue] * METERS_TO_KPH];
        topSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.topSpeed floatValue] * METERS_TO_KPH];
        lowSpeedLabel.text = [NSString stringWithFormat:@"%.2f kph", [track.lowSpeed floatValue] * METERS_TO_KPH];
        highestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.topAlitude floatValue]];
        lowestAltitudeLabel.text = [NSString stringWithFormat:@"%.2f m", [track.lowAltidude floatValue]];        
        totalAscentLabel.text = [NSString stringWithFormat:@"%.2f m", [track.totalAscent floatValue]];
        totalDescentLabel.text = [NSString stringWithFormat:@"%.2f m", [track.totalDescent floatValue]];
    }
        
    NSTimeInterval theTimeInterval = [track.totalTime doubleValue];
    
    dateLabel.text = [SGSession formatDate:track.date withFormat:DATE_ONLY_DISPLAY_FORMAT];
    timeLabel.text = [SGSession formatDate:track.date withFormat:TIME_ONLY_DISPLAY_FORMAT];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1]; 
    
    totalTimeLabel.text = [SGSession formattedElapsedTime:date1 date2:date2];
    [trackInfoView addSubview:view];
    [self.tableView reloadData];
    [[SGSession instance] hideActivityIndicator];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if(indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:trackInfoView];
    }
    else if(indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"View Track";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
            cell.imageView.image = [UIImage imageNamed:@"map.png"];
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
        returnFromMapView = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return INFO_CELL_HEIGHT;
    else
        return 60;
}

@end
