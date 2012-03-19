//
//  SGTimeAnnotationView.h
//  Spider GPS
//
//  Created by Chad Berkley on 2/8/12.
//  Copyright (c) 2012 Chad Berkley. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SGTimeAnnotation.h"
#import "HUDView.h"

@interface SGTimeAnnotationView : MKAnnotationView
{
    
}


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
