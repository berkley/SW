//
//  SGDetailPreferencesModalViewController.m
//  Spider GPS
//
//  Created by Chad Berkley on 2/10/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGDetailPreferencesModalViewController.h"

@implementation SGDetailPreferencesModalViewController
@synthesize mapTypeSegCon, ascentDescentSwitch, timeLabelSwitch, delegate;

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
    activitySpinner.hidden = YES;
    if([SGSession instance].detailsMapType == MKMapTypeStandard)
        mapTypeSegCon.selectedSegmentIndex = 0;
    else if([SGSession instance].detailsMapType == MKMapTypeSatellite)
        mapTypeSegCon.selectedSegmentIndex = 1;
    else if([SGSession instance].detailsMapType == MKMapTypeHybrid)
        mapTypeSegCon.selectedSegmentIndex = 2;
    
    timeLabelSwitch.on = [SGSession instance].showTimeMarkers;
    ascentDescentSwitch.on = [SGSession instance].showAscentDescentView;
}

- (void)viewDidUnload
{
    mapTypeSegCon = nil;
    ascentDescentSwitch = nil;
    timeLabelSwitch = nil;
    activitySpinner = nil;
    [super viewDidUnload];
}

- (void)showSpinner
{
    activitySpinner.hidden = NO;
}

- (void)callDelegate
{
    if(delegate)
        [delegate prefModalDidClose];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self performSelectorOnMainThread:@selector(showSpinner) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(callDelegate) withObject:nil afterDelay:.1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - outlet methods

- (IBAction)ascentDescentSwitchChangedValue:(id)sender 
{
    [SGSession instance].showAscentDescentView = ascentDescentSwitch.on;
}

- (IBAction)timeLabelSwitchChangedValue:(id)sender 
{
    [SGSession instance].showTimeMarkers = timeLabelSwitch.on;
}

- (IBAction)mapTypeSegConValueChanged:(id)sender 
{
    if(mapTypeSegCon.selectedSegmentIndex == 0)
        [SGSession instance].detailsMapType = MKMapTypeStandard;
    else if(mapTypeSegCon.selectedSegmentIndex == 1)
        [SGSession instance].detailsMapType = MKMapTypeSatellite;
    else if(mapTypeSegCon.selectedSegmentIndex == 2)
        [SGSession instance].detailsMapType = MKMapTypeHybrid;
}

@end
