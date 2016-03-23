//
//  NRTCI420.h
//  NRTC
//
//  Created by Netease on 15/10/19.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

/**
 *  I420视频数据帧
 */
@interface NRTCI420Frame : NSObject

/**
 *  I420数据, 紧凑结构, stride 为 0
 */
@property (nonatomic, strong, readonly) NSData *data;

/**
 *  视频画面宽度
 */
@property (nonatomic, readonly) NSUInteger width;

/**
 *  视频画面高度
 */
@property (nonatomic, readonly) NSUInteger height;


/**
 *  将I420数据转成一个UIImage
 *
 *  @return UIImage
 */
- (UIImage *)convertToImage;

@end
