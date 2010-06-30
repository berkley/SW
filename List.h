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
    NSNumber *sort;
    NSArray *items;
}

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *sort;
@property (nonatomic, retain) NSArray *items;

- (void) initWithIdentifier:(NSNumber*) identifier;

@end
