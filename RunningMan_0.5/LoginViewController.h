//
//  ViewController.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/23.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IObserver.h"
#import "LoginInputViewController.h"
#import "PomeloWS.h"


@interface LoginViewController : UIViewController<IObserver>

@property (strong, nonatomic) UITextField *UserId;
@property (strong, nonatomic) UITextField *Password;

@property (strong, nonatomic) NSString* aa;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)OnLogin:(id)sender;
- (IBAction)OnConfigure:(id)sender;

@property (strong, nonatomic) PomeloWS *pomelo;

@end