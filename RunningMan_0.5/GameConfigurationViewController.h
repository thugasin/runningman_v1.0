//
//  GameConfigurationViewController.h
//  RunningManDemo
//
//  Created by Sirius on 15-6-5.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IObserver.h"
#import "NetworkAdapter.h"
#import "GameWaitingViewController.h"
#import "PlaygroundSelectionViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "pomelows.h"

@interface GameConfigurationViewController : UIViewController<AMapSearchDelegate>
{
    NSArray *pickerArray;
    PomeloWS *pomelo;
    AMapLocationManager *locationManager;
    AMapSearchAPI *search;
    CLLocationCoordinate2D gameCenterLocation;
    int gameRadius;
    NSString* playerCity;
    
    IBOutlet UIButton* gamePosition;
}

-(IBAction)SetGameArea:(id)sender;
-(IBAction)OnStartGame:(id)sender;


- (void)initBaseNavigationBar;
- (void) returnAction;
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setGameRadius:(int)radius;

@property (strong, nonatomic) IBOutlet UITextField *GameText;
@property (strong,nonatomic) IBOutlet UIButton *SelectGameTypeButton;
@property (strong,nonatomic) IBOutlet UIButton * StartGameButton;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) CLLocation* playerLocation;
@property (strong, nonatomic) NSString * gameTypeNumber;

@end
