//
//  IObserver.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/8/20.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#ifndef RunningMan_0_2_IObserver_h
#define RunningMan_0_2_IObserver_h


#endif
#import "NetworkProtocal.h"

@interface SocketMessage:NSObject
{
}

@property(nonatomic) MessageType Type;
@property(nonatomic) int argumentNumber;
@property(nonatomic, strong) NSMutableArray* argumentList;

+(id)InitObject:(MessageType)msgType ArgumentNumber:(int)argNum ArgumentList:(NSMutableArray*)argList;
-(id)InternalInit:(MessageType)msgType ArgumentNumber:(int)argNum ArgumentList:(NSMutableArray*)argList;
@end

@protocol IObserver

-(void) ONMessageCome:(SocketMessage*)socketMsg;

@end

@interface Observer : NSObject<IObserver>

+(id) initObject;

@end



