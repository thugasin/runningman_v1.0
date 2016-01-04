//
//  ViewController.h
//  RunningMan_0.2
//
//  Created by Sirius on 15/6/15.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "AnimatedAnnotation.h"
#import "AnimatedAnnotationView.h"
#import "CustomAnnotationView.h"
#import "IObserver.h"
#import "NetworkAdapter.h"

@interface PacManMainGameViewController:UIViewController<MAMapViewDelegate,IObserver>
{
    MAMapView *_mapView;
    bool bSetUserLocation;
    bool bInitSelfPresentation;
    AnimatedAnnotation* mySelfAnnotation;
}
@property (nonatomic, strong) AnimatedAnnotation *animatedCarAnnotation;
@property (nonatomic, strong) AnimatedAnnotation *animatedTrainAnnotation;

@property (nonatomic, retain) NSTimer *Timmer;
@property (strong, nonatomic) IBOutlet UIButton * StopGameButton;
@property (nonatomic, strong) NSMutableArray* GameGridRow;
@property (nonatomic, strong) NSMutableArray* GameGridColunm;
@property (nonatomic) NSMutableDictionary* PlayerList;
@property (nonatomic,strong) NSString* UserName;
@property (nonatomic,strong) NSString* GameID;

-(MAPointAnnotation*)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate;
-(void)addPlayerAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate DisplayMessage:(NSString*)message;
-(IBAction) OnStopButtonClicked:(id)sender;
-(void) SetGameID:(NSString*)gameID;

@end

