//
//  NRTCManager.h
//  NRTC
//
//  Created by Netease on 15/10/15.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CALayer.h>
#import "NRTCTypes.h"

@class NRTCChannel;
@class NRTCI420Frame;
@protocol NRTCDelegate;

/**
 *  NRTC管理类
 */
@interface NRTCManager : NSObject

#pragma mark -

/**
 *  NRTC单例管理类实例
 *
 *  @return 单例实例
 */
+ (instancetype)sharedManager;

#pragma mark -

/**
 *  加入频道
 *
 *  @param channel 频道信息
 *  @param delegate NRTC委托
 *
 *  @return 如果加入频道成功, 返回nil
 */
- (NSError *)joinChannel:(NRTCChannel *)channel
                delegate:(id<NRTCDelegate>)delegate;


/**
 *  离开当前频道
 */
- (void)leaveChannel;

#pragma mark -

/**
 *  设置当前频道是否静音语音
 *
 *  @param mute 是否开启语音静音
 *
 *  @return 开启语音静音是否成功
 *
 *  @discussion 切换音视频模式将丢失该设置
 */
- (BOOL)setAudioMute:(BOOL)mute;

/**
 *  查询当前频道是否静音了语音
 *
 *  @return 语音是否静音
 */
- (BOOL)audioMuteEnabled;


/**
 *  设置当前频道是否关闭视频发送
 *
 *  @param mute 是否关闭视频发送
 *
 *  @return 设置是否成功
 *
 *  @discussion 仅支持当前为视频模式时进行此设置, 切换音视频模式将丢失该设置
 */
- (BOOL)setVideoMute:(BOOL)mute;


/**
 *  查询当前频道是否关闭了视频发送
 *
 *  @return 视频发送是否已关闭
 */
- (BOOL)videoMuteEnabled;


/**
 *  设置当前频道扬声器模式
 *
 *  @param useSpeaker 是否开启扬声器
 *
 *  @return 开启扬声器是否成功
 *
 *  @discussion 切换音视频模式将丢失该设置
 */
- (BOOL)setSpeaker:(BOOL)useSpeaker;


/**
 *  查询当前频道是否开启了扬声器输出
 *
 *  @return 扬声器输出是否已开启
 */
- (BOOL)speakerEnabled;


/**
 *  切换前后摄像头
 *
 *  @param camera 选择的摄像头
 *
 *  @discussion 切换音视频模式将丢失该设置
 */
- (BOOL)switchCamera:(NRTCCamera)camera;


/**
 *  查询当前频道是否正在使用背部摄像头
 *
 *  @return 背部摄像头是否正在使用
 */
- (BOOL)isUseBackCamera;


/**
 *  切换频道音视频模式
 *
 *  @param mode 模式
 *
 *  @discussion 切换模式会丢失这些设置: 静音模式, 扬声器模式, 摄像头关闭, 前后摄像头
 */
- (BOOL)setChannelMode:(NRTCChannelMode)mode;

/**
 *  获取当前频道的音视频模式
 *
 *  @return 音视频模式
 */
- (NRTCChannelMode)getChannelMode;

#pragma mark - 

/**
 *  查询NRTC是否正忙, NRTC同时只能加入一个频道
 *
 *  @return 是否正忙
 */
- (BOOL)isBusy;


/**
 *  获得当前视频通话的本地预览层
 *
 *  @return 预览层
 */
- (CALayer *)localPreview;


/**
 *  获取当前频道的网络质量
 *
 *  @return 网络质量
 */
- (NRTCNetworkQuality)networkQuality;


/**
 *  获取SDK版本号
 *
 *  @return 版本号
 */
- (NSString *)version;

@end
