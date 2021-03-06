//
//  AppDelegate.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "LoginViewController.h"
#import "GameSelectionViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize pomelo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    InstallUncaughtExceptionHandler();
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *cokieName = [userDefault objectForKey:@"name"];
//    NSString *cokiePassword = [userDefault objectForKey:@"password"];
//    
//    pomelo = [[PomeloWS alloc] initWithDelegate:self];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    if (cokieName == nil)
//    {
//        id view = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        self.window.rootViewController = view;
//        ((LoginViewController*)view).pomelo = pomelo;
//        
//    }
//    else
//    {
//        id view = [storyboard instantiateViewControllerWithIdentifier:@"GameSelectionView"];
//        self.window.rootViewController = view;
//        ((GameSelectionViewController*)view).pomelo = pomelo;
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    pomelo = [PomeloWS GetPomelo];
    if ( pomelo == nil) {
        pomelo = [[PomeloWS alloc] initWithDelegate:self];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString* userName = [userDefault objectForKey:@"name"];
    NSString* userPassword = [userDefault objectForKey:@"password"];
    
    //           [pomelo connectToHost:@"ayo.org.cn" onPort:3014 withCallback:^(PomeloWS *p)
    //             [pomelo connectToHost:@"ayo.org.cn" onPort:3050 withCallback:^(PomeloWS *p)
    
    NSString* serverIP = [userDefault objectForKey:@"serverip"];
    [pomelo connectToHost:serverIP onPort:3050 withCallback:^(PomeloWS *p)
     {
         NSDictionary *params = @{@"userid":userName,@"pwd":userPassword};
         [pomelo notifyWithRoute:@"connector.entryHandler.enter"
                       andParams:params];
         NSLog(@"come back, reconnect server;");
     }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
