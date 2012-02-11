//
//  SGDetailPreferencesModalViewController.m
//  Spider GPS
//
//  Created by Chad Berkley on 2/10/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGDetailPreferencesModalViewController.h"

@implementation SGDetailPreferencesModalViewController
@synthesize mapTypeSegCon, ascentDescentSwitch, timeLabelSwitch, mapType, 
timeLabelOn, ascentDescentOn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    if(mapType == MKMapTypeStandard)
        mapTypeSegCon.selectedSegmentIndex = 0;
    else if(mapType == MKMapTypeSatellite)
        mapTypeSegCon.selectedSegmentIndex = 1;
    else if(mapType == MKMapTypeHybrid)
        mapTypeSegCon.selectedSegmentIndex = 2;
    
    timeLabelSwitch.on = timeLabelOn;
    ascentDescentSwitch.on = ascentDescentOn;
}

- (void)viewDidUnload
{
    mapTypeSegCon = nil;
    ascentDescentSwitch = nil;
    timeLabelSwitch = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - outlet methods

- (IBAction)ascentDescentSwitchChangedValue:(id)sender 
{
    ascentDescentOn = ascentDescentSwitch.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ASCENT_DESCENT_CHANGED object:nil];
}

- (IBAction)timeLabelSwitchChangedValue:(id)sender 
{
    timeLabelOn = timeLabelSwitch.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_LABELS_CHANGED object:nil];
}

- (IBAction)mapTypeSegConValueChanged:(id)sender 
{
    if(mapTypeSegCon.selectedSegmentIndex == 0)
        mapType = MKMapTypeStandard;
    else if(mapTypeSegCon.selectedSegmentIndex == 1)
        mapType = MKMapTypeSatellite;
    else if(mapTypeSegCon.selectedSegmentIndex == 2)
        mapType = MKMapTypeHybrid;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DETAILS_MAP_TYPE_CHANGED object:nil];
}


@end
