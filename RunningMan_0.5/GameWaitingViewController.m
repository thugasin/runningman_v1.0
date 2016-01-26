//
//  GameWaitingViewController.m
//  RunningMan_0.5
//
//  Created by Sirius on 15/10/14.
//  Copyright © 2015年 Sirius. All rights reserved.
//

#import "GameWaitingViewController.h"
#import "PacManMainGameViewController.h"

@interface GameWaitingViewController ()

@property (nonatomic,copy) PomeloWSCallback onJoinCallback;
@property (nonatomic,copy) PomeloWSCallback onLeaveCallback;
@property (nonatomic,copy) PomeloWSCallback getUserListBlock;
@property (nonatomic,copy) PomeloWSCallback onGameStartCallback;

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
    [self InitGameStartCallback];
    
    [pomelo onRoute:@"onJoin" withCallback:self.onJoinCallback];
    [pomelo onRoute:@"onLeave" withCallback:self.onLeaveCallback];
    [pomelo onRoute:@"onStart" withCallback:self.onGameStartCallback];
    
}

- (void)InitGetUserListBlock
{
    self.getUserListBlock = ^(NSDictionary *result){
        
        if ([[result objectForKey:@"success"] boolValue])
        {
            NSData * playerList = [[result objectForKey:@"players"] dataUsingEncoding:NSUTF8StringEncoding];
            
            list = [NSJSONSerialization JSONObjectWithData:playerList options:kNilOptions error:nil];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainGameView"];
        [(PacManMainGameViewController*)mainViewController SetGameID:GameID];
        [self presentViewController:mainViewController animated:YES completion:^{
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

-(IBAction)OnStartGameButtonClicked:(id)sender
{
    NSDictionary *params = @{@"gameid":GameID};
    [pomelo requestWithRoute:@"game.gameHandler.start"
                   andParams:params andCallback:self.onGameStartCallback];
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
