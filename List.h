//
//  List.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface List : NSObject {
    
    NSNumber *id;
    NSString *name;
    NSNumber *order;
}

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *order;

@end
