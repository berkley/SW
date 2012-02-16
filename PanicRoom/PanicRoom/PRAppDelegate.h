//
//  PRAppDelegate.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class PRViewController;

@interface PRAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>
{
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PRViewController *viewController;
@property (nonatomic, retain) Facebook *facebook;
@end
