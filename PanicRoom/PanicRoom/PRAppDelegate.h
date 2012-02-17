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
 - SMS service
 - Email service
 F google plus service - can't do this...http://stackoverflow.com/questions/9105949/ios-possible-to-send-or-post-message-in-google-plus
 - Allow user to delete email/sms services
 - new graphics
 - change interval to segcon
 - Add 'name' setting for sms
 
 
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
