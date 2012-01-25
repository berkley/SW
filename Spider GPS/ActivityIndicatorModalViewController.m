//
//  ActivityIndicatorModalViewController.m
//
//  Created by Chad Berkley on 6/20/11.
//

#import "ActivityIndicatorModalViewController.h"

@implementation ActivityIndicatorModalViewController
@synthesize descriptionLabel;
@synthesize  spinner, containerView, smallView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    spinner = nil;
    smallView = nil;
    containerView = nil;
    [self setDescriptionLabel:nil];
    progressBar = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)useProgressBar
{
    progressBar.progress = 0.0;
    progressBar.hidden = NO;
    spinner.hidden = YES;
}

- (void)updateProgressBar:(CGFloat)value
{
    progressBar.progress = value;
}

- (void)changeProgressBar:(NSString*)strVal
{
//    [self updateProgressBar:[strVal floatValue]];
    NSLog(@"updating pbar to %f", [strVal floatValue]);
    progressBar.progress = [strVal floatValue];
}

@end
