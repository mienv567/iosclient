//
//  MyOrderDetailsSection5TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection5TBCell.h"

#import "MyOrderDetailsModel.h"

static NSString *const ID = @"MyOrderDetailsSection5TBCell";

@interface MyOrderDetailsSection5TBCell()



@end

@implementation MyOrderDetailsSection5TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lbName.textColor = kAppFontColorComblack;
    self.lbValue.textColor = kAppFontColorComblack;
    
    [self.line setBackgroundColor:kLineColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection5TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setOrderModel:(MyOrderDetailsFeeinfo *)orderModel {
    _orderModel = orderModel;
    _lbName.text = orderModel.name;
    
    if (orderModel.symbol < 0) {
        
        _lbValue.text = [NSString stringWithFormat:@"-￥%@",orderModel.value];
        self.lbValue.textColor = RGB(255, 34, 68);
    
    }else{
        _lbValue.text = [NSString stringWithFormat:@"￥%@",orderModel.value];
        self.lbValue.textColor = kAppFontColorComblack;
    }
    
}

@end
