//
//  GameWaitingViewController.h
//  RunningMan_0.5
//
//  Created by Sirius on 15/10/14.
//  Copyright © 2015年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkAdapter.h"
#import "pomelows.h"
#import "PacManMainGameViewController.h"

@interface GameWaitingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    PomeloWS * pomelo;
    __block PacManMainGameViewController* gameController;
}

@property (nonatomic,strong) __block NSMutableArray *list;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSString* GameID;
@property (strong, nonatomic) NSString* GameName;
@property (nonatomic, retain) IBOutlet UILabel* gametitle;
@property (nonatomic, retain) NSTimer *Timmer;

-(void) SetGameID:(NSString*)gameId;
-(void) SetGameName:(NSString*)gameName;
-(void) RefreshPlayerInfo;

-(IBAction)OnStartGameButtonClicked:(id)sender;
@end
