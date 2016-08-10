//
//  GameConfigurationViewController.m
//  RunningManDemo
//
//  Created by Sirius on 15-6-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "GameConfigurationViewController.h"
#import "ZHPickView/ZHPickView.h"


@implementation GameConfigurationViewController

@synthesize GameText;
@synthesize playerLocation;
@synthesize gameTypeNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.GameText.placeholder = @"游戏名";
    
    [AMapSearchServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    search = [[AMapSearchAPI alloc] init];
    
    search.delegate = self;
    gamePosition.titleLabel.lineBreakMode = 0;
    //   self.GamePicker.frame = CGRectMake(0, 480, 320, 216);
    
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_StartGameButton
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:0.875
//                              constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_MaxPlayerNumber
//                              attribute:NSLayoutAttributeRight
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeRight
//                              multiplier:1
//                              constant:-30]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_MaxPlayersText
//                              attribute:NSLayoutAttributeLeft
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeft
//                              multiplier:1
//                              constant:30]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_MaxPlayerNumber
//                              attribute:NSLayoutAttributeCenterY
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:_MaxPlayersText
//                              attribute:NSLayoutAttributeCenterY
//                              multiplier:1
//                              constant:1]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_MaxPlayersText
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:_StartGameButton
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1
//                              constant:-15]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:_SetGameLocationButton
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:_MaxPlayersText
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1
//                              constant:-15]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:GameText
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:_SetGameLocationButton
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1
//                              constant:-15]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:GamePicker
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:GameText
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1
//                              constant:-20]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ShowPicker:(id)sender {
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:@[@"天使与魔鬼",@"夺骑",@"谁是杀手"] title:@"选择游戏"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr)
    {
        [_SelectGameTypeButton setTitle:selectedStr forState:UIControlStateNormal];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefault objectForKey:@"name"];
        
        GameText.text = [NSString stringWithFormat:@"%@的%@", userName,selectedStr];
    };
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    gameCenterLocation = coordinate;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [search AMapReGoecodeSearch:regeo];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    playerCity = response.regeocode.addressComponent.city;
    [gamePosition setTitle:response.regeocode.formattedAddress forState:UIControlStateNormal];
}

-(IBAction)SetGameArea:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlaygroundSelection"];
    
    ((PlaygroundSelectionViewController*)mainViewController).configureView = self;
    [self.navigationController pushViewController:mainViewController animated:NO];
}

-(void)setGameRadius:(int)radius
{
    gameRadius = radius;
}



- (void)SetGlobalGameInfo
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.gameRadius = gameRadius;
    myDelegate.centerLocation = gameCenterLocation;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.GameText.text forKey:@"gamename"];
    [userDefaults setObject:playerCity forKey:@"playercity"];
    
    [userDefaults synchronize];
}

-(IBAction)OnStartGame:(id)sender
{
    [self SetGlobalGameInfo];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"userid":[userDefault objectForKey:@"name"],
                                        @"gamename":self.GameText.text,
                                        @"maxplayer":@20,
                             @"city":playerCity,
                             @"x1":[NSString stringWithFormat:@"%f", gameCenterLocation.latitude-(gameRadius/(1.414*111000))],
                             @"y1":[NSString stringWithFormat:@"%f", gameCenterLocation.longitude-(gameRadius/(1.414*111000))],
                             @"x2":[NSString stringWithFormat:@"%f", gameCenterLocation.latitude+(gameRadius/(1.414*111000))],
                             @"y2":[NSString stringWithFormat:@"%f", gameCenterLocation.longitude+(gameRadius/(1.414*111000))],
                             @"gametype":[NSString stringWithFormat:@"%@", @"Angel&deamon"]};
    pomelo = [PomeloWS GetPomelo];
    [pomelo requestWithRoute:@"game.gameHandler.create"
                   andParams:params andCallback:^(NSDictionary *result){
                       
                       if ([[result objectForKey:@"success"] boolValue])
                       {
                           
                           NSLog(@"游戏创建成功!");
                           
                           NSData * gameInfo = [[result objectForKey:@"game"] dataUsingEncoding:NSUTF8StringEncoding];
                           
                           NSDictionary *list = [NSJSONSerialization JSONObjectWithData:gameInfo options:kNilOptions error:nil];
                           
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           
                           [userDefaults setObject:[list objectForKey:@"ID"] forKey:@"gameid"];
                           
                           [userDefaults synchronize];
                           
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                           id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GamePreparation"];
                           
                           [self.navigationController pushViewController:mainViewController animated:NO];
                           
                       }
                       else
                       {
                           
                           NSLog(@"游戏创建失败!");
                           
                           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"游戏创建失败" message:@"服务器执行失败" preferredStyle:UIAlertControllerStyleAlert];
                           
                           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                           [alertController addAction:okAction];
                           
                           [self presentViewController:alertController animated:YES completion:nil];
                           return;
                       }
                   }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
