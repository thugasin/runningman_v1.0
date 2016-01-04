//
//  NetworkAdapter.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/8/5.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "NetworkProtocal.h"
#import "IObserver.h"


@interface SrvMsgSubscriber:NSObject

@property(readwrite)   MessageType MsgType;
@property(readwrite)   Observer* SubscriberInstance;

+(id)InitObject:(MessageType)MT Instance:(Observer*)Ins;
-(id)InternalInit:(MessageType)MT Instance:(Observer*)Ins;

@end




@interface NetworkAdapter : NSObject
{
    AsyncSocket *m_socket;
    NSMutableArray *m_MsgSubscriber;
    bool m_bIsContinuedMessage;
    bool m_bNeedMakeUpLine;
    SocketMessage* m_tempSocketMsg;
    
    NSMutableString* m_sLackString;
}

@property (nonatomic, retain) NSTimer *connectTimer;

+(id) InitNetwork;
//+(void) SendCommand:(NSString *) command,...;
-(id) InitSocket;
-(BOOL) Connect:(NSString*)ipAddress Port:(UInt16)port;
-(BOOL) Disconnect;
- (void) sendData:(NSString*)Msg;
-(void) SubscribeMessage:(MessageType)MsgType Instance:(NSObject*)Ins;
-(void) UnsubscribeMessage:(MessageType)MsgType Instance:(NSObject*)Ins;
-(void) PublishMessage:(MessageType)MsgType MsgBody:(NSString*)MsgBody;
- (void)longConnectToSocket;
-(void) ParseMessage:(NSString*)Message;
-(void) ParseMessageWithHeaderIndex:(NSArray *)MessageArray HeaderIndex:(int)index;
-(void) ParseContinuedMessage:(NSArray *)MessageArray;


@end
