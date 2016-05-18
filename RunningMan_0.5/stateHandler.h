//
//  stateHandler.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/5/15.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateHandler : NSObject

+(id) GetStateHandler;
-(id) InitStateHandler;

@property (nonatomic, strong) NSDictionary *StateResourceDictionary;


@end