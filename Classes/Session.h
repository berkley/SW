//
//  Session.h
//  Simply Done
//
//  Created by Chad Berkley on 10/15/10.
//  Copyright 2010 UCSB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemList.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DBUtil.h"

@interface Session : NSObject 
{
	//the current id of the ItemList that is active
	NSNumber *currentListId;
	//the itemList that is active
	ItemList *itemList;
	//the array of ItemLists
	NSMutableArray* lists;
	BOOL isAddingNewList;
	NSString* path;
	NSString* listName;
	BOOL useSingleListInterface;
	sqlite3 *database;
}

@property (nonatomic, retain) NSNumber *currentListId;
@property (nonatomic, retain) ItemList *itemList;
@property (nonatomic, retain) NSMutableArray *lists;
@property (nonatomic) BOOL isAddingNewList;
@property (nonatomic, retain) NSString* path;
@property (nonatomic, retain) NSString* listName;
@property (nonatomic, assign) BOOL useSingleListInterface;
@property (nonatomic, assign) sqlite3 *database;

+ (Session*)sharedInstance;
- (void)emailSDList:(id<MFMailComposeViewControllerDelegate>)delegate viewController:(UIViewController*)viewController;
- (void)emailPlainTextList:(id<MFMailComposeViewControllerDelegate>)delegate viewController:(UIViewController*)viewController;
+ (int)getScreenWidth;
+ (int)getScreenHeight;
- (void)writeUserDefaults;

@end
