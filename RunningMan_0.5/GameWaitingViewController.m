//
//  GameWaitingViewController.m
//  RunningMan_0.5
//
//  Created by Sirius on 15/10/14.
//  Copyright © 2015年 Sirius. All rights reserved.
//

#import "GameWaitingViewController.h"
#import "PacManMainGameViewController.h"

@interface GameWaitingViewController ()

@end

@implementation GameWaitingViewController
@synthesize GameID;
@synthesize GameName;
@synthesize list;
@synthesize tableview;
@synthesize Timmer;
@synthesize title;
@synthesize gametitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * command = @"showplayers 1\r\n";
    NSString * arg = [NSString stringWithFormat:@"%@\r\n", self.GameID];
    
    NSString * msg = [NSString stringWithFormat:@"%@%@",command, arg];
    
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:SHOW_PLAYER Instance:self];
    
    [na sendData:msg];
    
    gametitle.text = GameName;
    
    pomelo = [PomeloWS GetPomelo];
    [pomelo onRoute:@"onJoin" withCallback:onJoinCallback];
    
    self.Timmer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(RefreshPlayerInfo) userInfo:nil repeats:YES];
    [self.Timmer fire];
}

- (void)InitOnJoinCallback
{
    onJoinCallback = ^(id arg){
    };
}


-(void) ONMessageCome:(SocketMessage*)socketMsg
{
    if (socketMsg.Type == SHOW_PLAYER)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10000];
        if(socketMsg.argumentNumber != 0)
        {
            for (NSString *playerInfo in socketMsg.argumentList) {
                [array addObject:playerInfo];
            }
            
            self.list = array;
            [self.tableview reloadData];
        }
    }
    
    if (socketMsg.Type == START_GAME) {
        NetworkAdapter *na = [NetworkAdapter InitNetwork];
        [na UnsubscribeMessage:SHOW_PLAYER Instance:self];
        [na UnsubscribeMessage:QUERY_GAME Instance:self];
        if ([socketMsg.argumentList[0] integerValue] == 1)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainGameView"];
            [(PacManMainGameViewController*)mainViewController SetGameID:GameID];
            [self presentViewController:mainViewController animated:YES completion:^{
            }];
        }
    }
    
    if (socketMsg.Type == QUERY_GAME) {
        if ([socketMsg.argumentList[0] integerValue] == 0)
            return;
        if ([socketMsg.argumentList[0] integerValue] == 1)
        {
            if (self.Timmer == nil) {
                return;
            }
            
            [self.Timmer invalidate];
            self.Timmer = nil;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainGameView"];
            [(PacManMainGameViewController*)mainViewController SetGameID:GameID];
            [self presentViewController:mainViewController animated:YES completion:^{
            }];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.list = nil;
}

-(void)RefreshPlayerInfo
{
    NSString * command = @"showplayers 1\r\n";
    NSString * arg = [NSString stringWithFormat:@"%@\r\n", self.GameID];
    
    NSString * msg = [NSString stringWithFormat:@"%@%@",command, arg];
    
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:SHOW_PLAYER Instance:self];
    
    [na sendData:msg];
    
    
    NSString * command2 = @"querygame 1\r\n";
    NSString * arg2 = [NSString stringWithFormat:@"%@\r\n", self.GameID];
    
    NSString * msg2 = [NSString stringWithFormat:@"%@%@",command2, arg2];
    
    [na SubscribeMessage:QUERY_GAME Instance:self];
    
    [na sendData:msg2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"PlayerTableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
        
    }
    
    NSUInteger row = [indexPath row];
    cell.imageView.image = [UIImage imageNamed:@"pacManIcon.jpg"];
    cell.textLabel.text = [self.list objectAtIndex:row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) SetGameID:(NSString*)gameId
{
    GameID = gameId;
}

-(void) SetGameName:(NSString*)gameName
{
    GameName = gameName;
}

-(IBAction)OnStartGameButtonClicked:(id)sender
{
    [self.Timmer invalidate];
    self.Timmer = nil;
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:START_GAME Instance:self];
    
    [na sendData:@"startgame 0\r\n"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
