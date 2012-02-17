//
//  PRTextAreaTableCell.m
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import "PRTextAreaTableCell.h"

@implementation PRTextAreaTableCell
@synthesize textView, nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 280, 30)];
        textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, 280, 60)];
        textView.backgroundColor = [UIColor clearColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:textView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - getters/setters

- (void)setLabelText:(NSString*)text
{
    self.nameLabel.text = text;
}

- (void)setTextViewText:(NSString*)text
{
    self.textView.text = text;
}

@end
