//
//  PRViewController.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PRViewController.h"

@implementation PRViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    navigationController = [[UINavigationController alloc] initWithRootViewController:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    activationSlider = nil;
    settingsBarButtonItem = nil;
    toolbar = nil;
    slideLabel = nil;
    headingLabel = nil;
    distressActiveLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - selectors

- (void)activeTimerFired:(id)sender
{
    distressActiveLabel.hidden = !distressActiveLabel.hidden;
    if(distressActiveLabel.hidden)
        activationSlider.thumbTintColor = [UIColor redColor];
    else
        activationSlider.thumbTintColor = [UIColor whiteColor];
    //update information here
}

- (IBAction)settingsButtonTouched:(id)sender 
{
    
}

- (IBAction)activationSliderValueChanged:(id)sender 
{
    if(activationSlider.value == 1 && !distressCallIsActive)
    {
        if(activeTimer)
        {
            [activeTimer invalidate];
            activeTimer = nil;
        }
        slideLabel.text = @"Slide to Deactivate";
        activeTimer = [NSTimer scheduledTimerWithTimeInterval:ACTIVE_TIME_INTERVAL target:self selector:@selector(activeTimerFired:) userInfo:nil repeats:YES];
        distressActiveLabel.hidden = NO;
        distressCallIsActive = YES;
    }
    else if(activationSlider.value == 0 && distressCallIsActive)
    {
        slideLabel.text = @"Slide to Activate";
        [activeTimer invalidate];
        activeTimer = nil;
        distressActiveLabel.hidden = YES;
        distressCallIsActive = NO;
    }
}

@end
