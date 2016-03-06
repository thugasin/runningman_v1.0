//
//  ViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "PacManMainGameViewController.h"


@interface PacManMainGameViewController ()

@property (nonatomic,copy) PomeloWSCallback onPlayerUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback onMapUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback drawMap;

@end

@implementation PacManMainGameViewController
@synthesize GameGridRow;
@synthesize GameGridColunm;
@synthesize PlayerList;
@synthesize StopGameButton;
@synthesize UserName;
@synthesize GameID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UserName = [userDefault objectForKey:@"name"];
    bSetUserLocation = false;
    bInitSelfPresentation = false;
    
    pomelo = [PomeloWS GetPomelo];
    
    [self InitDrawMap];
    
    [self InitPlayerUpdate];
    [self InitMapUpdate];
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
            
//            MAPointAnnotation* beanAnnotation =[PlayerList objectForKey:[mapInfo objectForKey:@"goid"]];
//            [_mapView removeAnnotation:beanAnnotation];
//            [PlayerList removeObjectForKey:[mapInfo objectForKey:@"goid"]];

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
                    [playerImages addObject:[UIImage imageNamed:@"pacman1.png"]];
                    [playerImages addObject:[UIImage imageNamed:@"pacman2.png"]];
                    [playerImages addObject:[UIImage imageNamed:@"pacman3.png"]];
                    
                    
                }
                if([[info objectForKey:@"Role"]  isEqualToString:@"bean"])
                {
                    [playerImages addObject:[UIImage imageNamed:@"bean.png"]];
//                    MAPointAnnotation* beanAnnotation = [self addAnnotationWithCooordinate:CLLocationCoordinate2DMake([[info objectForKey:@"X"] doubleValue], [[info objectForKey:@"Y"] doubleValue])];
//                    [PlayerList setObject:beanAnnotation forKey:key];
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

-(void)GameUpdate

{
//    NSString * Message = [NSString stringWithFormat:@"querymap 1\r\n%@\r\n",GameID];
//    
//    NetworkAdapter *na = [NetworkAdapter InitNetwork];
//    [na SubscribeMessage:QUERYMAP Instance:self];
//    [na sendData:Message];
}
/*
-(void)ONMessageCome:(SocketMessage *)socketMsg
{
    if (socketMsg.Type == QUERYMAP)
    {
        if([socketMsg.argumentList[0]  isEqual: @"0"])
        {
            return;
        }
        if ([socketMsg.argumentList[0]  isEqual: @"2"]) {
            //do something to show the result
            //取消定时器
            [self.Timmer invalidate];
            self.Timmer = nil;
            
            _mapView.showsUserLocation = NO;
            
            NSMutableString* gameResult = socketMsg.argumentList[1];
            for (int i=2; i<socketMsg.argumentNumber -2; i++) {
                gameResult = [NSMutableString stringWithFormat:@"%@\r\n%@",gameResult, socketMsg.argumentList[i]];
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"游戏结束" message:gameResult preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"哦了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           NetworkAdapter *na = [NetworkAdapter InitNetwork];
                                           [na SubscribeMessage:QUERYMAP Instance:self];
                                           [na sendData:@"leavegame 0\r\n"];
                                           
                                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                           id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameSelectionView"];
                                           [self presentViewController:mainViewController animated:YES completion:^{
                                           }];
                                           
                                       }];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if([socketMsg.argumentList[0]  isEqual: @"1"])
        {
            if (!GameGridRow)
            {
                NSString *gridXY = socketMsg.argumentList[1];
                
                NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
                NSArray *gridXYInfo =[gridXY componentsSeparatedByCharactersInSet:CharacterSet];
                
                
                GameGridRow = [NSMutableArray arrayWithCapacity:[[gridXYInfo objectAtIndex:0] integerValue]];
                for (int i=0; i<[[gridXYInfo objectAtIndex:0] integerValue]; i++)
                {
                    NSMutableArray *GridColunm = [NSMutableArray arrayWithCapacity:[[gridXYInfo objectAtIndex:1] integerValue]];
                    for (int j=0; j<[[gridXYInfo objectAtIndex:1] integerValue];j++)
                    {
                        [GridColunm addObject:@"*"];
                    }

                    [GameGridRow addObject:GridColunm];
                    
                }
                
            }
            for (int i=2; i<socketMsg.argumentList.count; i++)
            {
                NSString *mapInfo = socketMsg.argumentList[i];
                NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
                NSArray *GameInfoArray =[mapInfo componentsSeparatedByCharactersInSet:CharacterSet];
                
                if ([[GameInfoArray objectAtIndex:0] isEqual:@"1"])   //静止物体
                {
                    if (GameInfoArray.count != 4) {
                        continue;
                    }
                    NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
                    NSArray *gridIndexXY =[[GameInfoArray objectAtIndex:1] componentsSeparatedByCharactersInSet:CharacterSet];
                    NSArray *positionXY = [[GameInfoArray objectAtIndex:2] componentsSeparatedByCharactersInSet:CharacterSet];
                    NSString* operation = [GameInfoArray objectAtIndex:3];
                    
                    if (([operation isEqual:@"1"]) && [[[GameGridRow objectAtIndex:[[gridIndexXY objectAtIndex:0] integerValue]] objectAtIndex:[[gridIndexXY objectAtIndex:1] integerValue]]  isEqual: @"*"])
                    {
                        MAPointAnnotation* beanAnnotation = [self addAnnotationWithCooordinate:CLLocationCoordinate2DMake([[positionXY objectAtIndex:0] floatValue], [[positionXY objectAtIndex:1] floatValue])];
                        [[GameGridRow objectAtIndex:[[gridIndexXY objectAtIndex:0] integerValue]] replaceObjectAtIndex:[[gridIndexXY objectAtIndex:1] integerValue] withObject:beanAnnotation];
                    }
                    else if(([operation isEqual:@"-1"]) && ![[[GameGridRow objectAtIndex:[[gridIndexXY objectAtIndex:0] integerValue]] objectAtIndex:[[gridIndexXY objectAtIndex:1] integerValue]]  isEqual: @"*"])
                    {
                        MAPointAnnotation* beanAnnotation =[[GameGridRow objectAtIndex:[[gridIndexXY objectAtIndex:0] integerValue]] objectAtIndex:[[gridIndexXY objectAtIndex:1] integerValue]];
                        [_mapView removeAnnotation:beanAnnotation];
                        
                        [[GameGridRow objectAtIndex:[[gridIndexXY objectAtIndex:0] integerValue]] replaceObjectAtIndex:[[gridIndexXY objectAtIndex:1] integerValue] withObject:@"*"];
                    }
        
                }
                else if ([[GameInfoArray objectAtIndex:0] isEqual:@"2"])  //动态物体
                {
                    if ([UserName isEqualToString:[GameInfoArray objectAtIndex:2]]) {
                        continue;
                    }
                    NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
                    NSArray *positionXY = [[GameInfoArray objectAtIndex:1] componentsSeparatedByCharactersInSet:CharacterSet];
                    if([PlayerList objectForKey:[GameInfoArray objectAtIndex:2]]==nil)
                    {
                        [self addPlayerAnnotationWithCoordinate:CLLocationCoordinate2DMake([[positionXY objectAtIndex:0] floatValue], [[positionXY objectAtIndex:1] floatValue]) DisplayMessage:[NSString stringWithFormat:@"%@\r\nScore:%ld", [GameInfoArray objectAtIndex:2],(long)[[GameInfoArray objectAtIndex:3] integerValue]]];
                        
                    }
                    else
                    {
                        AnimatedAnnotation* playerAnnotation = [PlayerList objectForKey:[GameInfoArray objectAtIndex:2]];
                        playerAnnotation.coordinate = CLLocationCoordinate2DMake([[positionXY objectAtIndex:0] floatValue], [[positionXY objectAtIndex:1] floatValue]);
                        playerAnnotation.title = [NSString stringWithFormat:@"%@\r\nScore:%ld", [GameInfoArray objectAtIndex:2],(long)[[GameInfoArray objectAtIndex:3] integerValue]];
                    }
                }
            }
        }
    }
}
*/

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
//    [_mapView selectAnnotation:PlayerAnnotation animated:YES];
}



