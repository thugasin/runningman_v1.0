//
//  ItemHandler.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/4/27.
//  Copyright © 2016年 Sirius. All rights reserved.
//


#import "ItemHandler.h"

static ItemHandler *sharedObj= nil;

@implementation ItemHandler
@synthesize ItemInfoDictionary;

+(id) GetItemHandler
{
    @synchronized(self)
    {
        if(sharedObj == nil)
        {
            sharedObj = [[self alloc] InitItemHandler];
        }
        
    }
    return sharedObj;
}

-(id) InitItemHandler
{
    if (self == [super init]) {
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ItemMap"
                                                             ofType:@"json"
                                                        inDirectory:@"Configure"];
        
        //check file exists
        if (fileName) {
            //retrieve file content
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:fileName];
            
            //convert JSON NSData to a usable NSDictionary
            NSError *error;
            ItemInfoDictionary = [NSJSONSerialization JSONObjectWithData:imageData
                                                                  options:0
                                                                    error:&error];
            
            if (error) {
                NSLog(@"Something went wrong! %@", error.localizedDescription);
            }
            else {
                NSLog(@"party info: %@", ItemInfoDictionary);
            }
        }
        else {
            NSLog(@"Couldn't find file!");
        }
        
    }
    return self;
}

@end
