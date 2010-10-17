//
//  List.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 ucsb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemList : NSObject {
    
    NSNumber *identifier;
    NSString *name;
    NSNumber *sort;
    NSArray *items;
}

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *sort;
@property (nonatomic, retain) NSArray *items;

- (id) initWithIdentifier:(NSNumber*) identifier;
- (id) initWithName:(NSString*)name;
- (NSNumber*) numberDone;

@end
