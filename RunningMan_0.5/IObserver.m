//
//  IObserver.m
//  RunningMan_0.2
//
//  Created by Sirius on 15/8/23.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IObserver.h"

@implementation Observer

+(id) initObject
{
    return [super init];
}

-(void) ONMessageCome:(SocketMessage*)socketMsg
{
    return;
}

@end

@implementation SocketMessage

@synthesize argumentNumber;
@synthesize argumentList;
@synthesize Type;

+(id)InitObject:(MessageType)msgType ArgumentNumber:(int)argNum ArgumentList:(NSMutableArray*)argList
{
    return [[self alloc] InternalInit:msgType ArgumentNumber:argNum ArgumentList:argList];
}
-(id)InternalInit:(MessageType)msgType ArgumentNumber:(int)argNum ArgumentList:(NSMutableArray*)argList
{
    if (self == [super init]) {
        self->Type = msgType;
        self->argumentNumber = argNum;
        self->argumentList = argList;
    }
    
    return self;
}
@end