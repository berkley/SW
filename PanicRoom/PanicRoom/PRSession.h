//
//  PRSession.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultsManager.h"
#import "PRService.h"

@interface PRSession : NSObject
{
    DefaultsManager *defaults;
}

@property (nonatomic, readonly) NSMutableArray *services;

+ (PRSession*)instance;
- (void)addServices:(PRService*)service;

@end
