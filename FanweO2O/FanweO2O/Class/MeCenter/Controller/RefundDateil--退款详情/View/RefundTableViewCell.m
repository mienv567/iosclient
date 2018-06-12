//
//  RefundTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundTableViewCell.h"

@implementation RefundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =[UIColor colorWithRed:0.969 green:0.973 blue:0.973 alpha:1.00];
    self.storeNameLabel.textColor =KAppMainTextBackColor;
    self.refundTypeLabel.textColor =KAppMainTextBackColor;
    self.goodsDateilLabel.textColor =KAppMainTextBackColor;
    self.goodsCountLabel.textColor =KAppMainTextBackColor;
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    self.bottomView.hidden =YES;
    self.goodsPricesLabel.textColor =[UIColor colorWithRed:0.957 green:0.137 blue:0.263 alpha:1.00];
    self.refundContent.textColor =[UIColor colorWithRed:0.957 green:0.137 blue:0.263 alpha:1.00];
    self.bulkNumberLabel.textColor =[UIColor colorWithRed:0.612 green:0.612 blue:0.612 alpha:1.00];
    self.refundContent.hidden =YES;
    self.bulkNumberLabel.hidden =YES;
}

- (void)setRefund_type:(NSString *)refund_type
{
    if ([refund_type isEqualToString:@"2"]) {
        self.bottomView.hidden =NO;
        _height =CGRectGetMaxY(_bottomView.frame)+10;
    }else
    {
        self.bottomView.hidden =YES;
        _height =CGRectGetMaxY(_stroeImageView.frame)+10;
    }
}
- (void)setHeight:(CGFloat)height
{
    _height =height;
}

- (void)setIsHiddenImage:(BOOL)isHiddenImage
{
    self.iconImage.hidden =isHiddenImage;
    self.refundTypeLabel.hidden =isHiddenImage;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
