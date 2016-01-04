//
//  GameObject.m
//  IphoneMapSdkDemo
//
//  Created by Sirius on 15-3-20.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "GameObject.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation GameObject

@synthesize Coordinate;
@synthesize uID;
@synthesize ImageFileName;
@synthesize State;

@synthesize animatedCarAnnotation = _animatedCarAnnotation;
@synthesize animatedTrainAnnotation = _animatedTrainAnnotation;

+(id) GameObject:(NSString *)bundle mapView:(MAMapView*) _mapView
{
    return [[self alloc] initObject:bundle mapView:_mapView];
}

- (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   …
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

-(void)addCarAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray *carImages = [[NSMutableArray alloc] init];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_1.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_2.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_3.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_4.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_3.png"]];
    [carImages addObject:[UIImage imageNamed:@"animatedCar_4.png"]];
    
    self.animatedCarAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    self.animatedCarAnnotation.animatedImages   = carImages;
    self.animatedCarAnnotation.title            = @"AutoNavi";
    self.animatedCarAnnotation.subtitle         = [NSString stringWithFormat:@"Car: %lu images",(unsigned long)[self.animatedCarAnnotation.animatedImages count]];
    
    [_mapView addAnnotation:self.animatedCarAnnotation];
}

-(void)addTrainAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray *trainImages = [[NSMutableArray alloc] init];
    [trainImages addObject:[UIImage imageNamed:@"animatedTrain_1.png"]];
    [trainImages addObject:[UIImage imageNamed:@"animatedTrain_2.png"]];
    [trainImages addObject:[UIImage imageNamed:@"animatedTrain_3.png"]];
    [trainImages addObject:[UIImage imageNamed:@"animatedTrain_4.png"]];
    
    self.animatedTrainAnnotation = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    self.animatedTrainAnnotation.animatedImages = trainImages;
    self.animatedTrainAnnotation.title          = @"AutoNavi";
    self.animatedTrainAnnotation.subtitle       = [NSString stringWithFormat:@"Train: %lu images",(unsigned long)[self.animatedTrainAnnotation.animatedImages count]];
    
    [_mapView addAnnotation:self.animatedTrainAnnotation];
    [_mapView selectAnnotation:self.animatedTrainAnnotation animated:YES];
}

-(id) initObject:(NSString *)bundle mapView:(MAMapView*) mapView
{
    if (self == [super init]) {
        uID = [self createUUID];
        ImageFileName = bundle;
        _mapView = mapView;
        State = 1;
    }
    return self;
}

-(void) OnPain
{
//    if (State == 1) {
//    BMKGroundOverlay* ground = [BMKGroundOverlay groundOverlayWithPosition:Coordinate zoomLevel:mapView.zoomLevel anchor:CGPointMake(0.0f, 0.0f) icon:[UIImage imageWithContentsOfFile:[self getMyBundlePath:ImageFileName ]]];
//    [_mapView addOverlay:ground];
//    }
}

- (NSString*)getMyBundlePath:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

@end
