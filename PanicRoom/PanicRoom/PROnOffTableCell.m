//
//  PROnOffTableCell.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PROnOffTableCell.h"

@implementation PROnOffTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 150, 30)];
        switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(155, 8, 50, 30)];
        [self.contentView addSubview:label];
        [self.contentView addSubview:switchButton];
        label.backgroundColor = [UIColor clearColor];
        switchButton.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setLabelText:(NSString*)l
{
    label.text = l;
}

- (void)setSwitchValue:(BOOL)on
{
    switchButton.on = on;
}

- (BOOL)getSwitchValue
{
    return switchButton.on;
}

@end
