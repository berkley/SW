//
//  SGTimeAnnotationView.m
//  Spider GPS
//
//  Created by Chad Berkley on 2/8/12.
//  Copyright (c) 2012 ucsb. All rights reserved.
//

#import "SGTimeAnnotationView.h"

@implementation SGTimeAnnotationView

- (void)createView
{
    NSString *time = ((SGTimeAnnotation*)self.annotation).time;
    HUDView *h = [[HUDView alloc] initWithFrame:CGRectMake(0, 0, 60, 30) tlCornerCurved:YES trCornerCurved:YES blCornerCurved:YES brCornerCurved:YES arrowDirection:ARROW_DIRECTION_NONE];
    h.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 65, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = time;
    label.font = [UIFont systemFontOfSize:13.0];
    [h addSubview:label];
    [self addSubview:h];
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if([annotation isKindOfClass:[SGTimeAnnotation class]])
        {
            [self createView];
        }
    }
    return self;
}



@end
