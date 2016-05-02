//
//  GameConfigurationViewController.h
//  RunningManDemo
//
//  Created by Sirius on 15-6-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "IObserver.h"
#import "NetworkAdapter.h"
#import "GameWaitingViewController.h"
#import "pomelows.h"

@interface GameConfigurationViewController : UIViewController<CLLocationManagerDelegate>
{
    NSArray *pickerArray;
    PomeloWS *pomelo;
}

-(IBAction)SetGameArea:(id)sender;
-(IBAction)OnStartGame:(id)sender;


- (void)initBaseNavigationBar;
- (void) returnAction;

@property (strong, nonatomic) IBOutlet UIPickerView *GamePicker;
@property (strong, nonatomic) IBOutlet UITextField *GameText;
@property (strong, nonatomic) IBOutlet UITextField *MaxPlayerNumber;
@property (strong,nonatomic) IBOutlet UIButton *SetGameLocationButton;
@property (strong,nonatomic) IBOutlet UIButton * StartGameButton;

@property (strong,nonatomic) IBOutlet UILabel* MaxPlayersText;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) NSString* playerCity;
@property (strong, nonatomic) CLLocation* playerLocation;
@property (strong, nonatomic) NSString * gameTypeNumber;

@end
