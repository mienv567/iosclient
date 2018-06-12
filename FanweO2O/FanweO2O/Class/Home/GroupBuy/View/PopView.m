//
//  PopView.m
//  FanweO2O
//
//  Created by ycp on 17/2/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PopView.h"
#import "PopWhiteView.h"

@interface PopView () <PopWhiteViewDelegate>

@end

@implementation PopView
@synthesize closeButton=closeButton;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fanweApp =[GlobalVariables sharedInstance];
        self.backgroundColor =[UIColor clearColor];
        _nameArray =[NSArray arrayWithObjects:@"首页",@"搜索", @"消息", @"购物车", @"我的",nil];
        _imageArray =[NSArray arrayWithObjects:@"pop_home",@"pop_search",@"pop_messgae", @"pop_shopping", @"pop_me", nil];
        [self buildForButtonClick];
    }
    return self;
}
- (void)buildForButtonClick
{
    PopWhiteView *whiteView =[[PopWhiteView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    whiteView.delegate =self;
    [self addSubview:whiteView];
    for (int i =0; i<5; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor =[UIColor colorWithRed:0.980 green:0.980 blue:0.980 alpha:1.00];
        btn.titleLabel.font =KAppTextFont13;
        UIImage *image =[UIImage imageNamed:_imageArray[i]];
        NSString *nameStr =[NSString stringWithFormat:@"%@",_nameArray[i]];
        [btn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
        btn.frame =CGRectMake(i*(kScreenW/5), CGRectGetMaxY(whiteView.frame), kScreenW/5, 80);
        [btn setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        CGSize size1 =[nameStr boundingRectWithSize:CGSizeMake(kScreenW/5, btn.titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KAppTextFont13} context:nil].size;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0.8*image.size.height, -0.5*image.size.width, -0.8*image.size.height, 0.5*image.size.width);
        btn.imageEdgeInsets =UIEdgeInsetsMake(-0.8*size1.height, 0.5*size1.width, 0.8*size1.height, -0.5*size1.width);
        [btn setTitle:nameStr forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =i+9999;
        [self addSubview:btn];
    }
    self.self.littleIcon =[[UIImageView alloc] initWithFrame:CGRectMake(3*(kScreenW/5)-kScreenW/10+10, CGRectGetMaxY(whiteView.frame)+15, 5, 5)];
    self.littleIcon.backgroundColor =[UIColor redColor];
    self.littleIcon.layer.masksToBounds =YES;
    self.littleIcon.layer.cornerRadius =self.littleIcon.frame.size.height/2;
    [self addSubview:self.littleIcon];
    
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(whiteView.frame)+80, kScreenW, kScreenH-(CGRectGetMaxY(whiteView.frame)+80))];
//    backView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:backView];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame =backView.bounds;
    [backView addSubview:effectView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    tap.numberOfTouchesRequired =1;
    [backView addGestureRecognizer:tap];
    closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-(CGRectGetMaxY(whiteView.frame)+80)-80, 40, 40);
    [closeButton setImage:[UIImage imageNamed:@"pop_cha"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeButton];
}
 - (void)setNo_msg:(NSInteger)no_msg
{
    if (no_msg >0) {
        self.littleIcon.hidden =NO;
    }else
    {
         self.littleIcon.hidden =YES;
    }
}
- (void)backButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(back)]) {
        [_delegate back];
    }
}
- (void)closeButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(back)]) {
        [_delegate back];
    }
}
- (void)refresh
{
    if (_delegate && [_delegate respondsToSelector:@selector(toRefresh)]) {
        [_delegate toRefresh];
    }
}
- (void)btnClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectButton:)]) {
        [_delegate selectButton:sender.tag-9999];
    }
   
}
@end
