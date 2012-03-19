//
//  ListViewController.h
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MessageUI/MessageUI.h>


@interface ListViewController : UITableViewController  <UITextFieldDelegate, 
  UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 
{
	UIButton *infoButton;
}

@property (nonatomic, retain) UIButton *infoButton;

-(void)newItemButtonTouched:(id)sender;

@end