- (void)StartTrackingUserLocation {
    // Do any additional setup after loading the view, typically from a nib. //配置用户 Key
    [MAMapServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [_mapView setZoomLevel:30 animated:YES];
    
    _mapView.showsUserLocation = NO; //YES 为打开定位,NO 为关闭定位
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    GameGridRow = nil;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.Timmer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(GameUpdate) userInfo:nil repeats:YES];
//    [self.Timmer fire];
    PlayerList = [NSMutableDictionary dictionaryWithCapacity:100000];
    
    [self StartTrackingUserLocation];
    
    [pomelo onRoute:@"onPlayerUpdate" withCallback:self.onPlayerUpdateCallback];
    [pomelo onRoute:@"onMapUpdate" withCallback:self.onMapUpdateCallback];
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [self.view addSubview:StopGameButton];
    
    NSDictionary *params = @{@"gameid":GameID,@"userid":UserName};
    [pomelo requestWithRoute:@"game.gameHandler.querymap"
                   andParams:params andCallback:self.drawMap];
    
//    [self addAnnotationWithCooordinate:_mapView.centerCoordinate];
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
            
            [trainImages addObject:[UIImage imageNamed:@"pacman1.png"]];
            [trainImages addObject:[UIImage imageNamed:@"pacman2.png"]];
            [trainImages addObject:[UIImage imageNamed:@"pacman3.png"]];
            
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

-(void) SetGameID:(NSString*)gameID
{
    GameID = gameID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
