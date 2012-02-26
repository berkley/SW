//
//  HUDView.h
//  Spider GPS
//
//  Created by Chad Berkley on 1/29/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ARROW_DIRECTION_UP 0
#define ARROW_DIRECTION_LEFT 1
#define ARROW_DIRECTION_RIGHT 2
#define ARROW_DIRECTION_DOWN 3
#define ARROW_DIRECTION_NONE 4

@interface HUDView : UIView
{
    BOOL tlCornerCurved;
    BOOL trCornerCurved;
    BOOL blCornerCurved;
    BOOL brCornerCurved;
    NSInteger arrowDirection;
}

- (id)initWithFrame:(CGRect)frame 
     tlCornerCurved:(BOOL)tlcorner 
     trCornerCurved:(BOOL)trcorner 
     blCornerCurved:(BOOL)blcorner 
     brCornerCurved:(BOOL)brcorner
     arrowDirection:(NSInteger)dir;

@end
