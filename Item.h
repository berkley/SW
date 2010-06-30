//
//  Item.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject {
    NSNumber *id;
    NSNumber *list_id;
    NSNumber *order;
    NSNumber *done;
    NSString *description;    
}

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *list_id;
@property (nonatomic, retain) NSNumber *order;
@property (nonatomic, retain) NSNumber *done;
@property (nonatomic, retain) NSString *description;


@end
