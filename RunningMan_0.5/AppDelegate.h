//
//  AppDelegate.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "PomeloWS.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PomeloWS* pomelo;
@property (nonatomic) CLLocationCoordinate2D centerLocation;
@property (nonatomic) int gameRadius;

@end

