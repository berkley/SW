//
//  HUDView.m
//  Spider GPS
//
//  Created by Chad Berkley on 1/29/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import "HUDView.h"

@implementation HUDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
     tlCornerCurved:(BOOL)tlcorner 
     trCornerCurved:(BOOL)trcorner 
     blCornerCurved:(BOOL)blcorner 
     brCornerCurved:(BOOL)brcorner
     arrowDirection:(NSInteger)dir
{
    self = [self initWithFrame:frame];
    if(self)
    {
        tlCornerCurved = tlcorner;
        trCornerCurved = trcorner;
        brCornerCurved = brcorner;
        blCornerCurved = blcorner;
        arrowDirection = dir;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
	CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//Determine Size
	rect = self.bounds;
	rect.size.width -= stroke;
	rect.size.height -= stroke;
    
	rect.origin.x += stroke / 2.0;
	rect.origin.y += stroke / 2.0;
	
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
    //bottom left
    if(blCornerCurved)
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
        CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
        				 radius, M_PI, M_PI / 2, 1);
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height);
    }
	
    if(arrowDirection == ARROW_DIRECTION_DOWN)
    {
        //the down arrow
        CGFloat parentX = 10.0;
        int xoffset = 200;
        if(parentX > xoffset)
        {
            CGPathAddLineToPoint(path, NULL, rect.origin.x - 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + xoffset, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, parentX - 15, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, parentX, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, parentX + 15, 
                                 rect.origin.y + rect.size.height);
        }        
    }

    
    //bottom right
    if(brCornerCurved)
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, 
                             rect.origin.y + rect.size.height);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, 
        				 rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
        
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, 
                             rect.origin.y + rect.size.height);
        
    }
    
    if(arrowDirection == ARROW_DIRECTION_RIGHT)
    {
        //the right arrow
        CGFloat parentX = 10.0;
        int xoffset = 200;
        if(parentX > xoffset)
        {
            CGPathAddLineToPoint(path, NULL, rect.origin.x - 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + xoffset, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, parentX - 15, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, parentX, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, parentX + 15, 
                                 rect.origin.y + rect.size.height);
        }        
    }
    
    
    //top left
    if(trCornerCurved)
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
        CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
                     radius, 0.0f, -M_PI / 2, 1);
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y);
    }
    
    if(arrowDirection == ARROW_DIRECTION_UP)
    {
        //the down arrow
        CGFloat parentX = 10.0;
        int xoffset = 200;
        if(parentX > xoffset)
        {
            CGPathAddLineToPoint(path, NULL, rect.origin.x - 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + xoffset, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, parentX - 15, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, parentX, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, parentX + 15, 
                                 rect.origin.y + rect.size.height);
        }        
    }
    
    //top right
    if(tlCornerCurved)
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
        CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, 
                     -M_PI / 2, M_PI, 1);
    }
    else
    {
        CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y);      
    }
    
    if(arrowDirection == ARROW_DIRECTION_LEFT)
    {
        //the down arrow
        CGFloat parentX = 10.0;
        int xoffset = 200;
        if(parentX > xoffset)
        {
            CGPathAddLineToPoint(path, NULL, rect.origin.x - 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + xoffset, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + 15 + xoffset, 
                                 rect.origin.y + rect.size.height);
        }
        else
        {
            CGPathAddLineToPoint(path, NULL, parentX - 15, 
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, parentX, 
                                 rect.origin.y + rect.size.height + 15);
            CGPathAddLineToPoint(path, NULL, parentX + 15, 
                                 rect.origin.y + rect.size.height);
        }        
    }
    
	CGPathCloseSubpath(path);
	
	//Fill Callout Bubble & Add Shadow
	color = [[UIColor blackColor] colorWithAlphaComponent:.6];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
    NSInteger yShadowOffset;
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (osVersion >= 3.2) {
        yShadowOffset = 6;
    } else {
        yShadowOffset = -6;
    }
	CGContextSetShadowWithColor(context, CGSizeMake (0, yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	//Stroke Callout Bubble
	color = [[UIColor darkGrayColor] colorWithAlphaComponent:.9];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	
	//Determine Size for Gloss
	CGRect glossRect = self.bounds;
	glossRect.size.width = rect.size.width - stroke;
	glossRect.size.height = (rect.size.height - stroke) / 2;
	glossRect.origin.x = rect.origin.x + stroke / 2;
	glossRect.origin.y += rect.origin.y + stroke / 2;
	
	CGFloat glossTopRadius = radius - stroke / 2;
	CGFloat glossBottomRadius = radius / 1.5;
	
	//Create Path For Gloss
	CGMutablePathRef glossPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + 
                      glossTopRadius);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + 
                         glossRect.size.height - glossBottomRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + 
                 glossRect.size.height - glossBottomRadius, 
				 glossBottomRadius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
						 glossRect.origin.y + glossRect.size.height);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, 
				 glossRect.origin.y + glossRect.size.height - glossBottomRadius, 
                 glossBottomRadius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, 
                         glossRect.origin.y + glossTopRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, 
                 glossRect.origin.y + glossTopRadius, 
				 glossTopRadius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, 
                 glossRect.origin.y + glossTopRadius, glossTopRadius, 
				 -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(glossPath);
	
	//Fill Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	CGFloat colors[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
	};
	CGFloat locations[] = { 0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
	CGPoint startPoint = glossRect.origin;
	CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	//Gradient Stroke Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextSetLineWidth(context, 2);
	CGContextReplacePathWithStrokedPath(context);
	CGContextClip(context);
	CGFloat colors2[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
		1, 1, 1, .0,
	};
	CGFloat locations2[] = { 0, .1, 1.0 };
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, colors2, locations2, 3);
	CGPoint startPoint2 = glossRect.origin;
	CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
	
	//Cleanup
	CGPathRelease(path);
	CGPathRelease(glossPath);
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
	CGGradientRelease(gradient2);
}

@end
