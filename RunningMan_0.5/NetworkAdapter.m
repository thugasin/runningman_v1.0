//
//  NetworkAdapter.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/8/5.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//
#import <libkern/OSAtomic.h>
#import "NetworkAdapter.h"

@implementation SrvMsgSubscriber

@synthesize MsgType;
@synthesize SubscriberInstance;

+(id)InitObject:(MessageType)MT Instance:(Observer*)Ins
{
    return [[self alloc] InternalInit:MT Instance:Ins];
}

-(id)InternalInit:(MessageType)MT Instance:(Observer*)Ins
{
    if (self == [super init]) {
        MsgType = MT;
        SubscriberInstance = Ins;
    }
    
    return self;
}

@end


static NetworkAdapter *sharedObj= nil;
@implementation NetworkAdapter


+(NetworkAdapter*) InitNetwork
{
    @synchronized(self)
    {
        if(sharedObj == nil)
        {
            sharedObj = [[self alloc] InitSocket];
        }
        
    }
    return sharedObj;
}

//+(void) SendCommand:(NSString *) command,...
//{
//    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
//    va_list params; //定义一个指向个数可变的参数列表指针;
//    va_start(params,command);//va_start 得到第一个可变参数地址,
//    id arg;
//    NSMutableString *commandString = [NSMutableString stringWithString:command];
//    if (command)
//    {
//        while( (arg = va_arg(params,id)) )
//        {
//            if ( arg )
//            {
//                commandString = [NSString stringWithFormat:@"%@%@\r\n", commandString,(NSString*)arg];
//
//            }
//        }
//        //置空
//        va_end(params);
//    }
//    
//    [na sendData:commandString];
//}

-(id) InitSocket
{
    if (self == [super init]) {
        m_socket = [[AsyncSocket alloc] initWithDelegate:self];
        m_bIsContinuedMessage = false;
        m_bNeedMakeUpLine = false;
    }
    return self;
}

-(BOOL) Connect:(NSString *)ipAddress Port:(UInt16)port
{
    NSError *err = nil;
    if (![m_socket connectToHost:ipAddress onPort:port withTimeout:10 error:&err]) {
        NSLog(@"connect failed: %@", err);
        return false;
    }
    
    return true;
}

-(BOOL) Disconnect
{
    [m_socket disconnect];
    NSLog(@"disconnected");
    
    return true;
}

- (void) sendData:(NSString*)Msg
{
    NSData* aData= [Msg dataUsingEncoding: NSUTF8StringEncoding];
    
    [m_socket writeData:aData withTimeout:-1 tag:1];
}
//
-(void)ontime{
//    
    [m_socket readDataWithTimeout:-1 tag:0];
//    
}
//
//
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}

- (void)longConnectToSocket
{
    [m_socket readDataWithTimeout:-1 tag:0];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [self ParseMessage:aStr];
}


-(void) SubscribeMessage:(MessageType)MsgType Instance:(Observer*)Ins
{
    for (SrvMsgSubscriber* sub in m_MsgSubscriber) {
        if (sub.MsgType == MsgType && sub.SubscriberInstance == Ins) {
            return;
        }
    }
    SrvMsgSubscriber *sub = [SrvMsgSubscriber InitObject:MsgType Instance:Ins];
    
    if(m_MsgSubscriber == nil)
    {
        m_MsgSubscriber = [NSMutableArray arrayWithObject:sub];
    }
    else
        [m_MsgSubscriber addObject:sub];
}
-(void) PublishMessage:(SocketMessage*)socketMsg
{
    for (SrvMsgSubscriber* sub in m_MsgSubscriber)
    {
        if (sub.MsgType != socketMsg.Type) {
            continue;
        }
        
        [sub.SubscriberInstance ONMessageCome:(SocketMessage*)socketMsg];
    }
}

-(void) UnsubscribeMessage:(MessageType)MsgType Instance:(Observer*)Ins
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:m_MsgSubscriber];
    for (SrvMsgSubscriber *sub in temp) {
        if (sub.MsgType == MsgType && sub.SubscriberInstance == Ins) {
            [m_MsgSubscriber removeObject:sub];
            return;
        }
    }
}

