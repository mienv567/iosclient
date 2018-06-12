//
//  AccountTPTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AccountTPTableViewCell.h"

@implementation AccountTPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius =self.headerImageView.size.height/2;
    self.headerImageView.layer.masksToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
