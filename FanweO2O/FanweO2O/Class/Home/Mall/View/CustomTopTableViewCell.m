//
//  CustomTopTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 16/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CustomTopTableViewCell.h"
static NSString *const ID = @"CustomTopTableViewCell";
@implementation CustomTopTableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    CustomTopTableViewCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.leftButton setTitle:@"分类" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font =[UIFont systemFontOfSize:12];
    [self.leftButton setTitleEdgeInsets:UIEdgeInsetsMake(18, -30 , 0, 0)];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"fw_home_classification"] forState:UIControlStateNormal];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 5, 0, 0)];
    
    
    [self.rightButton setTitle:@"搜索商品或店铺" forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font =[UIFont systemFontOfSize:12];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rightButton.backgroundColor =[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00];
    
    
    
}
- (IBAction)leftClickBtn:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(leftBtn)]) {
        [_delegate leftBtn];
    }
}
- (IBAction)rightClickBtn:(UIButton *)sender {
    if (_delegate  && [_delegate respondsToSelector:@selector(rightBtn)]) {
        [_delegate rightBtn];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
