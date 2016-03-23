//
//  NRTCChannel.h
//  NRTC
//
//  Created by Netease on 15/10/15.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRTCTypes.h"

/**
 *  NRTC频道
 */
@interface NRTCChannel : NSObject

/**
 *  频道名称, app内唯一
 */
@property (nonatomic, copy) NSString *channelName;

/**
 *  音视频模式
 */
@property (nonatomic, assign) NRTCChannelMode channelMode;

/**
 *  标识用户自己的id, app内唯一, 不能为0
 */
@property (nonatomic, assign) SInt64 myUid;

/**
 *  开发者在云信后台创建应用时申请的App Key
 */
@property (nonatomic, copy) NSString *appKey;

/**
 *  token, 加入频道支持安全模式和非安全模式两种方式
 *
 *  安全模式: 客户端需要appKey和一个token来完成认证进行实时通话。 其中 token 需要第三方服务器从云信服务器获取, 详细服务器接口请参考 [网易云信Sever Http API接口文档](http://dev.netease.im/docs?doc=server) 的getToken.action
 *
 *  非安全模式: 客户端只需要appKey即可完成认证进行实时通话, 不需要传入token, 这种情况下用户需要保管好appKey, 防治泄露, 默认情况下非安全模式处于关闭状态, 如需开启请联系我们的客服。为了您的账号安全，我们推荐您使用安全模式
 */
@property (nonatomic, copy) NSString *token;

/**
 *  启用服务器录音 (该开关仅在服务器开启录音功能时才有效)
 */
@property (nonatomic, assign) BOOL enableServerRecording;


/**
 *  获取频道对应的id
 *
 *  @return 频道id
 */
- (UInt64)channelID;

@end

@interface NRTCChannelInfo : NSObject

@property(nonatomic, assign, readonly) UInt64 channelID;

@property(nonatomic, copy, readonly) NSString *recordUrl;

@property(nonatomic, copy, readonly) NSString *recordName;

@end

@interface NRTCChannelReport : NSObject

@property(nonatomic, assign, readonly) UInt64 trafficStatRX;

@property(nonatomic, assign, readonly) UInt64 trafficStatTX;

@end