-(void) ParseMessage:(NSString*)Message
{
    NSString* finalMessage;
    NSString* processedMessage;
    if (m_bNeedMakeUpLine)
    {
        finalMessage = [NSString stringWithFormat:@"%@%@",m_sLackString,Message];
        m_bNeedMakeUpLine = false;
    }
    else
        finalMessage = [NSString stringWithString:Message];
    
    NSString * sub = [finalMessage substringFromIndex:finalMessage.length-2];
    if (![sub isEqualToString:@"\r\n"])
    {
        m_bNeedMakeUpLine = true;
        bool bNotDone = true;
        int j = 2;
        while(bNotDone)
        {
            j=j+1;
            NSInteger l = finalMessage.length;
            NSString* tempString = [finalMessage substringWithRange:NSMakeRange(finalMessage.length - j,2)];
            if ([tempString isEqualToString:@"\r\n"])
            {
                bNotDone = false;
            }
        }
        m_sLackString =[finalMessage substringFromIndex:finalMessage.length-j+2];
        processedMessage =[finalMessage substringWithRange:NSMakeRange(0,finalMessage.length - j+2)];

    }
    else
        processedMessage = [NSString stringWithString:finalMessage];
    
    NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    NSArray *MessageArray =[processedMessage componentsSeparatedByCharactersInSet:CharacterSet];
    if (!m_bIsContinuedMessage)
    {
        [self ParseMessageWithHeaderIndex:MessageArray HeaderIndex:0];
    }
    else
    {
        [self ParseContinuedMessage:MessageArray];
    }
    return;
}

-(void) ParseMessageWithHeaderIndex:(NSArray *)MessageArray HeaderIndex:(int)index
{
    NSCharacterSet* HeaderCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSArray *HeaderArray =[[MessageArray objectAtIndex:index] componentsSeparatedByCharactersInSet:HeaderCharacterSet];
    
    MessageType msgType = (MessageType)[HeaderArray[0] integerValue];
    int argNumber = (int)[HeaderArray[1] integerValue];
    
    NSMutableArray *argList = [NSMutableArray arrayWithCapacity:argNumber];
    
    for (int i=index + 2; i<MessageArray.count ; i= i+2)
    {
        if (argList.count == argNumber && [MessageArray[i]  isEqual: @""])
        {
            break;
        }
        else if(argList.count == argNumber && ![MessageArray[i]  isEqual: @""])
        {
            [self ParseMessageWithHeaderIndex:MessageArray HeaderIndex:i];
            break;
        }
        [argList addObject:MessageArray[i]];
    }
    
    SocketMessage* socketMsg = [SocketMessage InitObject:msgType ArgumentNumber:argNumber ArgumentList:argList];
    
    if (argList.count < argNumber)
    {
        m_bIsContinuedMessage = true;
        m_tempSocketMsg = socketMsg;
        return;
    }
    
    [self PublishMessage:socketMsg];
    
    return;
}

-(void) ParseContinuedMessage:(NSArray *)MessageArray
{
    for (int i=0; i<MessageArray.count ; i= i+2)
    {
        if (m_tempSocketMsg.argumentList.count == m_tempSocketMsg.argumentNumber)
        {
            [self PublishMessage:m_tempSocketMsg];
            m_bIsContinuedMessage = false;
            m_tempSocketMsg = nil;
            
            if ([MessageArray[i]  isEqual: @""])
            {
                return;
            }
            else
            {
                [self ParseMessageWithHeaderIndex:MessageArray HeaderIndex:i];
                return;
            }
        }
        [m_tempSocketMsg.argumentList addObject:MessageArray[i]];
    }
}


- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
    
//    [timer invalidate];
//    timer = nil;
//
}
//
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
//    //?????
    NSLog(@"onSocketDidDisconnect:%p", sock);
}
//
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//
{
    NSLog(@"thread(%@),onSocket:%p didWriteDataWithTag:%ld",[[NSThread currentThread] name],sock, tag);
//    
}

@end
