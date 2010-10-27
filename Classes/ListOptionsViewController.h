//
//  ListOptionsViewController.h
//  Simply Done
//
//  Created by Chad Berkley on 10/21/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ListOptionsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate> {

}
- (IBAction)emaillist:(id)sender;
- (IBAction)emailSDlist:(id)sender;
- (IBAction)deleteAllDone:(id)sender;
- (IBAction)deleteList:(id)sender;

@end
