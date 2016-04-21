//
//  AnimatedAnnotationView.h
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface AnimatedAnnotationView : MAAnnotationView

- (id)initWithAnimatedAnnotation:(id<MAAnnotation>)annotation;
@property (nonatomic, strong) UIImageView *imageView;

@end
