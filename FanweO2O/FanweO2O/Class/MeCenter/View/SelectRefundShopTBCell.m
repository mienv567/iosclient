//
//  SelectRefundShopTBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SelectRefundShopTBCell.h"
#import "RefundShopModel.h"

static NSString *const ID = @"SelectRefundShopTBCell";

@interface SelectRefundShopTBCell()

@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStandard;       //规格
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbPassword;

@end

@implementation SelectRefundShopTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer= [self.imageIcon layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:2];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[kLineColor CGColor]];
    
    [self.lbName setTextColor:kAppFontColorComblack];
    [self.lbStatus setTextColor:kAppFontColorComblack];
    [self.lbStandard setTextColor:kAppFontColorGray];
    [self.lbPassword setTextColor:kAppFontColorGray];
    [self.line setBackgroundColor:kLineColor];

}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    SelectRefundShopTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setOrderItem:(RefundShopModel *)orderItem {
    _orderItem = orderItem;
    
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:orderItem.deal_icon] placeholderImage:kDefaultCoverIcon];
    
    self.lbName.text = orderItem.name;
    self.lbStatus.text = orderItem.deal_orders;
    if ([orderItem.attr_str length] > 0) {
       self.lbStandard.text = [NSString stringWithFormat:@"规格:%@",orderItem.attr_str];
        self.lbStandard.hidden = NO;
    }else {
        self.lbStandard.hidden = YES;
    }
    
    
    if (self.orderItem.hsSelect) {
        [self.btnSelect setImage:[UIImage imageNamed:@"o2o_ tick_h_icon"] forState:UIControlStateNormal];
    }else {
        [self.btnSelect setImage:[UIImage imageNamed:@"o2o_ tick_icon"] forState:UIControlStateNormal];
    }
    
    if ([orderItem.password length] > 0) {
        self.lbPassword.text = [NSString stringWithFormat:@"劵码: %@",self.orderItem.password];
    }else {
        self.lbPassword.text = @"";
    }
    
    
}

- (IBAction)onClickSelect:(id)sender {
    self.orderItem.hsSelect = !self.orderItem.hsSelect;
    
    if (_delegate &&[_delegate respondsToSelector:@selector(refreshTableView:)]) {
       
        [_delegate refreshTableView:self.orderItem];
    }
}


@end
