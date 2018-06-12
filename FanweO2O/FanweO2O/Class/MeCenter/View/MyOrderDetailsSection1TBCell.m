//
//  MyOrderDetailsSection1TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection1TBCell.h"

#import "MyOrderDetailsModel.h"

static NSString *const ID = @"MyOrderDetailsSection1TBCell";

@interface MyOrderDetailsSection1TBCell()

@property (weak, nonatomic) IBOutlet UILabel *lbOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@end

@implementation MyOrderDetailsSection1TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lbOrderNumber setTextColor:kAppFontColorGray];
    [_lbOrderNumber setFont:[UIFont systemFontOfSize:13]];
    [_line setBackgroundColor:kLineColor];
    
    [_lbStatus setTextColor:RGB(255, 34, 68)];
    [_lbStatus setFont:[UIFont systemFontOfSize:15]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection1TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setOrderModel:(MyOrderDetailsModel *)orderModel {
    _orderModel = orderModel;
    
    _lbOrderNumber.text = [NSString stringWithFormat:@"订单号:%@",orderModel.order_sn];
    
    _lbStatus.text = orderModel.status_name;
    
    if ([orderModel.status_name isEqualToString:@"待付款"]) {
        
        self.viewContainer.hidden = NO;
        self.layoutHeight.constant = 44.5f;
        self.lbPrice.hidden = NO;
        NSString *content;
        if ([self.orderModel.app_format_pay_amount floatValue] == 0) {
            content = [NSString stringWithFormat:@"共%ld件商品 需付款：￥%@",orderModel.count,orderModel.app_format_total_price];
        }else {
            content = [NSString stringWithFormat:@"共%ld件商品 需付款：￥%@,已付￥%@",orderModel.count,orderModel.app_format_total_price,self.orderModel.app_format_pay_amount];
        }
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString
                                                    : content];
        NSRange range = [content rangeOfString:[NSString stringWithFormat:@"￥%@",orderModel.app_format_total_price]];
        
        if (range.location != NSNotFound) {
            
            [attributedStr
             addAttribute: NSForegroundColorAttributeName
             
             
             value: kAppMainColor
             
             range: range];
            
            
            [attributedStr
             addAttribute: NSFontAttributeName
             
             
             value: [UIFont systemFontOfSize:17
                     ]
             
             range: NSMakeRange(range.location + 1, range.length - 3
                                )];

        }
        self.lbPrice.attributedText = attributedStr;

        
    }else {
        
        self.viewContainer.hidden = YES;
        self.lbPrice.hidden = YES;
        self.layoutHeight.constant = 0;
    }
}

@end
