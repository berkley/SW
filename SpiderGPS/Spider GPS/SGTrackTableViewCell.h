//
//  SGTrackTableViewCell.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/29/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGTrackTableViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *dateLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@end
