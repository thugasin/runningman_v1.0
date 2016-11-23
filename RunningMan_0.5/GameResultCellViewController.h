//
//  GameResultCellViewController.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/9/7.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameResultCellViewController : UITableViewCell

@property(nonatomic,retain) IBOutlet UIImageView* playerIcon;
@property(nonatomic,retain) IBOutlet UILabel* playerName;
@property(nonatomic,retain) IBOutlet UILabel* playerScore;

@end
