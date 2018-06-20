//
//  CouponCell.m
//  ZhoubaitongO2O
//
//  Created by harlan on 2018/6/19.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "CouponCell.h"
@interface CouponCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyLabel;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIImageView *indicateView;

@end

@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setModel:(CouponModel *)model {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// 立即使用按钮
- (IBAction)useBtnClick:(id)sender {
    
    
    
}

@end
