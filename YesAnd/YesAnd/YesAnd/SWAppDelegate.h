//
//  SWAppDelegate.h
//  YesAnd
//
//  Created by Chad Berkley on 3/9/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
