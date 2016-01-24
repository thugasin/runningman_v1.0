//
//  GameInfoTableCellView.h
//  RunningMan_1.0
//
//  Created by Sirius on 16/1/17.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameInfoTableCellView : UITableViewCell{
}
@property(nonatomic,retain) IBOutlet UILabel *distance;
@property(nonatomic,retain) IBOutlet UILabel *currentPlayerVSMax;
@property(nonatomic,retain) IBOutlet UILabel *gameState;
@property (nonatomic,retain) IBOutlet UIImageView *gameImage;
@property (nonatomic,retain) IBOutlet UILabel *gameName;
@end