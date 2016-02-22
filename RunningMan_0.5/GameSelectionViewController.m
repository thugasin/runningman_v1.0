//
//  GameSelectionViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/7/4.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "GameSelectionViewController.h"
#import "GameInfoTableCellView.h"
#import "GameConfigurationViewController.h"

@interface GameSelectionViewController()

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation GameSelectionViewController
@synthesize list;
@synthesize tableview;
@synthesize pomelo;
@synthesize locationManager;
@synthesize userLocation;

static NSString* CellTableIdentifier = @"CellTableIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"游戏";
    
    self.list = [NSMutableArray arrayWithCapacity:100000]; //
    
    //init navigation bar
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(CreateNewGame) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    navigationBar.rightBarButtonItem = rightItem;
    
    
    [AMapLocationServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self InitCompleteBlock];

    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    self.tableview.rowHeight = 68.5;
    UINib *nib = [UINib nibWithNibName:@"GameInfoCell" bundle:nil];
    [tableview registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    //[self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    [self StartWaitingAnimation];
}

-(void) CreateNewGame
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameConfigure"];
    [self.navigationController pushViewController:mainViewController animated:NO];
}

-(void) StartWaitingAnimation
{
    if (indicator == nil) {
        
        //初始化:
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        
        indicator.tag = 103;
        
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        
        //设置背景色
        indicator.backgroundColor = [UIColor blackColor];
        
        //设置背景透明
        indicator.alpha = 0.5;
        
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        //设置显示位置
        [indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
        
        //开始显示Loading动画
        [indicator startAnimating];
        
        [self.view addSubview:indicator];
    }
}

-(void) StopWaitingAnimation
{
    [indicator stopAnimating];
}

-(void) InitCompleteBlock
{
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"定位失败" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
        
        if (location)
        {
            userLocation = location.coordinate;
            userCity = regeocode.city;
            
            pomelo = [PomeloWS GetPomelo];
            if ( pomelo == nil) {
                pomelo = [[PomeloWS alloc] initWithDelegate:self];
            }
            
 //           [pomelo connectToHost:@"ayo.org.cn" onPort:3014 withCallback:^(PomeloWS *p)
//             [pomelo connectToHost:@"ayo.org.cn" onPort:3014 withCallback:^(PomeloWS *p)
             [pomelo connectToHost:@"192.168.1.111" onPort:3014 withCallback:^(PomeloWS *p)
             {
                 [indicator stopAnimating];
                 NSDictionary *params = @{@"city":@"-1"};
                 [pomelo requestWithRoute:@"game.gameHandler.list"
                                andParams:params andCallback:^(NSDictionary *json){
                                    
                                    NSData * gameInfoList = [[json objectForKey:@"games"] dataUsingEncoding:NSUTF8StringEncoding];
                                    
                                    list = [NSJSONSerialization JSONObjectWithData:gameInfoList options:kNilOptions error:nil];
                                    
                                    [self.tableview reloadData];
                                }];
             }];
        }
    };
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.list = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameInfoTableCellView *cell = [tableview dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    NSUInteger row = [indexPath row];
    
    NSString* distance = (NSString*)[((NSDictionary*)[self.list objectAtIndex:row]) objectForKey:@"Distance"];
    if (![distance isEqual:[NSNull null]])
    {
        [[cell distance] setText:[NSString stringWithFormat:@"%@%@",distance,@"m"]];
    }
    
    [[cell currentPlayerVSMax] setText:@"4/10"];
    [[cell gameState] setText:@"waiting"];
    [[cell gameName] setText:((NSString*)[((NSDictionary*)[self.list objectAtIndex:row]) objectForKey:@"GameName"])];
    [[cell gameImage] setImage:[UIImage imageNamed:@"pacman-party"]];
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    NSString* gameid = [[self.list objectAtIndex:indexPath.row] objectForKey:@"ID"];
//    NSString* playerX = self.userLocation.latitude;
//    NSString* playerY = userLocation.longitude;
    
    NSDictionary *params = @{@"gameid":[NSString stringWithFormat:@"%@", gameid], @"userid":[userDefault objectForKey:@"name"]};
    
    [pomelo requestWithRoute:@"game.gameHandler.join"
                   andParams:params andCallback:^(NSDictionary *result){
                       
                       NSLog((NSString*)[result objectForKey:@"message"]);
                       if ([[result objectForKey:@"success"] boolValue])
                       {
                           
                           
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                           id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameWaitingView"];
                           [(GameWaitingViewController*)mainViewController SetGameID:[NSString stringWithFormat:@"%@", gameid]];
                           [self presentViewController:mainViewController animated:NO completion:^{
                           }];
                       }
                       else
                       {
                           
                           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加入游戏失败" message:(NSString*)[result objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                           
                           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                           [alertController addAction:okAction];
                           
                           [self presentViewController:alertController animated:YES completion:nil];
                           return ;
                       }
                   }];
                   

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
