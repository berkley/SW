//
//  Simply_DoneAppDelegate.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright Chad Berkley 2010. All rights reserved.
//

#import "RootViewController.h"

@interface Simply_DoneAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	RootViewController *rvc;
	ListViewController *lvc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void)refreshRootViewController;

@end

