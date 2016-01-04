//
//  GameConfigurationViewController.m
//  RunningManDemo
//
//  Created by Sirius on 15-6-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "GameConfigurationViewController.h"
@implementation GameConfigurationViewController

@synthesize GamePicker;
@synthesize GameText;
@synthesize locationManager;
@synthesize playerCity;
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
    pickerArray = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects:@"吃豆子",@"夺旗",@"夺宝奇兵",@"谁是杀手", nil]];
    self.GameText.placeholder = @"游戏名";
//    self.GameText.inputAccessoryView = DoneToolBar;
//    self.GameText.delegate = self;
    self.GamePicker.delegate = self;
    self.GamePicker.dataSource = self;
 //   self.GamePicker.frame = CGRectMake(0, 480, 320, 216);
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *selectedGame=[pickerArray objectAtIndex:row];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault objectForKey:@"name"];
    
    GameText.text = [NSString stringWithFormat:@"%@的%@", userName,selectedGame];
    
    gameTypeNumber =[NSString stringWithFormat:@"%ld", (long)row];
    
    return [pickerArray objectAtIndex:row];
}

-(IBAction)SetGameArea:(id)sender
{
    [self startLocation];
}

-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [self.locationManager stopUpdatingLocation];  //拿到用户信息后停止更新location
    
    playerLocation = [locations objectAtIndex:([locations count]-1)];
    NSLog(@"location ok");
    NSLog(@"==latitude %f, longitude %f", [playerLocation coordinate].latitude , [playerLocation coordinate].longitude);
    
    
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:playerLocation completionHandler:^(NSArray *placemarks, NSError *error)
//    {
//        for (CLPlacemark * placemark in placemarks)
//        {
//            
//            NSDictionary *playerAddress = [placemark addressDictionary];
//            //  Country(国家)  State(城市)  SubLocality(区)
//            self.playerCity = [playerAddress objectForKey:@"State"];
//            NSLog(@"%@", self.playerCity);
//            
    self.playerCity = @"北京";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"游戏区域" message:[NSString stringWithFormat:@"游戏城市：%@",self.playerCity] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
//        }
//    }];
//    
    
    
}

-(IBAction)OnStartGame:(id)sender
{
    NSString * command = @"creategame 6\r\n";
    NSString * gameName = [NSString stringWithFormat:@"%@\r\n", self.GameText.text];
    NSString * maxPlayerNumber = [NSString stringWithFormat:@"%@\r\n", self.MaxPlayerNumber.text];
    NSString * cityName = [NSString stringWithFormat:@"%@\r\n", self.playerCity];
    NSString * locationPoint1 = [NSString stringWithFormat:@"%f:%f\r\n", self.playerLocation.coordinate.latitude+0.001543-0.001, playerLocation.coordinate.longitude+0.005866-0.001];
    NSString * locationPoint2 = [NSString stringWithFormat:@"%f:%f\r\n", self.playerLocation.coordinate.latitude+0.001543+0.001, playerLocation.coordinate.longitude+0.005866+0.001];
    NSString * gameType = [NSString stringWithFormat:@"%@\r\n", gameTypeNumber];
    
    NSString * createGameMessage = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", command, gameName, maxPlayerNumber, cityName, locationPoint1, locationPoint2, gameType];
    
    NetworkAdapter *na = [NetworkAdapter InitNetwork];
    [na SubscribeMessage:CREATE_GAME Instance:self];
    
    [na sendData:createGameMessage];
    NSLog([NSString stringWithFormat:@"游戏创建信息发送：%@", createGameMessage]);
}

-(void) ONMessageCome:(SocketMessage*)socketMsg
{
    if (socketMsg.Type == CREATE_GAME)
    {
        if ([socketMsg.argumentList[0] isEqualToString:@"0"])
        {
            NSLog(@"游戏创建失败!");
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"游戏创建失败" message:@"服务器执行失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        NetworkAdapter *na = [NetworkAdapter InitNetwork];
        [na UnsubscribeMessage:CREATE_GAME Instance:self];
        
        NSLog(@"游戏创建成功!");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameWaitingView"];
        [(GameWaitingViewController*)mainViewController SetGameID:socketMsg.argumentList[0]];
        [(GameWaitingViewController*)mainViewController SetGameName:socketMsg.argumentList[0]];
        [self presentViewController:mainViewController animated:YES completion:^{
        }];
        
    }
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
