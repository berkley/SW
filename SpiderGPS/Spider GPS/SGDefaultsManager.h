//
//  SGDefaultsManager.h
//  SimpleGPS
//
//  Created by Chad Berkley on 12/9/11.
//  Copyright (c) 2011 UCSB. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ROOT_OBJECT @"SGRootObject"

@interface SGDefaultsManager : NSObject 
{
    NSMutableDictionary *defaults;
}

+ (SGDefaultsManager*)instance;
- (void)setObject:(NSObject*)obj withName:(NSString*)name;
- (NSObject*)getObjectWithName:(NSString*)name;

@end