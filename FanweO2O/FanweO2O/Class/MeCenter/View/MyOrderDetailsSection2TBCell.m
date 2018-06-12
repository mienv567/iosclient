//
//  MyOrderDetailsSection2TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection2TBCell.h"
#import "MyOrderDetailsModel.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"

static NSString *const ID = @"MyOrderDetailsSection1TBCell";

@interface MyOrderDetailsSection2TBCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbConsignee;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnClick;

@end

@implementation MyOrderDetailsSection2TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lbConsignee setTextColor:kAppFontColorComblack];
    [self.lbAddress setTextColor:kAppFontColorGray];
    
    [self.btnClick setTitleColor:kAppFontColorGray forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection2TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setOrderModel:(MyOrderDetailsModel *)orderModel {
    _orderModel = orderModel;
    
    
    if ([orderModel.location_id intValue]  > 0) {
        //自提
        self.lbConsignee.text = [NSString stringWithFormat:@"自提门店:%@",orderModel.location_name];
        self.lbAddress.text = orderModel.location_address;
        self.btnClick.hidden = NO;
    }else {
        self.lbConsignee.text = [NSString stringWithFormat:@"收件人:%@ %@",orderModel.consignee,orderModel.mobile];
        self.lbAddress.text = orderModel.address;
        self.btnClick.hidden = YES;
    
    }
}

- (IBAction)onClick:(id)sender {
    if ([_orderModel.location_id intValue]  > 0) {
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        jump.url = _orderModel.location_address_url;
        
        [FWO2OJump didSelect:jump];
    }
}

@end
