//
//  StoreListTBCell.m
//  FanweO2O
//
//  Created by hym on 2017/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "StoreListTBCell.h"
#import "DisplayStarView.h"
static NSString *const ID = @"StoreListTBCell";

@interface StoreListTBCell()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAvg_point;
@property (weak, nonatomic) IBOutlet UILabel *lbStore_type;
@property (weak, nonatomic) IBOutlet UIView *sartViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;

@property (weak, nonatomic) IBOutlet UIButton *btnOpen_store_payment;
@property (weak, nonatomic) IBOutlet UIView *openViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbPromote_info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layConstraintOpen;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) IBOutlet UIImageView *imageMaiDan;


@end

@implementation StoreListTBCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.contentView setBackgroundColor:kBackGroundColor];
    [self setBackgroundColor:kBackGroundColor];
    
    [_btnOpen_store_payment setCornerRadius:9];
    _btnOpen_store_payment.layer.borderWidth = 1.0f;
    _btnOpen_store_payment.layer.borderColor = RGB(255,34,68).CGColor;
    [_btnOpen_store_payment setTitleColor:RGB(255,34,68) forState:UIControlStateNormal];
    
    [_lbName setTextColor:kAppFontColorComblack];
    
    [_lbAvg_point setTextColor:kAppFontColorGray];
    
    [_lbStore_type setTextColor:kAppFontColorGray];
    
    [_lbPromote_info setTextColor:kAppFontColorComblack];
    
    [_lbDistance setTextColor:kAppFontColorGray];
    
    
    
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    StoreListTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;

}

- (void)setModel:(StoreListModel *)model {
    _model = model;

    if ([model.open_store_payment integerValue] == 0) {
        self.layConstraintOpen.constant = 0;
        self.openViewContainer.hidden = YES;
        self.imageMaiDan.hidden = YES;
    }else {
        self.layConstraintOpen.constant = 44;
        self.openViewContainer.hidden = NO;
        self.imageMaiDan.hidden = NO;
        
    }
    
    [self.imagePreview sd_setImageWithURL:[NSURL URLWithString:model.preview_v2] placeholderImage:[UIImage imageNamed:@"no_pic"]];
    
    self.lbName.text = model.name;
    self.lbStore_type.text = model.store_type;
    self.lbPromote_info.text = model.promote_info;
    
    NSString *quan_name = @"";

    if ([model.quan_name length] != 0) {
        quan_name = model.quan_name;
    }
    
    if ([model.distance doubleValue] == 0) {
        self.lbDistance.text = [NSString stringWithFormat:@"%@",quan_name];
    }else {
        self.lbDistance.text = [NSString stringWithFormat:@"%@ %.2fkm",quan_name,[model.distance doubleValue]/1000];
    }
    
    
    /*
    if ([model.distance doubleValue] > 1000) {
        
        self.lbDistance.text = [NSString stringWithFormat:@"%@ %.2fkm",quan_name,[model.distance doubleValue]/1000];
    }else {
        self.lbDistance.text = [NSString stringWithFormat:@"%@ %ldm",quan_name,[model.distance integerValue]];
    }
    */
    if (model.avg_point == 0) {
        self.sartViewContainer.hidden = YES;
        self.lbAvg_point.hidden = NO;
        self.lbAvg_point.text = @"暂无评分";
    }else {
        self.sartViewContainer.hidden = NO;
        self.lbAvg_point.hidden = YES;
        for (UIView *view in self.sartViewContainer.subviews) {
            [view removeFromSuperview];
        }
        
        DisplayStarView *sv = [[DisplayStarView alloc]initWithFrame:CGRectMake(0, 0, 80, CGRectGetHeight(self.sartViewContainer.frame))];
        [self.sartViewContainer addSubview:sv];
        
        sv.showStar = model.avg_point * 20;
        
        UILabel *lbavg_point = [UILabel new];
        lbavg_point.textColor = RGB(255, 168, 0);
        [lbavg_point setFont:[UIFont systemFontOfSize:13]];
        
        [self.sartViewContainer addSubview:lbavg_point];
        
        [lbavg_point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sartViewContainer.mas_left).with.offset(80);
            make.centerY.equalTo(self.sartViewContainer).with.offset(0);
        }];
        
        lbavg_point.text = [NSString stringWithFormat:@"%.1f",model.avg_point];
        
    }
    
}

- (IBAction)onClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectPayTheBill:)]) {
        [self.delegate selectPayTheBill:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
