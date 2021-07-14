//
//  SharedCell.m
//  ColLaTeX
//
//  Created by felipeccm on 7/14/21.
//

#import "SharedCell.h"

@implementation SharedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.layer.cornerRadius =
        self.profileImageView.frame.size.width /2;
    self.profileImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
