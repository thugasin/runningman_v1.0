//
//  ViewController.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/23.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkAdapter.h"
#import "GameSelectionViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize Password;
@synthesize UserId;
@synthesize loginButton;
@synthesize aa;
@synthesize pomelo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    Password.placeholder = @"密码";
    UserId.placeholder = @"用户名／手机号／邮箱号";
    
    NSLog([[NSBundle mainBundle] bundlePath]);
    NSString *strr = [[NSBundle mainBundle] pathForResource:@"ImageMap"
                                    ofType:@"json"
                               inDirectory:@"Configure"];
    
    
   // [self.view setBackgroundColor:[UIColor colorWithRed:71/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithRed:71/255.0 green:175/255.0 blue:30/255.0 alpha:0.8]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[loginButton layer] setCornerRadius:5];
    
    LoginInputViewController *_InputBackground = [[LoginInputViewController alloc] initWithFrame:CGRectMake(20,200,self.view.frame.size.width -40,100)];
    [_InputBackground setBackgroundColor:[UIColor whiteColor]];
    [[_InputBackground layer] setCornerRadius:5];
    [[_InputBackground layer] setMasksToBounds:YES];
    _InputBackground.alpha = 0.7;
    [self.view addSubview:_InputBackground];
    UserId = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-19, 50)];
    [UserId setBackgroundColor:[UIColor clearColor]];
    UserId.placeholder = [NSString stringWithFormat:@"用户名／手机号／邮箱号"];
    
    UserId.layer.cornerRadius = 5.0;
    [_InputBackground addSubview:UserId];
    
    Password = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-19, 50)];
    [Password setBackgroundColor:[UIColor clearColor]];
    Password.placeholder = [NSString stringWithFormat:@"密码"];
    
    Password.layer.cornerRadius = 5.0;
    [_InputBackground addSubview:Password];
 
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_InputBackground
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:0.5
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:loginButton
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:_InputBackground
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:loginButton
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeft
                              multiplier:1
                              constant:19]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:loginButton
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1
                              constant:-19]];
    
    aa = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)OnLogin:(id)sender {
//    NetworkAdapter *na = [NetworkAdapter InitNetwork];
//    
//    BOOL result;
//    if (aa != nil) {
//        result = true;
//    }
//    else{
//        result = [na Connect:@"ayo.org.cn" Port:9090];
//        aa = @"afsa";
//    }
//    
//    [na SubscribeMessage:LOGIN_RESULT Instance:self];
//    
//    if (result) {
//        NSString * command = @"login 2\r\n";
//        NSString * sUserID = [NSString stringWithFormat:@"%@\r\n", UserId.text];
//        NSString * sPassword = [NSString stringWithFormat:@"%@\r\n", Password.text];
//        
//        NSString * LogingMessage = [NSString stringWithFormat:@"%@%@%@", command, sUserID, sPassword];
//        
//        [na sendData:LogingMessage];
//    }
    //pomelo = [PomeloWS initPomelo:self];
    pomelo = [PomeloWS GetPomelo];
    if ( pomelo == nil) {
        pomelo = [[PomeloWS alloc] initWithDelegate:self];
    }
    
    [pomelo connectToHost:@"ayo.org.cn" onPort:3050 withCallback:^(PomeloWS *p){
 //   [pomelo connectToHost:@"192.168.1.93" onPort:3050 withCallback:^(PomeloWS *p){
 //   [pomelo connectToHost:@"172.20.10.2" onPort:3050 withCallback:^(PomeloWS *p){
        NSDictionary *params = @{@"userid":UserId.text,@"pwd":Password.text};
        [pomelo requestWithRoute:@"connector.entryHandler.enter"
                       andParams:params andCallback:^(NSDictionary *result){
                           if ([[result objectForKey:@"code"]  isEqual: @"502"])
                           {
                               NSLog(@"password not correct!");
                               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
                               
                               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                               [alertController addAction:okAction];
                               
                               [self presentViewController:alertController animated:YES completion:nil];
                           }
                           //获取userDefault单例
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           //登陆成功后把用户名和密码存储到UserDefault
                           [userDefaults setObject:UserId.text forKey:@"name"];
                           [userDefaults setObject:Password.text forKey:@"password"];
                           [userDefaults synchronize];
                           //用模态跳转到主界面
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                           id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainUI"];
                           [self presentViewController:mainViewController animated:YES completion:^{
                           }];
                           
            }];
        }];
    
}

-(void) ONMessageCome:(SocketMessage*)socketMsg
{
    if (socketMsg == nil) {
        return;
    }
    if (socketMsg.Type == LOGIN_RESULT)
    {
        NetworkAdapter *na = [NetworkAdapter InitNetwork];
        [na UnsubscribeMessage:LOGIN_RESULT Instance:self];
        if ([socketMsg.argumentList[0] isEqualToString:@"1"])
        {
            //获取userDefault单例
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:UserId.text forKey:@"name"];
            [userDefaults setObject:Password.text forKey:@"password"];
            [userDefaults synchronize];
            //用模态跳转到主界面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            id mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameSelectionView"];
            [self presentViewController:mainViewController animated:YES completion:^{
            }];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            NetworkAdapter *na = [NetworkAdapter InitNetwork];
            [na Disconnect];
        }
    }
}


@end
