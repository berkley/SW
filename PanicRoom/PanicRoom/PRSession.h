//
//  PRSession.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultsManager.h"
#import "PRService.h"
#import "CommonUtil.h"

@interface PRSession : NSObject
{
    DefaultsManager *defaults;
    NSMutableArray *services;
}

@property (nonatomic, retain) NSMutableArray *services;

+ (PRSession*)instance;
- (void)addService:(PRService*)service;

@end
