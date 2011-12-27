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
    self.navigationItem.title = @"Fields";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(dismiss:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for(int i=0; i<[[SGSession instance].fields count]; i++)
    {
        NSString *fieldVal = [[SGSession instance].fields objectAtIndex:i];
        UISwitch *s = (UISwitch*)[self.view viewWithTag:100 + i];
        if([fieldVal isEqualToString:@"on"])
            s.on = YES;
        else
            s.on = NO;
    }
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

@end
