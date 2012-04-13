//
//  PRAppDelegate.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

/*
 TODO:
 
 1.0
 x SMS service
 - Email service
 F google plus service - can't do this...http://stackoverflow.com/questions/9105949/ios-possible-to-send-or-post-message-in-google-plus
 x Allow user to delete email/sms services
 - new graphics
 x change interval to segcon
 x Add 'name' setting for sms
 - put limit on number of test messages
 
 x put test button on toolbar
 x put message text cells in configuration for indiv. services
 x get rid of settings section
 x for SMS add a character counter so message lenght < 160
 
 */

@class PRViewController;

@interface PRAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>
{
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PRViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;
@end
