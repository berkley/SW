//
//  PRTextAreaTableCell.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABEL_TEXT_VIEW_CELL_HEIGHT 100

@interface PRTextAreaTableCell : UITableViewCell
{
    UILabel *nameLabel;
    UITextView *textView;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UITextView *textView;

- (void)setLabelText:(NSString*)text;
- (void)setTextViewText:(NSString*)text;

@end
