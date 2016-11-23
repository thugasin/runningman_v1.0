//
//  GameResultViewController.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/8/17.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * resultList;
    
    UIImageView * resultImage;
    NSDictionary* imageDictionary;
}
@property(nonatomic) NSMutableArray* resultArray;

@end
