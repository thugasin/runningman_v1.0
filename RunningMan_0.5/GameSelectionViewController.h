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
#import "PomeloWS.h"

@interface GameSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, IObserver>

@property (strong, nonatomic) IBOutlet UILabel *Userlable;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSString *selectedGameID;

@property (strong, nonatomic) NSString* gameID;
@property (strong, nonatomic) NSString* gameName;
@property (weak, nonatomic) PomeloWS* pomelo;

@end
