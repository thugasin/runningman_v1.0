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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"userid":[userDefault objectForKey:@"name"],
                                        @"gamename":self.GameText.text,
                                        @"maxplayer":self.MaxPlayerNumber.text,
                             @"city":self.playerCity,
                             @"x1":[NSString stringWithFormat:@"%f", self.playerLocation.coordinate.latitude+0.001543-0.001],
                             @"y1":[NSString stringWithFormat:@"%f", playerLocation.coordinate.longitude+0.005866-0.001],
                             @"x2":[NSString stringWithFormat:@"%f", self.playerLocation.coordinate.latitude+0.001543+0.001],
                             @"y2":[NSString stringWithFormat:@"%f",playerLocation.coordinate.longitude+0.005866+0.001],
                             @"gametype":[NSString stringWithFormat:@"%@", @"Angel&Demon"]};
    pomelo = [PomeloWS GetPomelo];
    [pomelo requestWithRoute:@"game.gameHandler.create"
                   andParams:params andCallback:^(NSDictionary *result){
                       
                       if ([[result objectForKey:@"success"] boolValue])
                       {
                           NSLog(@"游戏创建成功!");
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                           
                           NSData * gameInfo = [[result objectForKey:@"game"] dataUsingEncoding:NSUTF8StringEncoding];
                           
                           NSDictionary *list = [NSJSONSerialization JSONObjectWithData:gameInfo options:kNilOptions error:nil];
                           
                           id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameWaitingView"];
                           [(GameWaitingViewController*)mainViewController SetGameID:[NSString stringWithFormat:@"%@",[list objectForKey:@"ID"]]];
                           [(GameWaitingViewController*)mainViewController SetGameName:[list objectForKey:@"GameName"]];
                           [self presentViewController:mainViewController animated:YES completion:^{
                           }];
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
