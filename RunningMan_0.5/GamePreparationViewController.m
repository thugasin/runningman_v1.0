//
//  GamePreparationViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/8/2.
//  Copyright © 2016年 Sirius. All rights reserved.
//
#import "AppDelegate.h"
#import "GamePreparationViewController.h"
#import "PomeloWS.h"
#import "GameWaitingViewController.h"

@interface GamePreparationViewController ()

@end

@implementation GamePreparationViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircleReionForCoordinate
{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    gameArea = [[AMapLocationCircleRegion alloc] initWithCenter:myDelegate.centerLocation
                                                                                       radius:myDelegate.gameRadius
                                                                                   identifier:@"gameArea"];
    
    //添加地理围栏
    [self.locationManager startMonitoringForRegion:gameArea];
    
    //添加Overlay
    MACircle *circleArea = [MACircle circleWithCenterCoordinate:myDelegate.centerLocation radius:myDelegate.gameRadius];
    [self.mapView addOverlay:circleArea];
    //[self.mapView setVisibleMapRect:circle300.boundingMapRect];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region
{
    NSLog(@"开始监听地理围栏:%@", region);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationError:{%ld;%@}", (long)error.code, error.localizedDescription);
}

- (void)amapLocationManager:(AMapLocationManager *)manager monitoringDidFailForRegion:(AMapLocationRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion:%@", error.localizedDescription);
}

- (void)OnEnterGame
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameWaitingView"];
    [(GameWaitingViewController*)mainViewController SetGameID:[NSString stringWithFormat:@"%@",[userDefault objectForKey:@"gameid"]]];
    [(GameWaitingViewController*)mainViewController SetGameName:[userDefault objectForKey:@"gamename"]];
    [self presentViewController:mainViewController animated:YES completion:^{
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    [self OnEnterGame];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region
{
    NSLog(@"didExitRegion:%@", region);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didDetermineState:(AMapLocationRegionState)state forRegion:(AMapLocationRegion *)region
{
    if(state == CLRegionStateInside)
    {
        [self OnEnterGame];
    }
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!bIsInit && updatingLocation)
    {
        [self.locationManager requestStateForRegion:gameArea];
        bIsInit = true;
    }
    
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 5.0f;
        circleRenderer.strokeColor = [UIColor blueColor];
        
        
        return circleRenderer;
    }
    
    return nil;
}

//- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MACircle class]])
//    {
//        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
//        
//        //  circleView.lineWidth = 1.f;
//        //  circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
//        //   circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
//        
//        //    circleView.lineDash = YES;//YES表示虚线绘制，NO表示实线绘制
//        
//        return circleView;
//    }
//    return nil;
//}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bIsInit = false;
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setZoomLevel:15 animated:YES];
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;
    
    
    [self configLocationManager];
    
    [self addCircleReionForCoordinate];
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    _mapView.showsScale = YES;
    _mapView.showsCompass = YES;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = YES;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
