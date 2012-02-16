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
#import "Constants.h"

@interface PRSession : NSObject
{
    DefaultsManager *defaults;
    NSMutableArray *services;
}

@property (nonatomic, retain) NSMutableArray *services;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, retain) NSString *testMessage;
@property (nonatomic, retain) NSString *alertMessage;

+ (PRSession*)instance;
- (void)addService:(PRService*)service;
- (void)removeService:(PRService*)service;
- (PRService*)serviceWithName:(NSString*)name;

@end
