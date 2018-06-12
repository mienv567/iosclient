//
//  CustomTitleView.m
//  FanweO2O
//
//  Created by ycp on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CustomTitleView.h"

@implementation CustomTitleView

+ (instancetype)EditNibFromXib
{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    self.searchButton.backgroundColor =[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00];
    
}
- (IBAction)leftButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popBack)]) {
        [_delegate popBack];
    }
}
- (IBAction)rightButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rightBtn)]) {
        [_delegate rightBtn];
    }
}
@end
