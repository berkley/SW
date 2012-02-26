//
//  PRLabelTextFieldTableCell.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LABEL_TEXT_FIELD_CELL_HEIGHT 50

@interface PRLabelTextFieldTableCell : UITableViewCell
{
    UILabel *nameLabel;
    UITextField *textField;    
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) NSString *label;

- (void)setLabelText:(NSString *)l;
- (void)setTextFieldText:(NSString*)text;

@end
