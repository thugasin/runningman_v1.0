//
//  NRTCTypes.h
//  NRTC
//
//  Created by Netease on 15/10/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#ifndef NRTCTypes_h
#define NRTCTypes_h

/**
 *  摄像头
 */
typedef NS_ENUM(NSUInteger, NRTCCamera) {
    /**
     *  前置摄像头
     */
    NRTCCameraFront,
    /**
     *  后置摄像头
     */
    NRTCCameraBack,
};


/**
 *  网络质量
 */
typedef NS_ENUM(NSInteger, NRTCNetworkQuality){
    /**
     *  网络很好
     */
    NRTCNetworkQualityExcellent,
    /**
     *  网络好
     */
    NRTCNetworkQualityGood,
    /**
     *  网络弱
     */
    NRTCNetworkQualityPoor,
    /**
     *  网络差
     */
    NRTCNetworkQualityBad,

};


/**
 *  音视频模式
 */
typedef NS_ENUM(NSUInteger, NRTCChannelMode) {
    /**
     *  语音模式: 默认开启声音, 使用听筒输出声音, 开启距离传感器, 关闭视频
     */
    NRTCChannelModeAudio,
    /**
     *  视频模式: 默认开启视频, 使用前置摄像头输出, 开启声音, 使用听筒输出声音, 关闭距离传感器
     */
    NRTCChannelModeVideo,
};

/**
 *  用户离开原因
 */
typedef NS_ENUM(NSUInteger, NRTCUserLeaveReason) {
    /**
     *  正常离开
     */
    NRTCUserLeaveReasonNormal,
    /**
     *  超时错误离开, 通常是对方网络异常引起的
     */
    NRTCUserLeaveReasonTimeout,
};


/**
 *  视频质量
 */
typedef NS_ENUM(NSUInteger, NRTCVideoQuality) {
    /**
     *  默认视频质量
     */
    NRTCVideoQualityDefault = 0,
    /**
     *  低清
     */
    NRTCVideoQualityLow,
    /**
     *  中清
     */
    NRTCVideoQualityMedium,
    /**
     *  高清
     */
    NRTCVideoQualityHigh,
};

/**
 *  用户在会议中的角色
 */
typedef NS_ENUM(NSUInteger, NRTCMeetingRole) {
    /**
     *  观众: 只播放, 不发送
     */
    NRTCMeetingRoleViewer,
    /**
     *  发言者: 既播放, 又发送
     */
    NRTCMeetingRoleActor,
};

/**
 *  分配频道错误Domain
 */
extern NSString *const NRTCReserveChannelErrorDomain;

/**
 *  分配频道错误
 */
typedef NS_ENUM(NSUInteger, NRTCReserveChannelError) {
    /**
     *  参数错误
     */
    NRTCReserveChannelErrorInvalidParameter = 401,
    /**
     *  只支持两个用户, 有第三个人试图使用相同的频道名分配频道
     */
    NRTCReserveChannelErrorMoreThanTwoUser = 600,
    /**
     *  分配频道服务器出错
     */
    NRTCReserveChannelErrorReserveServer = 601,
};


/**
 *  加入频道错误Domain
 */
extern NSString *const NRTCJoinChannelErrorDomain;

/**
 *  加入频道错误
 */
typedef NS_ENUM(NSUInteger, NRTCJoinChannelError) {
    /**
     *  加入频道超时
     */
    NRTCJoinChannelErrorConnectTimeout = 101,
    
    /**
     *  加入同一房间名的各方meetingMode必须一样, 否则后来者无法加入
     */
    NRTCJoinChannelErrorIncorrectMeetingMode = 102,
};


/**
 *  本地错误Domain
 */
extern NSString *const NRTCLocalErrorDomain;

/**
 *  本地错误
 */
typedef NS_ENUM(NSUInteger, NRTCLocalError) {
    
    /**
     *  音频输入错误
     */
    NRTCLocalErrorAudioInput = 10001,
    /**
     *  音频输出错误
     */
    NRTCLocalErrorAudioOutput = 10002,
    /**
     *  视频采集错误
     */
    NRTCLocalErrorVideoCapture = 10003,
    /**
     *  视频渲染错误
     */
    NRTCLocalErrorVideoRender = 10004,
    /**
     *  音频设备初始化失败
     */
    NRTCLocalErrorAudioDeviceInit = 10005,

    
    /**
     *  断开了与频道的连接, 通常是本地网络异常引起的
     */
    NRTCLocalErrorChannelDisconnected = 11001,
    /**
     *  本端NRTC版本太低
     */
    NRTCLocalErrorLocalVersionLow = 11002,
    /**
     *  对端NRTC版本太低
     */
    NRTCLocalErrorRemoteVersionLow = 11003,

    
    /**
     *  验证输入参数失败
     */
    NRTCLocalErrorValidateParameter = 12001,
    /**
     *  验证频道信息失败
     */
    NRTCLocalErrorValidateChannel = 12002,
    /**
     *  NRTC正忙
     */
    NRTCLocalErrorBusy = 12003,
    
    
    /**
     *  无法开始录制, 因为文件路径不合法
     */
    NRTCLocalErrorRecordInvalidFilePath       = 13001,
    /**
     *  开始本地录制失败
     */
    NRTCLocalErrorRecordStartFailed           = 13002,
    
    /**
     *  创建录制文件失败
     */
    NRTCLocalErrorRecordCreateFileFailed      = 13003,
    
    /**
     *  初始化录制音频失败
     */
    NRTCLocalErrorRecordInitAudioFailed       = 13004,
    
    /**
     *  初始化录制视频失败
     */
    NRTCLocalErrorRecordInitVideoFailed       = 13005,
    
    /**
     *  开始写录制文件失败
     */
    NRTCLocalErrorRecordStartWritingFailed    = 13006,
    
    /**
     *  写录制文件异常中断
     */
    NRTCLocalErrorWritingFileInterrupted      = 13007,
    
    /**
     *  结束本地录制失败
     */
    NRTCLocalErrorRecordStopFailed            = 13008,
    
    /**
     *  空间不足，录制即将结束
     */
    NRTCLocalErrorRecordWillStopForLackSpace  = 13009,

};

#endif /* NRTCTypes_h */
