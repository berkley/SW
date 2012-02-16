//
//  PRLabelTextFieldTableCell.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "PRLabelTextFieldTableCell.h"

@implementation PRLabelTextFieldTableCell
@synthesize nameLabel, textField, label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 150, 30)];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(155, 8, 140, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.backgroundColor = [UIColor clearColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:textField];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setLabel:(NSString *)l
{
    self.nameLabel.text = l;
}

@end
