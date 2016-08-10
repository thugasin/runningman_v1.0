//
//  PlaygroundSelectionViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/7/24.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "PlaygroundSelectionViewController.h"
#import "GameConfigurationViewController.h"

@interface PlaygroundSelectionViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation PlaygroundSelectionViewController
@synthesize singleTap = _singleTap;

- (void)viewDidLoad {
    [super viewDidLoad];
    playgroundRadius = 50;
    [self StartMap];
    bIsInit = false;
    [self setupGestures];
    // Do any additional setup after loading the view.
}

- (void)StartMap{
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setZoomLevel:17 animated:YES];
    
    _mapView.pausesLocationUpdatesAutomatically = YES;
    _mapView.allowsBackgroundLocationUpdates = NO;
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = YES;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [confirmButton sizeToFit];
    confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [confirmButton addTarget:self action:@selector(OnConfirmButtonTouched:event:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:confirmButton];
    [self.view bringSubviewToFront:confirmButton];
    
    plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusButton setTitle:@"加" forState:UIControlStateNormal];
    
    [plusButton sizeToFit];
    plusButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [plusButton addTarget:self action:@selector(OnPlusButtonTouched:event:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:plusButton];
    [self.view bringSubviewToFront:plusButton];
    
    minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButton setTitle:@"减" forState:UIControlStateNormal];
    
    [minusButton sizeToFit];
    minusButton.translatesAutoresizingMaskIntoConstraints = NO;
    [minusButton addTarget:self action:@selector(OnMinusButtonTouched:event:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:minusButton];
    [self.view bringSubviewToFront:minusButton];
}

- (void) OnPlusButtonTouched:(id)sender event:(UIEvent *)event
{
    playgroundRadius = playgroundRadius+5;
    [self UpdateCircle:circle.coordinate radius:playgroundRadius];
}

- (void) OnMinusButtonTouched:(id)sender event:(UIEvent *)event
{
    if(playgroundRadius>5) playgroundRadius= playgroundRadius-5;
    [self UpdateCircle:circle.coordinate radius:playgroundRadius];
}

- (void) OnConfirmButtonTouched:(id)sender event:(UIEvent *)event
{
    [(GameConfigurationViewController*)_configureView searchReGeocodeWithCoordinate:circle.coordinate];
    [(GameConfigurationViewController*)_configureView setGameRadius:playgroundRadius];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self.navigationController popViewControllerAnimated:true];
    
}

- (void)updateViewConstraints
{
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:confirmButton
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:-100]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:confirmButton
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:plusButton
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1
                              constant:-5]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:plusButton
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:30]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:minusButton
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1
                              constant:-5]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:minusButton
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:plusButton
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:10]];
    
    
    [super updateViewConstraints];
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        if(!bIsInit)
        {
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            pre.image = [UIImage imageNamed:@"transparent.png"];
            pre.lineWidth = 0;
            pre.showsAccuracyRing = NO;
            pre.lineDashPattern = @[@6, @3];
            [_mapView updateUserLocationRepresentation:pre];
            
            //构造圆
            circle = [MACircle circleWithCenterCoordinate:userLocation.coordinate radius:playgroundRadius];
            
            //在地图上添加圆
            [_mapView addOverlay: circle];
            bIsInit = true;
            
        }
        
    }
    
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
      //  circleView.lineWidth = 1.f;
      //  circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
     //   circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
    
    //    circleView.lineDash = YES;//YES表示虚线绘制，NO表示实线绘制
        
        return circleView;
    }
    return nil;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.singleTap && ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[MAAnnotationView class]]))
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Handle Gestures

- (void)UpdateCircle:(CLLocationCoordinate2D) coor radius:(int)radii
{
    CLLocationCoordinate2D coordinate = coor;
    [_mapView removeOverlay:circle];
    
    //构造圆
    circle = [MACircle circleWithCenterCoordinate:coordinate radius:playgroundRadius];
    
    //在地图上添加圆
    [_mapView addOverlay: circle];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    CLLocationCoordinate2D  coordinate = [_mapView convertPoint:[theSingleTap locationInView:self.view] toCoordinateFromView:_mapView];
    [self UpdateCircle:coordinate radius:playgroundRadius];
    
}


#pragma mark - Initialization

- (void)setupGestures
{
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.singleTap.delegate = self;
    [self.view addGestureRecognizer:self.singleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
