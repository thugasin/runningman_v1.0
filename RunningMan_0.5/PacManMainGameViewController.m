//
//  ViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "PacManMainGameViewController.h"
#import "NRTC.h"


@interface PacManMainGameViewController ()

@property (nonatomic,copy) PomeloWSCallback onPlayerUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback onMapUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback drawMap;


@end

@implementation PacManMainGameViewController
@synthesize GameGridRow;
@synthesize GameGridColunm;
@synthesize PlayerList;
@synthesize UserName;
@synthesize GameID;

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                     }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UserName = [userDefault objectForKey:@"name"];
    bSetUserLocation = false;
    bInitSelfPresentation = false;
    
    pomelo = [PomeloWS GetPomelo];
    
    [self InitDrawMap];
    
    [self InitPlayerUpdate];
    [self InitMapUpdate];
    
    

    
    // Set the 'menu button
    [self.MenuButton initAnimationWithFadeEffectEnabled:NO]; // Set to 'NO' to disable Fade effect between its two-state transition
    
    // Get the 'menu item view' from storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuItemsVC = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ArchMenu"];
    self.menuItemView = (BounceButtonView *)menuItemsVC.view;
    
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects:self.menuItemView.menuItem1,
                                   self.menuItemView.menuItem2,
                                   self.menuItemView.menuItem3,
                                   nil]; // Add all of the defined 'menu item button' to 'menu item view'
    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    
    [self.menuItemView setAnimationStyle:ASOAnimationStyleRiseProgressively];
    
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
    
    
    _gameInfoView = [[GameInfoViewController alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,100)];
    [_gameInfoView setBackgroundColor:[UIColor whiteColor]];
    [[_gameInfoView layer] setMasksToBounds:YES];
    _gameInfoView.alpha = 0.9;
    [self.view addSubview:_gameInfoView];
    
    bChatButtonEnabled = true;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

