//
//  PacManLoginViewController.m
//  RunningManDemo
//
//  Created by Sirius on 15-4-6.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "PacManLoginViewController.h"
//#import "LocationDemoViewController.h"
#import "GameConfigurationViewController.h"

@interface PacManLoginViewController ()

@end

@implementation PacManLoginViewController

@synthesize phoneNumber;
@synthesize ServerIP;

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
    // Do any additional setup after loading the view.
    ServerIP.text = @"192.168.1.105";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)Login:(id)sender
{
//    LocationDemoViewController *LDViewController = [[LocationDemoViewController alloc] initWithNibName:@"LocationDemoViewController" bundle:nil];
//    LDViewController.title = @"Pac-Man";
//    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
//    customLeftBarButtonItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
//    
//    LDViewController.userID = self.phoneNumber.text;
//    LDViewController.ServerIP = self.ServerIP.text;
//    
//    
//    [self.navigationController pushViewController:LDViewController animated:YES];
    
    GameConfigurationViewController *GameConfigurationVC = [[GameConfigurationViewController alloc] initWithNibName:@"GameConfigurationViewController" bundle:nil];
    GameConfigurationVC.title = @"Pac-Man";
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
   // GameConfigurationVC.userID = self.phoneNumber.text;
  //  GameConfigurationVC.ServerIP = self.ServerIP.text;
    
    
    [self.navigationController pushViewController:GameConfigurationVC animated:YES];
   
    
}

- (IBAction)hidKeyBoard:(id)sender
{
    [self.view endEditing:YES];
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
