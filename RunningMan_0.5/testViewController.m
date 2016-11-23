//
//  testViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/11/9.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onButtonClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameResultView"];
//    ((GameResultViewController*)mainViewController).resultArray = [NSMutableArray arrayWithArray:gameResultInfo];
    [self presentViewController:mainViewController animated:YES completion:^{
    }];
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
