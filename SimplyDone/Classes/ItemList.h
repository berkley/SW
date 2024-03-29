//
//  List.h
//  Simply Done
//
//  Created by Chad Berkley on 6/29/10.
//  Copyright 2010 Chad Berkley. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemList : NSObject {
    
    NSNumber *identifier;
    NSString *name;
    NSNumber *sort;
    NSMutableArray *items;
}

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *sort;
@property (nonatomic, retain) NSMutableArray *items;

- (id) initWithIdentifier:(NSNumber*) identifier;
- (id) initWithName:(NSString*)name;
- (NSNumber*) numberDone;
- (void) addItem:(NSString*)description;
- (void) addItem:(NSString*)description done:(BOOL)d;
- (void) delete;
- (void) deleteAllItems;
- (void) deleteAllDoneItems;
- (void) updateItemDescription:(NSString*)desc withId:(NSNumber*)id;
- (NSString*) createEmailText;
- (void)initItemsFromDB;
- (NSData*)createEmailAttachment;
- (void)deleteItem:(NSNumber*)id;
- (void)resetAllItems;
- (void)sortItemsByDone:(BOOL)doneFirst;
- (void)sortItemsByAlpha;
- (void)duplicate:(NSString*)n;
- (void) updateListName:(NSString*)newName;

@end
