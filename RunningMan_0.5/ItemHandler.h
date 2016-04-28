//
//  ItemHandler.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/4/27.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemHandler : NSObject

+(id) GetItemHandler;
-(id) InitItemHandler;

@property (nonatomic, strong) NSDictionary *ItemInfoDictionary;


@end