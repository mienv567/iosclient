//
//  RefundApplicationContentTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundApplicationContentTableViewCell.h"

@implementation RefundApplicationContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[UIColor colorWithRed:0.969 green:0.973 blue:0.973 alpha:1.00];
    self.storeContet.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    self.attrLabel.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    self.money.textColor =[UIColor colorWithRed:0.992 green:0.290 blue:0.267 alpha:1.00];
    
}
- (void)setModel:(MainContent *)model
{
    if (model != nil) {
        [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:model.deal_icon] placeholderImage:[UIImage imageNamed:@"no_pic"]];
        self.stroeName.text =model.name;
        self.money.text =[NSString stringWithFormat:@"¥%@",model.app_format_unit_price];
        if (model.attr_str ==nil || [model.attr_str isEqualToString:@""]) {
            self.attrLabel.hidden =YES;
        }else
        {
            self.attrLabel.text =[NSString stringWithFormat:@"规格: %@",model.attr_str];
        }
        if (model.password ==nil || [model.password isEqualToString:@""]) {
            self.storeContet.hidden =YES;
        }else
        {
            self.storeContet.text =[NSString stringWithFormat:@"序列号: %@",model.password];
        }
        self.count .text =[NSString stringWithFormat:@"x%@",model.number];
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
