//
//  SetButtonTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SetButtonTableViewCell.h"

@implementation SetButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =kGaryGroundColor;
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(10, 0, kScreenW-20, 44);
        button.backgroundColor =[UIColor whiteColor];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.titleLabel.font =kAppTextFont12;
        [button addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)exitButtonClick
{
    NOTIFY_POST(@"logChange", @"logout");
    NSLog(@"----> %@",_delegate);
    if (_delegate && [_delegate respondsToSelector:@selector(loginOutEnd)]) {
        [_delegate loginOutEnd];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
