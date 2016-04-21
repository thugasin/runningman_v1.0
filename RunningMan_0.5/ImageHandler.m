//
//  ImageHandler.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/4/4.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "ImageHandler.h"

static ImageHandler *sharedObj= nil;

@implementation ImageHandler
@synthesize ImageDataDictionary;

+(id) GetImageHandler
{
    @synchronized(self)
    {
        if(sharedObj == nil)
        {
            sharedObj = [[self alloc] InitImageHandler];
        }
        
    }
    return sharedObj;
}

-(id) InitImageHandler
{
    if (self == [super init]) {
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ImageMap"
                                                             ofType:@"json"
                                                        inDirectory:@"Configure"];
        
        //check file exists
        if (fileName) {
            //retrieve file content
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:fileName];
            
            //convert JSON NSData to a usable NSDictionary
            NSError *error;
            ImageDataDictionary = [NSJSONSerialization JSONObjectWithData:imageData
                                                                  options:0
                                                                    error:&error];
            
            if (error) {
                NSLog(@"Something went wrong! %@", error.localizedDescription);
            }
            else {
                NSLog(@"party info: %@", ImageDataDictionary);
            }
        }
        else {
            NSLog(@"Couldn't find file!");
        }
        
    }
    return self;
}

@end
