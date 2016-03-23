//
//  GameInfoViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/3/13.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "GameInfoViewController.h"

@interface GameInfoViewController ()

@end

@implementation GameInfoViewController

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0.8);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width/4, 50);
    CGContextAddLineToPoint(context,self.frame.size.width/4, 100);
    CGContextMoveToPoint(context, self.frame.size.width/2, 50);
    CGContextAddLineToPoint(context,self.frame.size.width/2, 100);
    CGContextMoveToPoint(context, self.frame.size.width*3/4, 50);
    CGContextAddLineToPoint(context,self.frame.size.width*3/4, 100);
    CGContextClosePath(context);
    [[UIColor grayColor] setStroke];
    CGContextStrokePath(context);
}

@end
