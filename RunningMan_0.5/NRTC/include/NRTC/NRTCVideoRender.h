//
//  NRTCRender.h
//  NRTC
//
//  Created by Netease on 15/10/19.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@class NRTCI420Frame;

/**
 *  NRTCI420Frame格式视频画面渲染器
 */
@interface NRTCVideoRender : NSObject

/**
 *  初始化一个NRTCI420Frame格式视频画面的渲染视图
 *
 *  @param frame frame
 *
 *  @return UIView
 */
+ (UIView *)renderViewWithFrame:(CGRect)frame;

/**
 *  渲染NRTCI420Frame视频画面
 *
 *  @param i420Frame I420 格式的画面帧
 *  @param view  渲染的容器视图, 只支持renderViewWithFrame:生成的视图 或者 UIImageView
 *
 *  @discussion 如果view是renderViewWithFrame:生成的, 将会使用opengl进行渲染, 可以节省运算资源
 *              如果view是UIImageView, 不会使用opengl渲染
 *  @return 是否渲染成功
 */
+ (BOOL)render:(NRTCI420Frame *)i420Frame inView:(UIView *)view;

@end
