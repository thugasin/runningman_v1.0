//
//  ImageHandler.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/4/4.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandler : NSObject

+(id) GetImageHandler;
-(id) InitImageHandler;

@property (nonatomic, strong) NSDictionary *ImageDataDictionary;


@end