- (IBAction)menuButtonAction:(id)sender
{
    if ([sender isOn]) {
        // Show 'menu item view' and expand its 'menu item button'
        [self.MenuButton addCustomView:self.menuItemView];
        [self.menuItemView expandWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
    }
    else {
        // Collapse all 'menu item button' and remove 'menu item view'
        [self.menuItemView collapseWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
        [self.MenuButton removeCustomView:self.menuItemView interval:[self.menuItemView.collapsedViewDuration doubleValue]];
    }
}

-(void) InitPlayerUpdate
{
    self.onPlayerUpdateCallback = ^(NSDictionary* playerInfo)
    {
        if ([playerInfo objectForKey:@"userid"] == UserName) {
            return;
        }
        AnimatedAnnotation* playerAnnotation = [PlayerList objectForKey:[playerInfo objectForKey:@"userid"]];
        
        playerAnnotation.coordinate = CLLocationCoordinate2DMake([[playerInfo objectForKey:@"x"] doubleValue],[[playerInfo objectForKey:@"y"] doubleValue]);
    };
}

-(void) InitMapUpdate
{
    self.onMapUpdateCallback = ^(NSDictionary* mapInfo)
    {
        if(![PlayerList objectForKey:[mapInfo objectForKey:@"goid"]])
             return;
             
        NSDictionary * mapInfoData = [mapInfo objectForKey:@"go"];
        if ([[mapInfoData objectForKey:@"Role"]  isEqualToString: @"bean"] && [[mapInfoData objectForKey:@"State"]  isEqualToString:@"eaten"])
        {
            AnimatedAnnotation* playerAnnotation = [PlayerList objectForKey:[mapInfo objectForKey:@"goid"]];
            [_mapView removeAnnotation:playerAnnotation];
            [PlayerList removeObjectForKey:[mapInfo objectForKey:@"goid"]];
        }
    };
}

-(void) InitDrawMap
{
    self.drawMap = ^(NSDictionary* mapInfo)
    {
        if ([[mapInfo objectForKey:@"success"] boolValue])
        {
            NSArray* mapInfoL = [mapInfo objectForKey:@"map"];
            NSData * mapInfoData = [[mapInfo objectForKey:@"map"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* mapInfoArray = [NSJSONSerialization JSONObjectWithData:mapInfoData options:kNilOptions error:nil];
            
            NSString * key = [[mapInfoArray objectAtIndex:0] objectAtIndex:0];
            NSDictionary* info = [[mapInfoArray objectAtIndex:0] objectAtIndex:1];
            
            for (NSArray* mapInfo in mapInfoArray)
            {
                NSString * key = [mapInfo objectAtIndex:0];
                NSDictionary* info = [mapInfo objectAtIndex:1];
                
                if ([info objectForKey:@"DisplayName"] == UserName) {
                    continue;
                }
                [mapInfolist setObject:info forKey:key];
                
                NSMutableArray *playerImages = [[NSMutableArray alloc] init];
                if([[info objectForKey:@"Role"]  isEqualToString:@"pacman"])
                {
                    [playerImages addObject:[UIImage imageNamed:@"demon-game14.png"]];
                    
                    
                }
                if([[info objectForKey:@"Role"]  isEqualToString:@"bean"])
                {
                    [playerImages addObject:[UIImage imageNamed:@"bean.png"]];
                }
                
                [self addPlayerAnnotationWithCoordinate:CLLocationCoordinate2DMake([[info objectForKey:@"X"] doubleValue], [[info objectForKey:@"Y"] doubleValue]) DisplayMessage:[info objectForKey:@"DisplayName"] AnnotationList:playerImages forKey:key];
        
            }
            
        }
        else
        {
            //get map info failed, should do something here
        }
    };
}

-(MAPointAnnotation*)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [_mapView addAnnotation:annotation];
    return annotation;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height *scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

-(void)addPlayerAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate DisplayMessage:(NSString*)message AnnotationList:(NSMutableArray*)annotationList forKey:(NSString*)key
{
    AnimatedAnnotation* PlayerAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    PlayerAnnotation.animatedImages = annotationList;
    PlayerAnnotation.title          = message;
    
    [PlayerList setObject:PlayerAnnotation forKey:key];
    
    [_mapView addAnnotation:PlayerAnnotation];
}



- (void)StartTrackingUserLocation {
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setZoomLevel:30 animated:YES];
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    
    [self.view bringSubviewToFront:self.MenuButton];
    [self.view bringSubviewToFront:self.menuItemView];
    self.menuItemView.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.1];
    GameGridRow = nil;
    
    [self.view bringSubviewToFront:_gameInfoView];
    [self.view bringSubviewToFront:self.ChatButton];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PlayerList = [NSMutableDictionary dictionaryWithCapacity:100000];
    
    [self StartTrackingUserLocation];
    
    [pomelo onRoute:@"onPlayerUpdate" withCallback:self.onPlayerUpdateCallback];
    [pomelo onRoute:@"onMapUpdate" withCallback:self.onMapUpdateCallback];
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [self.menuItemView setAnimationStartFromHere:self.MenuButton.frame];
    
    NSDictionary *params = @{@"gameid":GameID,@"userid":UserName};
    [pomelo requestWithRoute:@"game.gameHandler.querymap"
                   andParams:params andCallback:self.drawMap];
    
}

-(IBAction) OnStopButtonClicked:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *params = @{@"userid":[userDefault objectForKey:@"name"],@"gameid":GameID};
    
    [pomelo requestWithRoute:@"game.gameHandler.stop"
                   andParams:params andCallback:^(NSDictionary *result){
                       
                       NSLog((NSString*)[result objectForKey:@"players"]);
                   }];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        AnimatedAnnotationView *annotationView = (AnimatedAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[AnimatedAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:animatedAnnotationIdentifier];
            
            annotationView.canShowCallout   = YES;
            annotationView.draggable        = YES;
        }
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *beanView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (beanView == nil)
        {
            beanView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            beanView.canShowCallout = NO;
            beanView.draggable = NO;
            //beanView.calloutOffset = CGPointMake(0, -5);
        }
        
        beanView.portrait = [UIImage imageNamed:@"bean.png"];
        
        return beanView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MAAnnotationView *view = views[0];
//    // 放到该方法中用以保证 userlocation 的 annotationView 已经添加到地图上了。
//    if (!bSetUserLocation && [view.annotation isKindOfClass:[MAUserLocation class]])
//    {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//    
//        pre.image = [UIImage imageNamed:@"bean.png"];
//        pre.lineWidth = 0;
//        pre.showsAccuracyRing = NO;
//        pre.lineDashPattern = @[@6, @3];
//        [_mapView updateUserLocationRepresentation:pre];
//       // view.calloutOffset = CGPointMake(0, 0);
//        
//        bSetUserLocation = true;
//    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_mapView setCompassImage:nil];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        NSString * Message = [NSString stringWithFormat:@"report 1\r\n%f:%f\r\n", userLocation.coordinate.latitude,userLocation.coordinate.longitude];

        if (!bInitSelfPresentation)
        {
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            
            pre.image = [UIImage imageNamed:@"transparent.png"];
            pre.lineWidth = 0;
            pre.showsAccuracyRing = NO;
            pre.lineDashPattern = @[@6, @3];
            [_mapView updateUserLocationRepresentation:pre];
            
            
            NSMutableArray *trainImages = [[NSMutableArray alloc] init];
            
            [trainImages addObject:[UIImage imageNamed:@"demon-game.png"]];
            
            mySelfAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:userLocation.coordinate];
            mySelfAnnotation.animatedImages = trainImages;
            [_mapView addAnnotation:mySelfAnnotation];
            bInitSelfPresentation = true;
        }
        else
            mySelfAnnotation.coordinate = userLocation.coordinate;
        
        NSDictionary *params = @{@"userid":UserName,
                                 @"x":[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude]
                                 ,@"y":[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude]};
        
        [pomelo notifyWithRoute:@"game.gameHandler.report" andParams:params];
        
    }
    
}

