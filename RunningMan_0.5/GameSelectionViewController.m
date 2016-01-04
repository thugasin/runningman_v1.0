//
//  GameSelectionViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/7/4.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "GameSelectionViewController.h"

@implementation GameSelectionViewController
@synthesize list = _list;
@synthesize Userlable;
@synthesize tableview;
@synthesize selectedGameID;
@synthesize pomelo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"游戏";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"name"];
    
    Userlable.text = [NSString stringWithFormat:@"你好 %@!", name];
    
    pomelo = [PomeloWS GetPomelo];
    if ( pomelo == nil) {
        pomelo = [[PomeloWS alloc] initWithDelegate:self];
    }
    
    
    
    NSString * command = @"listgame 1\r\n";
    NSString * sCity = @"-1\r\n";
    
    NSString * listGameMessage = [NSString stringWithFormat:@"%@%@", command, sCity];
    
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:LIST_GAME Instance:self];
    
    [na sendData:listGameMessage];
}

-(void) ONMessageCome:(SocketMessage*)socketMsg
{
    if (socketMsg.Type == LIST_GAME)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10000];
        if(socketMsg.argumentNumber != 0)
        {
            for (NSString *gameInfo in socketMsg.argumentList) {
                [array addObject:gameInfo];
            }
            
            self.list = array;
            [self.tableview reloadData];
        }
    }
    
    if (socketMsg.Type == JOIN_GAME)
    {
        if ([socketMsg.argumentList[0] isEqualToString:@"1"])
        {
            NetworkAdapter *na = [NetworkAdapter InitNetwork];
            [na UnsubscribeMessage:JOIN_GAME Instance:self];
            [na UnsubscribeMessage:LIST_GAME Instance:self];
            NSLog(@"加入游戏成功!");
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameWaitingView"];
            [(GameWaitingViewController*)mainViewController SetGameID:selectedGameID];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];//创建一个视图（v_headerView）
    UIImageView *v_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,23)];//创建一个UIimageView（v_headerImageView）
    v_headerImageView.image = [UIImage imageNamed:@"ip_top bar.png"];//给v_headerImageView设置图片
    [v_headerView addSubview:v_headerImageView];//将v_headerImageView添加到创建的视图（v_headerView）中
    
    UILabel *v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 100, 19)];//创建一个UILable（v_headerLab）用来显示标题
    v_headerLab.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
    v_headerLab.textColor = [UIColor grayColor];//设置v_headerLab的字体颜色
    v_headerLab.font = [UIFont fontWithName:@"Arial" size:13];//设置v_headerLab的字体样式和大小
    v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
    [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
    //设置每组的的标题
    v_headerLab.text = @"PACMAN";
    
    [v_headerView addSubview:v_headerLab];//将标题v_headerLab添加到创建的视图（v_headerView）中
    
    return v_headerView;//将视图（v_headerView）返回
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selectedGame =[self.list objectAtIndex:indexPath.row];
    
    NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSArray *GameInfoArray =[selectedGame componentsSeparatedByCharactersInSet:CharacterSet];
    
    NSString * command = @"joingame 1\r\n";
    NSString * arg = [NSString stringWithFormat:@"%@\r\n", [GameInfoArray objectAtIndex:0]];
    
    selectedGameID = [NSString stringWithString:arg];
    
    
    NSString * msg = [NSString stringWithFormat:@"%@%@",command, arg];
    
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:JOIN_GAME Instance:self];
    
    [na sendData:msg];
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
