//
//  GameResultViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/8/17.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResultCellViewController.h"
#import "ImageHandler.h"

@interface GameResultViewController ()

@end

@implementation GameResultViewController
@synthesize resultArray;
static NSString* CellTableIdentifier2 = @"CellTableIdentifier2";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    resultImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GameOver"]];
    [resultImage sizeToFit];
    resultImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    resultList = [[UITableView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [resultList sizeToFit];
    resultList.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:resultList];
    [self.view addSubview:resultImage];
    
    [self setConstraint];
    
    resultList.rowHeight = 45.5;
    UINib *nib = [UINib nibWithNibName:@"GameResultCell" bundle:nil];
    [resultList registerNib:nib forCellReuseIdentifier:CellTableIdentifier2];
    resultList.delegate = self;
    resultList.dataSource = self;
    
    ImageHandler *imangeHandler = [ImageHandler GetImageHandler];
    NSArray* list = [imangeHandler.ImageDataDictionary objectForKey:@"Angel&deamon"];
    
    imageDictionary = [list objectAtIndex:0];
}

-(void)setConstraint
{
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultList
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultList
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:resultImage
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultList
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultList
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:0.7
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultImage
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:resultImage
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                  constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:resultImage
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:0.3
                              constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameResultCellViewController *cell = [resultList dequeueReusableCellWithIdentifier:CellTableIdentifier2];
    
    NSUInteger row = [indexPath row];
    
    [cell.playerIcon setImage:[UIImage imageNamed:[[[[imageDictionary objectForKey:[resultArray[row] objectForKey:@"role"]] objectForKey:@"Normal"] objectForKey:@"images"] objectAtIndex:0]]];
    cell.playerScore.text = [resultArray[row] objectForKey:@"gain"];
    cell.playerName.text = [resultArray[row] objectForKey:@"userid"];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
