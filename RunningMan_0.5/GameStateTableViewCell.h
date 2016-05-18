//
//  GameStateTableViewCell.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/5/10.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStateTableViewCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *score;
@property(nonatomic,retain) IBOutlet UILabel *displayText;
@property (nonatomic,retain) IBOutlet UIImageView *scoreImage;
@property (nonatomic,retain) IBOutlet UIImageView *separatorImage;

@end
