//
//  RefundDetailsContentTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundDetailsContentTableViewCell.h"

@implementation RefundDetailsContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _color1 =[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00];
    _color2 =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    self.topView .backgroundColor =[UIColor whiteColor];
    self.contentView.backgroundColor =[UIColor colorWithRed:0.969 green:0.973 blue:0.973 alpha:1.00];
    self.storeContent.textColor =_color2;
    self.price.textColor =_color1;
    self.redundInfo.textColor =_color1;
    
    
    
}
- (void)setModel:(RefundDetailsContentModel *)model
{
    //计算线高
    int lineHeight =0;
    if (model != nil) {
        if ([model.is_coupon intValue] ==1) {
            self.storeContent.text =[NSString stringWithFormat:@"团购劵: %@",model.password];
        }else
        {
            self.storeContent.hidden =YES;
        }
        self.storeName.text =model.supplier_name;
       [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:model.deal_icon]];
        self.storeTitle.text =model.name;
        self.price.text =[NSString stringWithFormat:@"¥%@",model.unit_price];
        self.count.text =[NSString stringWithFormat:@"x%@",model.number];
        self.redundInfo.text =model.refund_info;
        NSString *str =[NSString stringWithFormat:@"商品退款总计: ¥%@",model.refund_money];
        if ([str rangeOfString:@":"].location !=NSNotFound) {
            NSRange range =[str rangeOfString:@":"];
            NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str];
            [string addAttribute:NSForegroundColorAttributeName
                           value:_color1
                           range:NSMakeRange(range.location+1, string.length-range.location-1)];
            self.redundTotalMoney.attributedText =string;
        }
         NSString *str2 =[NSString stringWithFormat:@"申请时间: %@",model.create_time];
        if ([str2 rangeOfString:@":"].location !=NSNotFound) {
            NSRange range2 =[str2 rangeOfString:@":"];
            NSMutableAttributedString *string2 =[[NSMutableAttributedString alloc] initWithString:str2];
            [string2 addAttribute:NSForegroundColorAttributeName
                           value:_color2
                           range:NSMakeRange(range2.location+1, string2.length-range2.location-1)];
            self.timer.attributedText =string2;
        }
        if ([model.rs2 intValue] ==1) {
            self.redundIcon.image =[UIImage imageNamed:@"red_heng"];
            self.redundStraus.text =@"退款申请已提交,请等待审核";
            self.money.hidden =YES;
            self.moneyToFollow.hidden =YES;
            if (model.admin_memo.length !=0) {
                self.refDateilHeight.constant =0;
                lineHeight =1;
                NSString *str5 =[NSString stringWithFormat:@"退款备注: %@",model.admin_memo];
                if ([str5 rangeOfString:@":"].location !=NSNotFound) {
                    NSRange range5 =[str5 rangeOfString:@":"];
                    NSMutableAttributedString *string5 =[[NSMutableAttributedString alloc] initWithString:str5];
                    [string5 addAttribute:NSForegroundColorAttributeName
                                    value:_color2
                                    range:NSMakeRange(range5.location+1, string5.length-range5.location-1)];
                    self.refundDateil.attributedText =string5;
                }
            }else
            {
                self.refundDateil.hidden =YES;
            }
        }else if ([model.rs2 intValue ] ==2){
            self.redundIcon.image =[UIImage imageNamed:@"red_gougou"];
            self.redundStraus.text =@"退款成功";
            NSString *str3 =[NSString stringWithFormat:@"退款金额: ¥%@",model.refund_money];
            if ([str3 rangeOfString:@":"].location !=NSNotFound) {
                NSRange range3 =[str3 rangeOfString:@":"];
                NSMutableAttributedString *string3 =[[NSMutableAttributedString alloc] initWithString:str3];
                [string3 addAttribute:NSForegroundColorAttributeName
                                value:_color1
                                range:NSMakeRange(range3.location+1, string3.length-range3.location-1)];
                self.money.attributedText =string3;
            }
                NSString *str4 =@"钱款去向: 账户余额";
                if ([str4 rangeOfString:@":"].location !=NSNotFound) {
                    NSRange range4 =[str4 rangeOfString:@":"];
                    NSMutableAttributedString *string4 =[[NSMutableAttributedString alloc] initWithString:str4];
                    [string4 addAttribute:NSForegroundColorAttributeName
                                    value:_color2
                                    range:NSMakeRange(range4.location+1, string4.length-range4.location-1)];
                    self.moneyToFollow.attributedText =string4;
            }
            
           
            if (model.admin_memo.length !=0) {
                lineHeight =3;
                self.refDateilHeight.constant =40;
                NSString *str5 =[NSString stringWithFormat:@"退款备注: %@",model.admin_memo];
                if ([str5 rangeOfString:@":"].location !=NSNotFound) {
                    NSRange range5 =[str5 rangeOfString:@":"];
                    NSMutableAttributedString *string5 =[[NSMutableAttributedString alloc] initWithString:str5];
                    [string5 addAttribute:NSForegroundColorAttributeName
                                    value:_color2
                                    range:NSMakeRange(range5.location+1, string5.length-range5.location-1)];
                    self.refundDateil.attributedText =string5;
                }
            }else
            {
                 lineHeight =2;
                self.refundDateil.hidden =YES;
            }

            
                
        }else
        {
            self.redundIcon.image =[UIImage imageNamed:@"red_cha"];
            self.redundStraus.text =@"退款申请已被拒绝";
            self.money.hidden =YES;
            self.moneyToFollow.hidden =YES;
            if (model.admin_memo.length !=0) {
                self.refDateilHeight.constant =0;
                NSString *str5 =[NSString stringWithFormat:@"退款备注: %@",model.admin_memo];
                if ([str5 rangeOfString:@":"].location !=NSNotFound) {
                    NSRange range5 =[str5 rangeOfString:@":"];
                    NSMutableAttributedString *string5 =[[NSMutableAttributedString alloc] initWithString:str5];
                    [string5 addAttribute:NSForegroundColorAttributeName
                                    value:_color2
                                    range:NSMakeRange(range5.location+1, string5.length-range5.location-1)];
                    self.refundDateil.attributedText =string5;
                }
            }else
            {
                self.refundDateil.hidden =YES;
            }
        }
        _lineHightChange.constant =lineHeight*20+10;
        _height =CGRectGetMaxY(self.timer.frame)+lineHeight*20+10+40;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
