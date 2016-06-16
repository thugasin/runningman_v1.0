//
//  GameWaitingViewController.m
//  RunningMan_0.5
//
//  Created by Sirius on 15/10/14.
//  Copyright © 2015年 Sirius. All rights reserved.
//

#import "GameWaitingViewController.h"
#import "PacManMainGameViewController.h"
#import "AMapLocationServices.h"
#import "LMAlertView.h"

@interface GameWaitingViewController ()

@property (nonatomic,copy) PomeloWSCallback onJoinCallback;
@property (nonatomic,copy) PomeloWSCallback onLeaveCallback;
@property (nonatomic,copy) PomeloWSCallback getUserListBlock;
@property (nonatomic,copy) PomeloWSCallback onGameStartCallback;
@property (nonatomic,copy) PomeloWSCallback onRoleAssignedCallback;

@end

@implementation GameWaitingViewController
@synthesize GameID;
@synthesize GameName;
@synthesize tableview;
@synthesize Timmer;
@synthesize title;
@synthesize gametitle;
@synthesize list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gametitle.text = GameName;
    
    pomelo = [PomeloWS GetPomelo];
    
    [self InitGetUserListBlock];
    
    
    NSDictionary *params = @{@"gameid":GameID};
    [pomelo requestWithRoute:@"game.gameHandler.reportusersforgame"
                   andParams:params andCallback:self.getUserListBlock];
    [self InitOnJoinCallback];
    [self InitOnLeaveCallback];
    [self InitRoleAssignment];
    [self InitGameStartCallback];
    
    [pomelo onRoute:@"onJoin" withCallback:self.onJoinCallback];
    [pomelo onRoute:@"onLeave" withCallback:self.onLeaveCallback];
    [pomelo onRoute:@"onStart" withCallback:self.onGameStartCallback];
    [pomelo onRoute:@"onRoleAssigned" withCallback:self.onRoleAssignedCallback];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainGameView"];
    gameController = (PacManMainGameViewController*)mainViewController;
    [(PacManMainGameViewController*)gameController SetGameID:GameID];
    
    [AMapLocationServices sharedServices].apiKey = @"86a9ed1f4d39a5fd8f4843bece27c4ff";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}

- (void)InitGetUserListBlock
{
    self.getUserListBlock = ^(NSDictionary *result){
        
        if ([[result objectForKey:@"success"] boolValue])
        {
            NSData * playerList = [[result objectForKey:@"players"] dataUsingEncoding:NSUTF8StringEncoding];
            
            list = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:playerList options:kNilOptions error:nil]];
            [self.tableview reloadData];
        }
        else
        {
            NSLog([result objectForKey:@"message"]);
        }
    };

}

- (void)InitOnJoinCallback
{
    self.onJoinCallback = ^(NSDictionary *newPlayer)
    {
        [list addObject:[newPlayer objectForKey:@"user"]];
        [self.tableview reloadData];
    };
}

-(void)InitGameStartCallback
{
    self.onGameStartCallback =^(NSDictionary *gameStartNotification)
    {
        
        [self presentViewController:gameController animated:YES completion:^{
            }];
    };

}

- (void)InitOnLeaveCallback
{
    self.onLeaveCallback = ^(NSDictionary *player)
    {
        [list removeObject:[player objectForKey:@"user"]];
        [self.tableview reloadData];
    };
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    list = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"PlayerTableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
        
    }
    
    NSUInteger row = [indexPath row];
    cell.imageView.image = [UIImage imageNamed:@"pacManIcon.jpg"];
    cell.textLabel.text = [self.list objectAtIndex:row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) SetGameID:(NSString*)gameId
{
    GameID = gameId;
}

-(void) SetGameName:(NSString*)gameName
{
    GameName = gameName;
}

-(void) InitRoleAssignment
{
    self.onRoleAssignedCallback = ^(NSDictionary* mapInfo)
    {
        NSString* role =[mapInfo objectForKey:@"role"];
        NSString* instruction =[mapInfo objectForKey:@"instruction"];
        ((PacManMainGameViewController*)gameController).RoleOfMyself = role;
        
        NSString* roleMessage = [NSString stringWithFormat:@"Your Role is: %@",role];
        LMAlertView *cardAlertView = [[LMAlertView alloc] initWithTitle:roleMessage message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [cardAlertView setSize:CGSizeMake(270.0, 167.0)];
        
        UIView *contentView = cardAlertView.contentView;
        
        CGFloat yOffset = 55.0;
        
        ImageHandler *imangeHandler = [ImageHandler GetImageHandler];
        NSArray* list = [imangeHandler.ImageDataDictionary objectForKey:@"Angel&deamon"];
        NSDictionary *imageDictionary = [list objectAtIndex:0];
        
        UIImage *card1Image= [UIImage imageNamed:[[imageDictionary objectForKey:role] objectForKey:@"RoleAssigned"]];
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
    };
}

-(IBAction)OnStartGameButtonClicked:(id)sender
{
    NSDictionary *params = @{@"gameid":GameID,@"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]};
//    [pomelo requestWithRoute:@"game.gameHandler.start"
//                   andParams:params andCallback:self.onGameStartCallback];
    
    [pomelo requestWithRoute:@"game.gameHandler.start"
                   andParams:params andCallback:^(NSDictionary*result){}];

    
}

//- (void)amapLocationManager:(MALocationManager *)manager didUpdateLocation:(CLLocation *)location
//{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    
//    //业务处理
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
