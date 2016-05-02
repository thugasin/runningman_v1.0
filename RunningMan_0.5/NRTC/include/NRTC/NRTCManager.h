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

/**
 *  改变自己在会议中的角色
 *
 *  @param role 角色. 观众不发音视频数据
 *
 *  @return 设置是否成功
 */
- (BOOL)setMeetingRole:(NRTCMeetingRole)role;

/**
 *  指定某用户设置是否对其静音
 *
 *  @param mute 是否静音, 静音后将听不到该用户的声音
 *  @param uid  用户uid
 *
 *  @return 是否设置成功. 如果用户尚未加入, 则无法设置
 */
- (BOOL)setAudioMute:(BOOL)mute forUser:(SInt64)uid;

/**
 *  指定某用户设置是否接收其视频
 *
 *  @param mute 是否拒绝视频, 拒绝后将没有该用户视频数据回调
 *  @param uid  用户uid
 *
 *  @return 是否设置成功. 如果用户尚未加入, 则无法设置
 */
- (BOOL)setVideoMute:(BOOL)mute forUser:(SInt64)uid;

# pragma mark -

/**
 *  开始本地MP4文件录制, 录制通话过程中自己的音视频内容到MP4文件
 *
 *  @param filePath     录制文件路径, SDK不负责创建目录, 请确保文件路径的合法性,
 *                      也可以传入nil, 由SDK自己选择文件路径
 *  @param videoBitrate 录制文件视频码率设置, 可以不指定, 由SDK自己选择合适的码率
 *
 *  @return 是否允许开始录制
 *
 *  @discussion 只有通话连接建立以后才允许开始录制
 */
- (BOOL)startLocalRecording:(NSURL *)filePath
               videoBitrate:(UInt32)videoBitrate;

/**
 *  停止本地MP4文件录制
 *
 *  @return 是否接受停止录制请求
 */
- (BOOL)stopLocalRecording;


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
