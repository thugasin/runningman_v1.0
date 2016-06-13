//
//  SystemConfigurationUIViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/6/9.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "SystemConfigurationUIViewController.h"

@interface SystemConfigurationUIViewController ()

@end

@implementation SystemConfigurationUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _IpAddress.text = @"ayo.org.cn";
    // Do view setup here.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)OnConfirm:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    [userDefaults setObject:_IpAddress.text forKey:@"serverip"];
    [userDefaults synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:mainViewController animated:YES completion:^{
    }];
}

@end
