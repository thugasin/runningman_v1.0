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
#import "PomeloWS.h"
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonViewDelegate.h"
#import "BounceButtonView.h"

@interface PacManMainGameViewController:UIViewController<MAMapViewDelegate>
{
    __block MAMapView *_mapView;
    bool bSetUserLocation;
    bool bInitSelfPresentation;
    AnimatedAnnotation* mySelfAnnotation;
    PomeloWS* pomelo;
    NSString* userID;
    
    
    __block NSMutableDictionary *mapInfolist;
}
@property (nonatomic, strong) AnimatedAnnotation *animatedCarAnnotation;
@property (nonatomic, strong) AnimatedAnnotation *animatedTrainAnnotation;

@property (strong, nonatomic) BounceButtonView *menuItemView;
@property (nonatomic, strong) IBOutlet ASOTwoStateButton *MenuButton;

-(IBAction) menuButtonAction:(id)sender;
@property (nonatomic, retain) NSTimer *Timmer;
@property (strong, nonatomic) IBOutlet UIButton * StopGameButton;
@property (nonatomic, strong) NSMutableArray* GameGridRow;
@property (nonatomic, strong) NSMutableArray* GameGridColunm;
@property (nonatomic) NSMutableDictionary* PlayerList;
@property (nonatomic,strong) NSString* UserName;
@property (nonatomic,strong) NSString* GameID;

-(MAPointAnnotation*)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate;
-(void)addPlayerAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate DisplayMessage:(NSString*)message AnnotationList:(NSMutableArray*)annotationList forKey:(NSString*)key;
-(IBAction) OnStopButtonClicked:(id)sender;
-(void) SetGameID:(NSString*)gameID;

@end

