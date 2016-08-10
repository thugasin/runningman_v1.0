//
//  GamePreparationViewController.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/8/2.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface GamePreparationViewController : UIViewController<MAMapViewDelegate, AMapLocationManagerDelegate>
{
    AMapLocationCircleRegion *gameArea;
    bool bIsInit;
}


@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end
