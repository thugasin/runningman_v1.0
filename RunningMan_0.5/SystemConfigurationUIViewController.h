//
//  SystemConfigurationUIViewController.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/6/9.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SystemConfigurationUIViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *IpAddress;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)OnConfirm:(id)sender;


@end