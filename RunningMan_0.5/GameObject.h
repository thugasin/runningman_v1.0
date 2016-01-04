//
//  GameObject.h
//  IphoneMapSdkDemo
//
//  Created by Sirius on 15-3-20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "AnimatedAnnotation.h"

@interface GameObject : NSObject
{
    MAMapView *_mapView;
}

@property (readwrite) CLLocationCoordinate2D Coordinate;
@property (readonly) NSString *uID;
@property (retain) NSString* ImageFileName;
@property  int State;
@property (nonatomic, strong) AnimatedAnnotation *animatedCarAnnotation;
@property (nonatomic, strong) AnimatedAnnotation *animatedTrainAnnotation;

+(id) GameObject:(NSString*) bundle mapView:(MAMapView*) _mapView;

-(id) initObject:(NSString *)bundle mapView:(MAMapView*) _mapView;
-(void) OnPain;
- (NSString*)getMyBundlePath:(NSString *)filename;
- (NSString *)createUUID;

@end
