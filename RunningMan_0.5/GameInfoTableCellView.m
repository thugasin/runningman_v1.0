//
//  GameInfoTableCellView.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/1/17.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "GameInfoTableCellView.h"

@implementation GameInfoTableCellView
@synthesize distance,currentPlayerVSMax,gameState,gameImage;

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

