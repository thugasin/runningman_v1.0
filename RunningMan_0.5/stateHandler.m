//
//  stateHandler.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/5/15.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "stateHandler.h"

static StateHandler *sharedObj= nil;

@implementation StateHandler
@synthesize StateResourceDictionary;

+(id) GetStateHandler
{
    @synchronized(self)
    {
        if(sharedObj == nil)
        {
            sharedObj = [[self alloc] InitStateHandler];
        }
        
    }
    return sharedObj;
}

-(id) InitStateHandler
{
    if (self == [super init]) {
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"stateMap"
                                                             ofType:@"json"
                                                        inDirectory:@"Configure"];
        
        //check file exists
        if (fileName) {
            //retrieve file content
            NSData *stateData = [[NSData alloc] initWithContentsOfFile:fileName];
            
            //convert JSON NSData to a usable NSDictionary
            NSError *error;
            StateResourceDictionary = [NSJSONSerialization JSONObjectWithData:stateData
                                                                  options:0
                                                                    error:&error];
            
            if (error) {
                NSLog(@"Something went wrong! %@", error.localizedDescription);
            }
            else {
                NSLog(@"party info: %@", StateResourceDictionary);
            }
        }
        else {
            NSLog(@"Couldn't find file!");
        }
        
    }
    return self;
}

@end
