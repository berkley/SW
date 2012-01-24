//
//  SGTrackDataViewController.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/21/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGTrack.h"
#import "SGTrackDetailViewController.h"

#define INFO_CELL_HEIGHT 246

@interface SGTrackDataViewController : UITableViewController
{
    SGTrack *track;
}

@property (nonatomic, retain) SGTrack *track;

@end
