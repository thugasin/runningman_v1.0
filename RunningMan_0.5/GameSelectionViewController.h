//
//  GameSelectionViewController.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/7/4.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IObserver.h"
#import "NetworkAdapter.h"
#import "GameWaitingViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "PomeloWS.h"

@interface GameSelectionViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UINavigationItem *navigationBar;
    __block UIActivityIndicatorView *indicator;
    __block NSString* userCity;
}

@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSString* gameID;
@property (strong, nonatomic) NSString* gameName;
@property (retain, nonatomic) PomeloWS* pomelo;

@property (nonatomic, strong) AMapLocationManager *locationManager;
//@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic) __block CLLocationCoordinate2D userLocation;

-(void)StartWaitingAnimation;
-(void)StopWaitingAnimation;
-(void)CreateNewGame;

@end
