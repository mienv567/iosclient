//
//  MessageCenterTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoIcon.layer.masksToBounds =YES;
    self.photoIcon.layer.cornerRadius =self.photoIcon.frame.size.width/2;
    self.contentLabel.textColor =kAppGrayColor2;
    self.timerLbael.textColor =kAppGrayColor2;
    self.angleIcon.layer.masksToBounds =YES;
    self.angleIcon.layer.cornerRadius =self.angleIcon.frame.size.width/2;
//    if ([self.angleIcon.text intValue]>=10) {
//        self.angleIcon.text =@"9+";
//    }
    self.angleIcon.hidden =YES;
    self.selectionStyle =UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
