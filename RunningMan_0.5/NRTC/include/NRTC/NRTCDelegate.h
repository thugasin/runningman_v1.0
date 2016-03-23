//
//  NRTCDelegate.h
//  NRTC
//
//  Created by Netease on 15/11/2.
//  Copyright © 2015年 Netease. All rights reserved.
//

#ifndef NRTCDelegate_h
#define NRTCDelegate_h

#import <Foundation/Foundation.h>
#import <QuartzCore/CALayer.h>
#import "NRTCTypes.h"

@class NRTCChannel;
@class NRTCChannelInfo;
@class NRTCChannelReport;
@class NRTCI420Frame;

/**
 *  NRTC协议
 */
@protocol NRTCDelegate <NSObject>
@optional

/**
 *  自己加入了频道
 *
 *  @param channel 加入的频道
 *  @param info    加入的频道的反馈信息
 */
- (void)onJoinedChannel:(NRTCChannel *)channel
                   info:(NRTCChannelInfo *)info;

/**
 *  自己离开了频道
 *
 *  @param channel 离开的频道
 *  @param report  离开的频道的报告信息
 */- (void)onLeftChannel:(NRTCChannel *)channel
                  report:(NRTCChannelReport *)report;


/**
 *  其他人加入了频道
 *
 *  @param uid     用户uid
 *  @param channel 加入的频道
 */
- (void)onUserJoined:(SInt64)uid
             channel:(NRTCChannel *)channel;

/**
 *  其他人离开了频道
 *
 *  @param uid     用户uid
 *  @param reason  离开的原因
 *  @param channel 离开的频道
 */
- (void)onUserLeft:(SInt64)uid
            reason:(NRTCUserLeaveReason)reason
           channel:(NRTCChannel *)channel;

/**
 *  发生了错误, 会话结束
 *
 *  @param error   错误
 *  @param channel 发生错误的频道
 */
- (void)onError:(NSError *)error
        channel:(NRTCChannel *)channel;


/**
 *  本地视频预览层就绪
 *
 *  @param layer   本地视频预览层
 *  @param channel 频道信息
 */
- (void)onLocalPreview:(CALayer *)layer
               channel:(NRTCChannel *)channel;


/**
 *  远程一帧画面播放回调
 *
 *  @param frame   I420画面数据
 *  @param uid     画面属于的用户
 *  @param channel 画面属于的频道
 */
- (void)onRemoteI420:(NRTCI420Frame *)frame
                 uid:(SInt64)uid
             channel:(NRTCChannel *)channel;

/**
 *  语音设备中断开始。其他应用有可能导致NRTC的语音发生中断, 如电话和音乐应用
 */
- (void)onAudioInterruptionStart;


/**
 *  语音设备中断结束
 */
- (void)onAudioInterruptionEnd;


/**
 *  网络质量汇报
 *
 *  @param quality 网络质量
 */
- (void)onNetworkQuality:(NRTCNetworkQuality)quality;


/**
 *  对方用户的语音静音信息报告, 在用户加入和用户改变设置时都会触发该协议
 *
 *  @param isMute  是否静音
 *  @param uid     用户uid
 *  @param channel 频道信息
 */
- (void)onUserMuteAudio:(BOOL)isMute
                    uid:(SInt64)uid
                channel:(NRTCChannel *)channel;

/**
 *  对方用户的视频开关信息报告, 在用户加入和用户改变设置时都会触发该协议
 *
 *  @param isMute  是否关闭了视频
 *  @param uid     用户uid
 *  @param channel 频道信息
 */
- (void)onUserMuteVideo:(BOOL)isMute
                    uid:(SInt64)uid
                channel:(NRTCChannel *)channel;


/**
 *  对方用户的音视频模式信息报告, 在用户加入和用户改变设置时都会触发该协议
 *
 *  @param mode    音视频模式
 *  @param uid     用户uid
 *  @param channel 频道信息
 */
- (void)onUserChangeMode:(NRTCChannelMode)mode
                     uid:(SInt64)uid
                 channel:(NRTCChannel *)channel;

@end


#endif /* NRTCDelegate_h */
