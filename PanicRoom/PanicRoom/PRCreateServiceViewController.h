//
//  PRCreateServiceViewController.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRSession.h"

#define SERVICE_TYPE_FACEBOOK 0
#define SERVICE_TYPE_TWITTER 1
#define SERVICE_TYPE_SMS 2
#define SERVICE_TYPE_EMAIL 3

@interface PRCreateServiceViewController : UITableViewController
{
    NSInteger serviceType;
}

@property (nonatomic, assign) NSInteger serviceType;

@end
