//
//  PRService.h
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRService : NSObject <NSCoding>
{
    NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end
