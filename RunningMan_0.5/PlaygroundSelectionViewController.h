//
//  PlaygroundSelectionViewController.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/7/24.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface PlaygroundSelectionViewController : UIViewController<MAMapViewDelegate,UIGestureRecognizerDelegate>
{
    __block MAMapView *_mapView;
    MACircle *circle;
    bool bIsInit;
    
//    IBOutlet UIButton* confirmButton;
    UIButton* confirmButton;
    UIButton* plusButton;
    UIButton* minusButton;
    int playgroundRadius;
}

@property(strong) id configureView;


@end
