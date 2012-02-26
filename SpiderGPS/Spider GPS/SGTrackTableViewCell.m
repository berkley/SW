//
//  SGTrackTableViewCell.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/29/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGTrackTableViewCell.h"

@implementation SGTrackTableViewCell
@synthesize dateLabel, nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 30)];
        nameLabel.font = [UIFont boldSystemFontOfSize:19.0];
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 300, 20)];
        dateLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
