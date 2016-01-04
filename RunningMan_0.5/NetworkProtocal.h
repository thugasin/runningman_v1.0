//
//  NetworkProtocal.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/8/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#ifndef RunningMan_0_2_NetworkProtocal_h
#define RunningMan_0_2_NetworkProtocal_h
enum ServerMessageType
{
    LOGIN_RESULT = 0,
    CREATE_GAME = 1,
    LIST_GAME = 2,
    JOIN_GAME = 3,
    SHOW_PLAYER =4,
    START_GAME = 6,
    QUERY_GAME = 7,
    QUERYMAP = 8,
    testDrawBeans = 100
};


typedef enum ServerMessageType MessageType;

#endif
