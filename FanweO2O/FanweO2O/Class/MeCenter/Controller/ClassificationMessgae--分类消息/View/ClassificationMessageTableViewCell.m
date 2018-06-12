//
//  ClassificationMessageTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassificationMessageTableViewCell.h"

@implementation ClassificationMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    self.titleName.textColor =KAppMainTextBackColor;
    self.contentLabel.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    
}
- (void)setModel:(ClassificationMessageModel *)model
{
    if (model != nil) {
        self.titleName.text =model.title;
        self.contentLabel.text =model.content;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
