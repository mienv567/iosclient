//
//  ListRefreshLocationTBCell.m
//  FanweO2O
//
//  Created by hym on 2017/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ListRefreshLocationTBCell.h"

static NSString *const ID = @"ListRefreshLocationTBCell";

@interface ListRefreshLocationTBCell()

@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end

@implementation ListRefreshLocationTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lbAddress setTextColor:kAppFontColorComblack];
    self.backgroundColor = [UIColor colorWithRed:1.000 green:0.984 blue:0.922 alpha:1.00];
    
    
    
    [self.btnRefresh.imageView setAnimationImages:@[[UIImage imageNamed:@"o2o_refresh_1"],[UIImage imageNamed:@"o2o_refresh_2"],[UIImage imageNamed:@"o2o_refresh_3"],[UIImage imageNamed:@"o2o_refresh_4"],[UIImage imageNamed:@"o2o_refresh_5"],[UIImage imageNamed:@"o2o_refresh_6"]]];
    self.btnRefresh.imageView.animationDuration = 6 * 0.125;
    
    //设置重复次数
    self.btnRefresh.imageView.animationRepeatCount = 0;
     
    
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    ListRefreshLocationTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)setModel:(ListRefreshLocationModel *)model {
    _model = model;
    
    self.lbAddress.text = model.location;
    
    model.hsStart ? [self.btnRefresh.imageView startAnimating] : [self.btnRefresh.imageView stopAnimating];
    
    
    
}

- (IBAction)onClickLocation:(id)sender {
    //开始动画
    
    
    //[self.btnRefresh.imageView startAnimating];
    
    if ([self.delegate respondsToSelector:@selector(startLocation)]) {
        [self.delegate startLocation];
    }
    
}

@end
