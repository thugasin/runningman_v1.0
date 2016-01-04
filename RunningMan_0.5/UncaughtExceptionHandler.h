//
//  UncaughtExceptionHandler.h
//  RunningMan_0.5
//
//  Created by Sirius on 15/11/2.
//  Copyright © 2015年 Sirius. All rights reserved.
//

#ifndef UncaughtExceptionHandler_h
#define UncaughtExceptionHandler_h


#endif /* UncaughtExceptionHandler_h */
@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);