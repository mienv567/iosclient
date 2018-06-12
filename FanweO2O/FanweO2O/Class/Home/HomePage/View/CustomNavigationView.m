//
//  CustomNavigationView.m
//  FanweO2O
//
//  Created by ycp on 16/11/29.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "CustomNavigationView.h"
#import "CityPositioningViewController.h"
#import "CustomGoodsTableViewCell.h"


@implementation CustomNavigationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = RGBA(0, 0, 0, 1);
    _fanweApp =[GlobalVariables sharedInstance];
    self.leftButton.titleLabel.font =kAppTextFont14;
    self.rightButton.layer.masksToBounds =YES;
    self.rightButton.layer.cornerRadius = CGRectGetHeight(self.rightButton.frame) / 2;
    [self.rightButton setTitle:@"搜索商品或店铺" forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font =kAppTextFont12;
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.rightButton setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rightButton.backgroundColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:1.00];
    [self.rightButton addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    if (kOlderVersion==1) {
        self.messageIcon.hidden =YES;
        self.messageButton.hidden =YES;
        self.messageImageView.hidden =YES;
        self.rightButton.width =kScreenW -10 -CGRectGetWidth(self.leftButton.frame)-30;
    }
    self.messageIcon.layer.cornerRadius =self.messageIcon.size.width/2;
    self.messageIcon.layer.masksToBounds =YES;
    self.messageIcon.hidden =YES;
    self.messageIcon.backgroundColor =[UIColor colorWithRed:1.000 green:0.518 blue:0.000 alpha:1.00];
    
}
- (void)setModel:(O2OHomeMainModel *)model
{
    _model = model;
    if (kOlderVersion==1) {
        self.messageIcon.hidden =YES;
        self.messageButton.hidden =YES;
        self.messageImageView.hidden =YES;
        self.rightButton.width =kScreenW -10 -CGRectGetWidth(self.leftButton.frame)-30;
    }else{
        if (_fanweApp.is_login ==YES) {
            
            if (_model.not_read_msg > 0) {
                self.messageIcon.hidden = NO;
            }else
            {
                self.messageIcon.hidden = YES;
            }
        }else
        {
            self.messageIcon.hidden = YES;
        }
    }
    
}

+ (instancetype)EditNibFromXib
{
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (IBAction)searchButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToDiscoveryViewController)]) {
        [_delegate goToDiscoveryViewController];
    }
}
- (IBAction)positioningButton:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(customLeftButton)]) {
        [_delegate customLeftButton];
    }
    
    
}
- (IBAction)messageJump:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:)]) {
        [_delegate loginView:_fanweApp.is_login];
    }
}
@end
