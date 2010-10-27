//
//  RootViewController.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright ucsb 2010. All rights reserved.
//

#import "ListViewController.h"

@interface RootViewController : UITableViewController <UITextFieldDelegate>
{
	ListViewController *lvc;
}

- (void)openkeyboard:(id)sender;
- (void)newListItemButtonTouched:(id)sender;
- (void)reloadListViewController;

@end
