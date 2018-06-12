//
//  PayListTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PayListTableViewCell.h"

@implementation PayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _color1 =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    _color2 =[UIColor colorWithRed:1.000 green:0.157 blue:0.286 alpha:1.00];
    self.storeName.textColor =KAppMainTextBackColor;
    self.statusLabel.textColor =_color2;
    self.line.backgroundColor =[UIColor colorWithRed:0.969 green:0.973 blue:0.976 alpha:1.00];
    
    
}
- (void)setModel:(PayListModel *)model

{
    if (model != nil) {
        self.storeName.text =model.location_name;
        self.statusLabel.text =model.status;
        NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"消费金额: ¥ %@",model.total_price] ];
        [attributedStr1 addAttribute:NSForegroundColorAttributeName
                              value:_color1
                              range:NSMakeRange(0, 5)];
        [attributedStr1 addAttribute:NSForegroundColorAttributeName
                              value:KAppMainTextBackColor
                              range:NSMakeRange(5, attributedStr1.length-5)];
        self.ConsumptionAmount.attributedText =attributedStr1;
        
        NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"优惠金额: ¥ %@",model.discount_price] ];
        [attributedStr2 addAttribute:NSForegroundColorAttributeName
                              value:_color1
                              range:NSMakeRange(0, 5)];
        [attributedStr2 addAttribute:NSForegroundColorAttributeName
                              value:KAppMainTextBackColor
                              range:NSMakeRange(5, attributedStr2.length-5)];
        self.DiscountAmount.attributedText =attributedStr2;
        
        NSMutableAttributedString *attributedStr3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付金额: ¥ %@",model.pay_amount] ];
        [attributedStr3 addAttribute:NSForegroundColorAttributeName
                               value:_color1
                               range:NSMakeRange(0, 5)];
        [attributedStr3 addAttribute:NSForegroundColorAttributeName
                               value:_color2
                               range:NSMakeRange(5, attributedStr3.length-5)];
        self.AmountRealPay.attributedText =attributedStr3;
        
        NSMutableAttributedString *attributedStr4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"买单时间: ¥ %@",model.create_time] ];
        [attributedStr4 addAttribute:NSForegroundColorAttributeName
                               value:_color1
                               range:NSMakeRange(0, 5)];
        [attributedStr4 addAttribute:NSForegroundColorAttributeName
                               value:KAppMainTextBackColor
                               range:NSMakeRange(5, attributedStr4.length-5)];
        self.timeLabel.attributedText =attributedStr4;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
