//
//  SGTrackViewController.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSession.h"
#import "SGTrackDetailViewController.h"
#import "SGTrackDataViewController.h"
#import "SGTrackTableViewCell.h"

@interface SGTrackViewController : UITableViewController    
{
    SGTrackDetailViewController *detailViewController;
    NSMutableArray *trackNames;
}
@end
