//
//  AnimatedAnnotation.h
//  Category_demo2D
//
//  Created by 刘博 on 13-11-8.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface AnimatedAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) long width;
@property (nonatomic) long height;
@property (nonatomic) long animationRepeatCount;

@property (nonatomic, strong) NSMutableArray *animatedImages;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
