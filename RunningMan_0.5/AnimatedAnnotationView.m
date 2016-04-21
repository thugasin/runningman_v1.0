//
//  AnimatedAnnotationView.m
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"

#define kWidth          30.f
#define kHeight         30.f
#define kTimeInterval   0.15f

@implementation AnimatedAnnotationView

@synthesize imageView = _imageView;

#pragma mark - Life Cycle

//- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier width:(float)width height:(float)height
- (id)initWithAnimatedAnnotation:(id<MAAnnotation>)annotation
{
    AnimatedAnnotation *animatedAnotation = annotation;
    self = [super initWithAnnotation:annotation reuseIdentifier:animatedAnotation.identifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, animatedAnotation.width, animatedAnotation.height)];
      //  [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.animationRepeatCount = animatedAnotation.animationRepeatCount;
        self.imageView.animationImages      = animatedAnotation.animatedImages;
        self.imageView.animationDuration    = kTimeInterval * [animatedAnotation.animatedImages count];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    
    if ([self.imageView isAnimating])
    {
        [self.imageView stopAnimating];
    }
    
    
    [self.imageView startAnimating];
}

#pragma mark - Override

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}

@end
