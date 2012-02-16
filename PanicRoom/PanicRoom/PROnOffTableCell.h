//
//  PROnOffTableCell.h
//  SafeRoom
//
//  Created by Chad Berkley on 2/16/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PROnOffTableCell : UITableViewCell
{
    UISwitch *switchButton;
    UILabel *label;
}

- (void)setLabelText:(NSString*)label;
- (void)setSwitchValue:(BOOL)on;
- (BOOL)getSwitchValue;

@end
