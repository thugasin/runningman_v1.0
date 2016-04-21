//
//  AnimatedAnnotation.m
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AnimatedAnnotation.h"

@implementation AnimatedAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

@synthesize animatedImages = _animatedImages;
@synthesize width;
@synthesize height;
@synthesize identifier;
@synthesize animationRepeatCount;

#pragma mark - life cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}

@end