-(IBAction) chatButtonClicked:(id)sender
{
    if (bChatButtonEnabled)
    {
        bChatButtonEnabled = false;
        [self.ChatButton setBackgroundImage:[UIImage imageNamed:@"Microphone Disabled"] forState:UIControlStateNormal];
    }
    else
    {
        bChatButtonEnabled = true;
        [self.ChatButton setBackgroundImage:[UIImage imageNamed:@"Microphone Pressed"] forState:UIControlStateNormal];
    }
}

-(void) SetGameID:(NSString*)gameID
{
    GameID = gameID;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)appendEventLog:(NSString *)log
//{
//    NSString *time = [_eventLogTimeFormatter stringFromDate:[NSDate date]];
//    NSString *eventLog = [NSString stringWithFormat:@"%@ %@\n", time, log];
//    [_eventLog insertString:eventLog atIndex:0];
//    _eventTextView.text = _eventLog;
//    [_eventTextView scrollRangeToVisible:NSMakeRange(0, 0)];
//}
//
//- (IBAction)muteButtonPressed:(id)sender {
//    BOOL mute = [[NRTCManager sharedManager] audioMuteEnabled];
//    [self appendEventLog:[NSString stringWithFormat:@"self %@ audio", !mute ? @"muted": @"unmuted"]];
//    [[NRTCManager sharedManager] setAudioMute:!mute];
//}
//
////语音静音
//- (void)onUserMuteAudio:(BOOL)isMute uid:(SInt64)uid channel:(NRTCChannel *)channel
//{
//    [self appendEventLog:[NSString stringWithFormat:@"%lld %@ audio, channel is %llu", uid, isMute ? @"muted": @"unmuted", [channel channelID]]];
//}
//
//- (void)onAudioInterruptionStart
//{
//    [self appendEventLog:@"Audio Interrupted!!!"];
//}
//
//- (void)onAudioInterruptionEnd
//{
//    [self appendEventLog:@"Audio interruption end :)"];
//}
//
//
//- (void)onNetworkQuality:(NRTCNetworkQuality)quality
//{
//    NSDictionary *netQualityTexts = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     @"Network Excellent", @(NRTCNetworkQualityExcellent),
//                                     @"Network Good", @(NRTCNetworkQualityGood),
//                                     @"Network Poor", @(NRTCNetworkQualityPoor),
//                                     @"Network Bad", @(NRTCNetworkQualityBad), nil];
//    [self appendEventLog:[netQualityTexts objectForKey:@(quality)]];
//}

@end
