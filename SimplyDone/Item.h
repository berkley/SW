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
    NSNumber *sort;
    NSNumber *done;
    NSString *description;    
}

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *list_id;
@property (nonatomic, retain) NSNumber *sort;
@property (nonatomic, retain) NSNumber *done;
@property (nonatomic, retain) NSString *description;

- (void)touched;
- (void) deleteItem;
- (void) updateDescription:(NSString*)desc;
- (NSString*)toString;
- (NSString*)export;
- (void)updateSort:(NSNumber*)num;
- (NSComparisonResult)compare:(Item*)otherObject;
- (NSComparisonResult)compareByAlpha:(Item*)otherObject;

@end
