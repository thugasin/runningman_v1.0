//
//  GameResultCellViewController.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/9/7.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "GameResultCellViewController.h"

@interface GameResultCellViewController ()

@end

@implementation GameResultCellViewController
@synthesize playerIcon,playerName,playerScore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
