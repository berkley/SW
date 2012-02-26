//
//  DataTest.m
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import "DataTest.h"


@implementation DataTest

- (void) setUp
{
    // Create data structures here.
    NSLog(@"in setup");
}

- (void) tearDown
{
    // Release data structures here.
    NSLog(@"in tear down.");
}

- (void) testCase
{
    NSLog(@"running test case 1");
    STAssertTrue(false, @"xxx" );
    STFail(@"XXXX");
}

@end
