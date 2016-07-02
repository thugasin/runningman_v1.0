//
//  ViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "PacManMainGameViewController.h"
#import "NRTC/include/NRTC/NRTC.h"
#import "GameStateTableViewCell.h"
#import "LMAlertView.h"

@interface PacManMainGameViewController ()

@property (nonatomic,copy) PomeloWSCallback onPlayerUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback onMapUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback onPlayerItemUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback onStateUpdateCallback;
@property (nonatomic,copy) PomeloWSCallback drawMap;


@end

@implementation PacManMainGameViewController
@synthesize GameGridRow;
@synthesize GameGridColunm;
@synthesize PlayerList;
@synthesize UserName;
@synthesize GameID;

static NSString* CellTableIdentifier = @"CellTableIdentifier";

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
    myState = INACTIVE;
    
    pomelo = [PomeloWS GetPomelo];
    
    annotationWidth = 50.0;
    annotationHeight = 50.0;
    
    [self InitDrawMap];
    
    [self InitPlayerUpdate];
    [self InitMapUpdate];
    [self InitStateUpdate];
    [self InitItemUpdate];

    
    ImageHandler *imangeHandler = [ImageHandler GetImageHandler];
    NSArray* list = [imangeHandler.ImageDataDictionary objectForKey:@"Angel&deamon"];
    
    imageDictionary = [list objectAtIndex:0];
    
    
    ItemHandler *itemHandler = [ItemHandler GetItemHandler];
    NSArray* listOfItem = [itemHandler.ItemInfoDictionary objectForKey:@"Angel&deamon"];
    itemDictionary = [listOfItem objectAtIndex:0];
   
    StateHandler *stateHandler = [StateHandler GetStateHandler];
    NSArray* listOfState = [stateHandler.StateResourceDictionary objectForKey:@"Angel&deamon"];
    stateResourceInfo = [listOfState objectAtIndex:0];

    
    // Set the 'menu button
    [self.MenuButton initAnimationWithFadeEffectEnabled:NO]; // Set to 'NO' to disable Fade effect between its two-state transition
    
    itemList = [NSMutableArray arrayWithCapacity:3];  // need configurable
    
    [self SetupItemMenu];
    
    gameInfoTableView.showsVerticalScrollIndicator = NO;
    // 设置TableView显示的位置
    //gameInfoTableView.center = CGPointMake(320 / 2, 66);
    gameInfoTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:gameInfoTableView];
    [gameInfoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    gameInfoTableView.rowHeight = 100;
    UINib *nib = [UINib nibWithNibName:@"GameStateUITableCell" bundle:nil];
    [gameInfoTableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
//    NRTCAppKey = @"172035d172c98670557c20d01b8a774e";
//    [self joinChatRoom];
    
//    bChatButtonEnabled = ![[NRTCManager sharedManager] audioMuteEnabled];
    bChatButtonEnabled = false;
    
    bIsInTestingMode = false;
    bIsItemInUsing = false;
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

- (void)SetupItemMenu {
    // Get the 'menu item view' from storyboard
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuItemsVC = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ArchMenu"];
    self.menuItemView = (BounceButtonView *)menuItemsVC.view;
    [self.menuItemView SetController:self];
    
    [self.menuItemView.menuItem1 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.menuItemView.menuItem2 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.menuItemView.menuItem3 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects:self.menuItemView.menuItem1,
                                   self.menuItemView.menuItem2,
                                   self.menuItemView.menuItem3,
                                   nil]; // Add all of the defined 'menu item button' to 'menu item view'
    [self.menuItemView addBounceButtons:arrMenuItemButtons];
    
    // Set the bouncing distance, speed and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    
    [self.menuItemView setAnimationStyle:ASOAnimationStyleRiseProgressively];
    [self SetupItemmenuDragEvents];
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

-(void) PopupMessageByState
{
    NSString* popupMessage;
    NSString* imageIdentifier;
    
    switch (myState) {
        case DEAD:
            popupMessage=@"你被和谐了";
            imageIdentifier = @"RoleDead";
            break;
        case FREEZE:
            popupMessage=@"你被冷冻了";
            imageIdentifier = @"RoleDead";  //之后再加图片
            
        default:
            break;
    }
    LMAlertView *cardAlertView = [[LMAlertView alloc] initWithTitle:popupMessage message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    
    [cardAlertView setSize:CGSizeMake(270.0, 167.0)];
    
    UIView *contentView = cardAlertView.contentView;
    
    CGFloat yOffset = 55.0;
    
    ImageHandler *imangeHandler = [ImageHandler GetImageHandler];
    NSArray* list = [imangeHandler.ImageDataDictionary objectForKey:@"Angel&deamon"];
    NSDictionary *imageDictionary = [list objectAtIndex:0];
    
    UIImage *card1Image= [UIImage imageNamed:[[imageDictionary objectForKey:_RoleOfMyself] objectForKey:imageIdentifier]];
    UIGraphicsBeginImageContext( CGSizeMake(110.4, 63.6) );
    [card1Image drawInRect:CGRectMake(0,0,110.4, 63.6)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *card1ImageView= [[UIImageView alloc] initWithImage:newImage];
    
    
    card1ImageView.frame = CGRectMake(80, yOffset, card1ImageView.frame.size.width, card1ImageView.frame.size.height);
    card1ImageView.layer.cornerRadius = 5.0;
    card1ImageView.layer.masksToBounds = YES;
    [contentView addSubview:card1ImageView];
    
    
    [cardAlertView show];

}

-(void) InitPlayerUpdate
{
    self.onPlayerUpdateCallback = ^(NSDictionary* playerInfo)
    {
        NSString* userGoID = [NSString stringWithFormat:@"player_%@",UserName];
        if ([[playerInfo objectForKey:@"userid"] isEqualToString:[NSString stringWithFormat:@"player_%@",UserName]]) {
            if([playerInfo objectForKey:@"state"]!=nil)
            {
                
                if(mySelfAnnotation!=nil)
                {
                    NSDictionary* annotationImageInfo = [[imageDictionary objectForKey:_RoleOfMyself] objectForKey:[playerInfo objectForKey:@"state"]];
                    
                    if([[playerInfo objectForKey:@"state"] isEqualToString:@"Dead"])
                        myState = DEAD;
                    [self PopupMessageByState];
                    
                    NSMutableArray* imageList = [NSMutableArray arrayWithCapacity:20];
                    
                    for (NSString *imageRef in [annotationImageInfo objectForKey:@"images"]) {
                        [imageList addObject:[UIImage imageNamed:imageRef]];
                    }
                    
                    mySelfAnnotation.animatedImages = imageList;
                    mySelfAnnotation.animationRepeatCount=[[annotationImageInfo objectForKey:@"repeatCount"] doubleValue];
                    mySelfAnnotation.width=[[annotationImageInfo objectForKey:@"width"] doubleValue];
                    mySelfAnnotation.height=[[annotationImageInfo objectForKey:@"height"] doubleValue];
                    mySelfAnnotation.identifier = [annotationImageInfo objectForKey:@"identifier"];
                    
                    
                    [_mapView removeAnnotation:mySelfAnnotation];
                    [_mapView addAnnotation:mySelfAnnotation];
                    self.MenuButton.enabled = false;
                }
            }
            return;
        }
        
        
        AnimatedAnnotation* playerAnnotation = [PlayerList objectForKey:[NSString stringWithFormat:@"player_%@",[playerInfo objectForKey:@"userid"]]];
        
        
        if(playerAnnotation != nil)
        {
            
            if([playerInfo objectForKey:@"state"]!=nil)
            {
                NSDictionary* annotationImageInfo = [[imageDictionary objectForKey:_RoleOfMyself] objectForKey:[playerInfo objectForKey:@"state"]];
                
                NSMutableArray* imageList = [NSMutableArray arrayWithCapacity:20];
                
                for (NSString *imageRef in [annotationImageInfo objectForKey:@"images"]) {
                    [imageList addObject:[UIImage imageNamed:imageRef]];
                }
                
                playerAnnotation.animatedImages = imageList;
                playerAnnotation.animationRepeatCount=[[annotationImageInfo objectForKey:@"repeatCount"] doubleValue];
                playerAnnotation.width=[[annotationImageInfo objectForKey:@"width"] doubleValue];
                playerAnnotation.height=[[annotationImageInfo objectForKey:@"height"] doubleValue];
                playerAnnotation.identifier = [annotationImageInfo objectForKey:@"identifier"];
                
                [_mapView removeAnnotation:playerAnnotation];
                [_mapView addAnnotation:playerAnnotation];
                
                if([annotationImageInfo objectForKey:@"annimation"] !=nil)
                {
                    NSDictionary* annimationInfo = [annotationImageInfo objectForKey:@"annimation"];
                    [self addPlayerAnnotationWithCoordinate:playerAnnotation.coordinate DisplayMessage:@"" AnnotationList:annimationInfo forKey:nil];
                }
            }
            
            if([playerInfo objectForKey:@"x"] !=nil)
                playerAnnotation.coordinate = CLLocationCoordinate2DMake([[playerInfo objectForKey:@"x"] doubleValue],[[playerInfo objectForKey:@"y"] doubleValue]);
        }
        
    };
}

-(void) InitMapUpdate
{
    self.onMapUpdateCallback = ^(NSDictionary* mapInfo)
    {
        if(![PlayerList objectForKey:[mapInfo objectForKey:@"goid"]])
             return;
                
        NSDictionary * mapInfoData = [mapInfo objectForKey:@"go"];
        if ([[[mapInfoData objectForKey:@"CloneRole"]  objectForKey:@"HealthPoint"] longValue]<=0)
        {
            AnimatedAnnotation* playerAnnotation = [PlayerList objectForKey:[mapInfo objectForKey:@"goid"]];
            [_mapView removeAnnotation:playerAnnotation];
            [PlayerList removeObjectForKey:[mapInfo objectForKey:@"goid"]];
        }
        
    };
}

-(void) InitItemUpdate
{
    self.onPlayerItemUpdateCallback = ^(NSDictionary* playerItemInfo)
    {
        if ([playerItemInfo objectForKey:@"userid"] == [NSString stringWithFormat:@"player_%@",UserName]) {
            return;
        }
        
        NSArray *items = [playerItemInfo objectForKey:@"items"];
        itemList = [NSMutableArray arrayWithArray:items];
        
        [self MenuItemUpdate];
    };
}

-(void) MenuItemUpdate
{
    [self.menuItemView.menuItem1 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.menuItemView.menuItem2 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.menuItemView.menuItem3 setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    
    if(itemList.count>0)
        [self.menuItemView.menuItem1 setBackgroundImage:[UIImage imageNamed:[itemList objectAtIndex:0]] forState:UIControlStateNormal];
    if(itemList.count>1)
        [self.menuItemView.menuItem2 setBackgroundImage:[UIImage imageNamed:[itemList objectAtIndex:1]] forState:UIControlStateNormal];
    if(itemList.count>2)
        [self.menuItemView.menuItem3 setBackgroundImage:[UIImage imageNamed:[itemList objectAtIndex:2]] forState:UIControlStateNormal];
        
}

-(void) InitStateUpdate
{
    self.onStateUpdateCallback = ^(NSDictionary* stateInfo)
    {
        
        NSArray *array = [stateInfo objectForKey:@"state"];
        
        if(stateArray == nil)
        {
            stateArray = [NSMutableArray arrayWithArray:array];
            [gameInfoTableView reloadData];
            return;
        }
        
        for (int i=0;i< array.count;i++)
        {
            if(![[[array objectAtIndex:i] objectForKey:@"value"] isEqual:[[stateArray objectAtIndex:i] objectForKey:@"value"]])
            {
                [stateArray setObject:[array objectAtIndex:i] atIndexedSubscript:i];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSMutableArray* arr = [NSMutableArray arrayWithCapacity:1];
                [arr addObject:[[NSArray arrayWithObjects:indexPath, nil] objectAtIndex:0]];
                
                [gameInfoTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
            }
        }
      //  [gameInfoTableView reloadData];
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
                
                if ([[info objectForKey:@"DisplayName"] isEqualToString:UserName]) {
                    continue;
                }
                
                
                NSMutableArray *playerImages = [[NSMutableArray alloc] init];
                
                NSDictionary* annotationImageInfo = [[imageDictionary objectForKey:[info objectForKey:@"Role"]] objectForKey:@"Normal"];
                
                double initX =0;
                double initY =0;
                if(![[info objectForKey:@"X"] isEqual:[NSNull null]])
                {
                    initX = [[info objectForKey:@"X"] doubleValue];
                    initY = [[info objectForKey:@"Y"] doubleValue];
                }
                    
                [self addPlayerAnnotationWithCoordinate:CLLocationCoordinate2DMake(initX, initY) DisplayMessage:[info objectForKey:@"DisplayName"] AnnotationList:annotationImageInfo forKey:key];
        
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

-(void)addPlayerAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate DisplayMessage:(NSString*)message AnnotationList:(NSDictionary*)annotationImageInfo forKey:(NSString*)key
{
    AnimatedAnnotation* PlayerAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    
    NSMutableArray* imageList = [NSMutableArray arrayWithCapacity:20];
    
    for (NSString *imageRef in [annotationImageInfo objectForKey:@"images"]) {
        [imageList addObject:[UIImage imageNamed:imageRef]];
    }
    
    PlayerAnnotation.animatedImages = imageList;
    PlayerAnnotation.title          = message;
    PlayerAnnotation.width = [[annotationImageInfo objectForKey:@"width"] doubleValue];
    PlayerAnnotation.height = [[annotationImageInfo objectForKey:@"height"] doubleValue];
    PlayerAnnotation.identifier = [annotationImageInfo objectForKey:@"identifier"];
    PlayerAnnotation.animationRepeatCount = [[annotationImageInfo objectForKey:@"repeatCount"] doubleValue];
    
    if(key !=nil)
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
    
    //设置允许后台定位参数，保持不会被系统挂起
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    _mapView.scrollEnabled = YES;
    _mapView.zoomEnabled = YES;
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    
    [self.view bringSubviewToFront:self.MenuButton];
    [self.view bringSubviewToFront:self.menuItemView];
    self.menuItemView.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.1];
    GameGridRow = nil;
    
    [self.view bringSubviewToFront:_gameInfoView];
    [self.view bringSubviewToFront:self.ChatButton];
  //  [self.view addSubview:fireView];
  //  [self.view bringSubviewToFront:fireView];
    fire = [UIEffectDesignerView effectWithFile:@"snow.ped"];
    [self.view addSubview: fire];
    [self.view bringSubviewToFront:fire];
    [fire setHidden:true];
    [self.view bringSubviewToFront:gameInfoTableView];
    [self.view bringSubviewToFront:testingModeButton];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PlayerList = [NSMutableDictionary dictionaryWithCapacity:100000];
    
    [self StartTrackingUserLocation];
    
    [pomelo onRoute:@"onPlayerUpdate" withCallback:self.onPlayerUpdateCallback];
    [pomelo onRoute:@"onMapUpdate" withCallback:self.onMapUpdateCallback];
    [pomelo onRoute:@"onStateUpdate" withCallback:self.onStateUpdateCallback];
    [pomelo onRoute:@"onPlayerItemUpdate" withCallback:self.onPlayerItemUpdateCallback];
    
    _mapView.showsUserLocation = YES; //YES 为打开定位,NO 为关闭定位
    
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [self.menuItemView setAnimationStartFromHere:self.MenuButton.frame];
    
    NSDictionary *params = @{@"gameid":GameID,@"userid":UserName};
    [pomelo requestWithRoute:@"game.gameHandler.querymap"
                   andParams:params andCallback:self.drawMap];
    
}

-(IBAction) OnStopButtonClicked:(id)sender
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    
//    NSDictionary *params = @{@"userid":[userDefault objectForKey:@"name"],@"gameid":GameID};
//    
//    [pomelo requestWithRoute:@"game.gameHandler.stop"
//                   andParams:params andCallback:^(NSDictionary *result){
//                       
//                       NSLog((NSString*)[result objectForKey:@"players"]);
//                   }];
    if(_mapView.showsUserLocation == YES)
    {
        [fire setHidden:false];
        _mapView.showsUserLocation = NO;
        _mapView.zoomEnabled = NO;
        _mapView.scrollEnabled = NO;
        bIsInTestingMode = true;
    }
    else
    {
        [fire setHidden:true];
        _mapView.showsUserLocation = YES;
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        
        _mapView.showsScale = NO;
        _mapView.showsCompass = NO;
        
        
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        
        pre.image = [UIImage imageNamed:@"transparent.png"];
        pre.lineWidth = 0;
        pre.showsAccuracyRing = NO;
        pre.lineDashPattern = @[@6, @3];
        [_mapView updateUserLocationRepresentation:pre];
        
        bIsInTestingMode = false;
    }
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        AnimatedAnnotation* animatedAnotation = annotation;
        
        AnimatedAnnotationView *annotationView = (AnimatedAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnotation.identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[AnimatedAnnotationView alloc] initWithAnimatedAnnotation:annotation];
            
            annotationView.draggable        = YES;   //tempaorally set as draggable for test
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *customReuseIndetifier = @"customReuseIndetifier";
//        
//        CustomAnnotationView *beanView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
//        
//        if (beanView == nil)
//        {
//            beanView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
//            // must set to NO, so we can show the custom callout view.
//            beanView.canShowCallout = NO;
//            beanView.draggable = NO;
//            //beanView.calloutOffset = CGPointMake(0, -5);
//        }
//        
//        beanView.portrait = [UIImage imageNamed:@"bean.png"];
//        
//        return beanView;
//    }
    
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
        if(myState == DEAD)
        {
            //do nothing, just update my position, user should not move
        }

        if (myState == INACTIVE)
        {
            MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
            
            pre.image = [UIImage imageNamed:@"transparent.png"];
            pre.lineWidth = 0;
            pre.showsAccuracyRing = NO;
            pre.lineDashPattern = @[@6, @3];
            [_mapView updateUserLocationRepresentation:pre];
            
            
            NSMutableArray *trainImages = [[NSMutableArray alloc] init];
            
            NSDictionary* annotationImageInfo = [[imageDictionary objectForKey:_RoleOfMyself] objectForKey:@"Normal"];
            
            for (NSString*CGImageRef in [annotationImageInfo objectForKey:@"images"]) {
                [trainImages addObject:[UIImage imageNamed:CGImageRef]];
            }
            
            
            mySelfAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:userLocation.coordinate];
            mySelfAnnotation.animatedImages = trainImages;
            mySelfAnnotation.title          = @"你";
            mySelfAnnotation.animationRepeatCount=[[annotationImageInfo objectForKey:@"repeatCount"] doubleValue];
            mySelfAnnotation.width=[[annotationImageInfo objectForKey:@"width"] doubleValue];
            mySelfAnnotation.height=[[annotationImageInfo objectForKey:@"height"] doubleValue];
            mySelfAnnotation.identifier = [annotationImageInfo objectForKey:@"identifier"];
            [_mapView addAnnotation:mySelfAnnotation];
            myState = ACTIVE;
        }
        else if(myState == ACTIVE)
        {
            mySelfAnnotation.coordinate = userLocation.coordinate;
        }
        
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
        bChatButtonEnabled = false; //set false to not set as mute
        [self.ChatButton setBackgroundImage:[UIImage imageNamed:@"Microphone Disabled"] forState:UIControlStateNormal];
    }
    else
    {
        bChatButtonEnabled = true;
        [self.ChatButton setBackgroundImage:[UIImage imageNamed:@"Microphone Pressed"] forState:UIControlStateNormal];
    }
    [[NRTCManager sharedManager] setAudioMute:!bChatButtonEnabled];
}

-(void) SetGameID:(NSString*)gameID
{
    GameID = gameID;
}

-(void)AddEffectAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate EffectName:(NSString*)effectName
{
    AnimatedAnnotation* EffectAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    
    NSMutableArray* imageList = [NSMutableArray arrayWithCapacity:20];
    
    for (NSString *imageRef in [[[imageDictionary objectForKey:effectName] objectForKey:@"Effect" ] objectForKey:@"images"]) {
        [imageList addObject:[UIImage imageNamed:imageRef]];
    }
    
    EffectAnnotation.animatedImages = imageList;
    EffectAnnotation.width = [[[[imageDictionary objectForKey:effectName] objectForKey:@"Effect" ] objectForKey:@"width"] doubleValue];
    EffectAnnotation.height = [[[[imageDictionary objectForKey:effectName] objectForKey:@"Effect" ] objectForKey:@"height"] doubleValue];
    EffectAnnotation.identifier = [[[imageDictionary objectForKey:effectName] objectForKey:@"Effect" ] objectForKey:@"identifier"];
    EffectAnnotation.animationRepeatCount = [[[[imageDictionary objectForKey:effectName] objectForKey:@"Effect" ] objectForKey:@"repeatCount"] doubleValue];
    
    [_mapView addAnnotation:EffectAnnotation];
}


-(void) MenuTouchedAction:(int)itemIndex
{
//    NSString* itemAction = [[itemDictionary objectForKey:[itemList objectAtIndex:itemIndex]] objectForKey:@"actionType"];
//    
//    if([itemAction isEqualToString:@"click"])
//    {
//        NSDictionary *params = @{@"gameid":GameID,@"userid":UserName,
//                                 @"itemIndex":[NSString stringWithFormat:@"%d",itemIndex],@"x":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.latitude],@"y":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.longitude]};
//        
//        [pomelo requestWithRoute:@"game.gameHandler.useitem"
//                       andParams:params andCallback:^(NSDictionary *result){
//                           
//                           NSLog((NSString*)[result objectForKey:@"message"]);
//                           if ([[result objectForKey:@"success"] boolValue])
//                           {
//                               [self AddEffectAnnotationWithCoordinate:mySelfAnnotation.coordinate EffectName:[itemList objectAtIndex:itemIndex]];
//                               [itemList removeObjectAtIndex:itemIndex];
//                               [self MenuItemUpdate];
//                           }
//                           
//                       }];
//    }
//    if([itemAction isEqualToString:@"drag"])
//    {
//        
//    }

    
}

-(void) SetupItemmenuDragEvents
{
    // Set as delegate of 'menu item view'
    [self.menuItemView setDelegate:self];
    [_menuItemView.menuItem3 addTarget:self action:@selector(menuItem3_touchDragInsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragInside];
    
    [_menuItemView.menuItem3 addTarget:self action:@selector(touchDragOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragOutside];
    
    [_menuItemView.menuItem3 addTarget:self action:@selector(touchUpOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_menuItemView.menuItem2 addTarget:self action:@selector(menuItem2_touchDragInsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragInside];
    
    [_menuItemView.menuItem2 addTarget:self action:@selector(touchDragOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragOutside];
    
    [_menuItemView.menuItem2 addTarget:self action:@selector(touchUpOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchUpOutside];

    [_menuItemView.menuItem1 addTarget:self action:@selector(menuItem1_touchDragInsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragInside];
    
    [_menuItemView.menuItem1 addTarget:self action:@selector(touchDragOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchDragOutside];
    
    [_menuItemView.menuItem1 addTarget:self action:@selector(touchUpOutsideDblTapSignButE:event:) forControlEvents:UIControlEventTouchUpOutside];
    
}

-(void) MenuDraggedAction:(int)itemIndex Location:(CGPoint)location
{
    [fire setHidden:false];
    fire.center = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //  fire.center = [(UITouch *)[touches anyObject] locationInView:self.menuItemView];
    
    if(bIsInTestingMode)
    {
        mySelfAnnotation.coordinate = [_mapView convertPoint:[(UITouch *)[touches anyObject] locationInView:_mapView] toCoordinateFromView:_mapView];
        
        NSDictionary *params = @{@"userid":UserName,
                                 @"x":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.latitude]
                                 ,@"y":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.longitude]};
        
        [pomelo notifyWithRoute:@"game.gameHandler.report" andParams:params];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(bIsInTestingMode)
    {
        //   fire.center = [(UITouch *)[touches anyObject] locationInView:self.menuItemView];
        mySelfAnnotation.coordinate = [_mapView convertPoint:[(UITouch *)[touches anyObject] locationInView:_mapView] toCoordinateFromView:_mapView];
        
        NSDictionary *params = @{@"userid":UserName,
                                 @"x":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.latitude]
                                 ,@"y":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.longitude]};
        
        [pomelo notifyWithRoute:@"game.gameHandler.report" andParams:params];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 //   [fireView setIsEmitting:NO];
 //   mySelfAnnotation.coordinate =[(UITouch *)[touches anyObject] locationInView:_mapView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [fireView setIsEmitting:NO];
}

- (void) menuItem1_touchDragInsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    draggedMenuItem = _menuItemView.menuItem1;
    menuItemTobeUsedIndex =0;
    [self touchDragInsideDblTapSignButE:sender event:event];
}

- (void) menuItem2_touchDragInsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    draggedMenuItem = _menuItemView.menuItem2;
    menuItemTobeUsedIndex =1;
    [self touchDragInsideDblTapSignButE:sender event:event];
}

- (void) menuItem3_touchDragInsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    draggedMenuItem = _menuItemView.menuItem3;
    menuItemTobeUsedIndex =2;
    [self touchDragInsideDblTapSignButE:sender event:event];
}

- (void) touchDragInsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    
    if(itemList.count<menuItemTobeUsedIndex+1)  //no item on such menu
        return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    NSLog(@"Location x%f y%f",location.x,location.y);
    
   // [self MenuDraggedAction:2 Location:_menuItemView.menuItem3.center];
    [self MenuDraggedAction:menuItemTobeUsedIndex Location:CGPointMake(location.x-draggedMenuItem.frame.size.width/2+draggedMenuItem.center.x, location.y-draggedMenuItem.frame.size.height/2+draggedMenuItem.center.y)];
}

- (void) touchDragOutsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    
    if(itemList.count<menuItemTobeUsedIndex+1)  //no item on such menu
        return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    NSLog(@"Location x%f y%f",location.x,location.y);
    
    [self MenuDraggedAction:menuItemTobeUsedIndex Location:CGPointMake(location.x-draggedMenuItem.frame.size.width/2+draggedMenuItem.center.x, location.y-draggedMenuItem.frame.size.height/2+draggedMenuItem.center.y)];
}

- (void) touchUpOutsideDblTapSignButE:(id)sender event:(UIEvent *)event {
    if(bIsItemInUsing)
        return;
    bIsItemInUsing = true;
    if(itemList.count<menuItemTobeUsedIndex+1)  //no item on such menu
    {
        bIsItemInUsing = false;
        return;
    }
    
    NSString* itemAction = [[itemDictionary objectForKey:[itemList objectAtIndex:menuItemTobeUsedIndex]] objectForKey:@"actionType"];
    
    if([itemAction isEqualToString:@"click"])
    {
        NSDictionary *params = @{@"gameid":GameID,@"userid":UserName,
                                 @"itemIndex":[NSString stringWithFormat:@"%d",menuItemTobeUsedIndex],@"x":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.latitude],@"y":[NSString stringWithFormat:@"%f",mySelfAnnotation.coordinate.longitude]};
        
        [self AddEffectAnnotationWithCoordinate:mySelfAnnotation.coordinate EffectName:[itemList objectAtIndex:menuItemTobeUsedIndex]];
        [itemList removeObjectAtIndex:menuItemTobeUsedIndex];
        [self MenuItemUpdate];
        
        [pomelo requestWithRoute:@"game.gameHandler.useitem"
                       andParams:params andCallback:^(NSDictionary *result){
                           
                           NSLog((NSString*)[result objectForKey:@"message"]);
                           if ([[result objectForKey:@"success"] boolValue])
                           {
                               NSLog(@"use item success");
                           }
                           
                       }];
        bIsItemInUsing = false;
        return;
    }
    
    CLLocationCoordinate2D itemUsedPosition = [_mapView convertPoint:[(UITouch *)[[event allTouches] anyObject] locationInView:_mapView] toCoordinateFromView:_mapView];
    
    if([itemAction isEqualToString:@"drag"])
    {
        NSDictionary *params = @{@"gameid":GameID,@"userid":UserName,
                                 @"itemIndex":[NSString stringWithFormat:@"%d",menuItemTobeUsedIndex],@"x":[NSString stringWithFormat:@"%f",itemUsedPosition.latitude],@"y":[NSString stringWithFormat:@"%f",itemUsedPosition.longitude]};
        
        [pomelo requestWithRoute:@"game.gameHandler.useitem"
                       andParams:params andCallback:^(NSDictionary *result){
                           
                           NSLog((NSString*)[result objectForKey:@"message"]);
                           if ([[result objectForKey:@"success"] boolValue])
                           {
                               [itemList removeObjectAtIndex:menuItemTobeUsedIndex];
                               [self MenuItemUpdate];
                               
                           }
                           bIsItemInUsing = false;
                           
                       }];
        return;
        
    }
    
    
    [_mapView willRemoveSubview:fire];
    [fire removeFromSuperview];
    [_mapView removeAnnotation:mySelfAnnotation];
    NSMutableArray *trainImages = [[NSMutableArray alloc] init];
    
    NSDictionary* annotationImageInfo = [[imageDictionary objectForKey:_RoleOfMyself] objectForKey:@"Freeze"];
    
    for (NSString*CGImageRef in [annotationImageInfo objectForKey:@"images"]) {
        [trainImages addObject:[UIImage imageNamed:CGImageRef]];
    }
    mySelfAnnotation.animatedImages = trainImages;
    [_mapView addAnnotation:mySelfAnnotation];
    
    
    [self AddEffectAnnotationWithCoordinate:mySelfAnnotation.coordinate EffectName:@"angelFreeze"];
}

//######## audio chat
- (void)joinChatRoom
{
    
//        NRTCChannel *channel = [[NRTCChannel alloc] init];
//        channel.channelName = @"tempName";
//        channel.channelMode = NRTCChannelModeAudio;
//        channel.myUid = [GameID intValue];
//        channel.appKey = NRTCAppKey;
//        channel.meetingMode = YES;
//        channel.meetingRole = NRTCMeetingRoleActor;
//    
//    
//        NSError *error = [[NRTCManager sharedManager] joinChannel:channel delegate:self];
}
//######### audio chat end

//##### game State
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GameStateTableViewCell *cell = [gameInfoTableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    NSDictionary* state = [stateArray objectAtIndex:indexPath.row];
    
    
    if(state!=nil){
        if([[state objectForKey:@"role"] isEqualToString:@"timer"])
        {
            NSString* time =[state objectForKey:@"value"];
            [cell.score setText:time];
        }
        else
        {
            int value =[[state objectForKey:@"value"] intValue];
            [cell.score setText:[NSString stringWithFormat:@"%d",value]];
        }
        
        NSString* imageName =[[stateResourceInfo objectForKey:[state objectForKey:@"role"]] objectForKey:@"image"];
        [cell.scoreImage setImage:[UIImage imageNamed:imageName]];
        
        NSString* displayText =[[stateResourceInfo objectForKey:[state objectForKey:@"role"]] objectForKey:@"displayText"];
        [cell.displayText setText:displayText];
        
    }
 
    [cell.separatorImage setImage:[UIImage imageNamed:@"separator"]];
    
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width/stateResourceInfo.count;//设置横向cell的高度
}

- (CGFloat)tableView:(UITableView *)tableView count:(NSIndexPath *)indexPath
{
    return stateResourceInfo.count;//设置横向cell的高度
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return stateResourceInfo.count;
}
//############# game state table end

@end
