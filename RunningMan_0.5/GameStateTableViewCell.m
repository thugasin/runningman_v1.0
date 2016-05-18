//
//  GameStateTableViewCell.m
//  RunningMan_1.0
//
//  Created by Sirius on 16/5/10.
//  Copyright © 2016年 Sirius. All rights reserved.
//

#import "GameStateTableViewCell.h"

@implementation GameStateTableViewCell

@synthesize score,scoreImage,separatorImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
       //    [self.scoreImage setBounds:CGRectMake(0, 0, 17, 17)];
           self.scoreImage.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
