//
//  MyOrderDetailsSection22TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/5/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection22TBCell.h"
#import "MyOrderDetailsModel.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"

static NSString *const ID = @"MyOrderDetailsSection22TBCell";

@interface MyOrderDetailsSection22TBCell()

@property (weak, nonatomic) IBOutlet UILabel *lbConsignee;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnClick;

@end

@implementation MyOrderDetailsSection22TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lbConsignee setTextColor:[MyTool colorWithHexString:@"#999999"]];
    [self.lbAddress setTextColor:[MyTool colorWithHexString:@"#999999"]];
    
    //[UILabel changeLineSpaceForLabel:self.lbAddress WithSpace:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection22TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setOrderModel:(MyOrderDetailsModel *)orderModel {
    _orderModel = orderModel;
    
    self.lbConsignee.text =orderModel.location_name;
    self.lbAddress.text = [NSString stringWithFormat:@"%@\n%@  ",orderModel.tel,orderModel.location_address];
    [self.lbAddress changeLineSpaceForWithSpace:2];
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
