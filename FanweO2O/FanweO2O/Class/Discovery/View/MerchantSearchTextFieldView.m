//
//  MerchantSearchTextFieldView.m
//  TXSLiCai
//
//  Created by Owen on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "MerchantSearchTextFieldView.h"

@interface MerchantSearchTextFieldView ()
{
    UIView *line;
    UIImageView *imageView;
}
@end
@implementation MerchantSearchTextFieldView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        self.goBackButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.goBackButton setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
        [self.goBackButton addTarget:self action:@selector(goBackClickButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.goBackButton];
        
        UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame=CGRectMake(kScreenW -51, (44-19)/2, 46, 19);
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
        searchBtn.titleLabel.font =KAppTextFont13;
        [searchBtn addTarget:self action:@selector(searchClickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchBtn];

        _middleView =[[UIView alloc] init ];
    
        _middleView.backgroundColor =K_O2OLineColor;
        [self addSubview:_middleView];
        _middleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _middleBtn.frame =CGRectMake(5, 0, 50, 28);
        
        [_middleBtn setTitle:@"团购" forState:UIControlStateNormal];
        
        [_middleBtn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
        _middleBtn.titleLabel.font =kAppTextFont12;
        [_middleBtn setImage:[UIImage imageNamed:@"dc_takeout_down"] forState:UIControlStateNormal];
        [_middleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 38, 0, 0)];
        [_middleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [_middleBtn addTarget:self action:@selector(middleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_middleView addSubview:_middleBtn];
        line =[[UIView alloc] init ];
        line.frame =CGRectMake(CGRectGetMaxX(_middleBtn.frame)+5, (28-14)/2, 0.5, 14);
        line.backgroundColor =kAppSpaceColor;
        [_middleView addSubview:line];
        imageView =[[UIImageView alloc] init ];
        imageView.frame =CGRectMake(CGRectGetMaxX(line.frame)+5, (28-12)/2, 12, 12);
        imageView.image =[UIImage imageNamed:@"search"];
        [_middleView addSubview:imageView];
        self.searchTextField =[[UITextField alloc] init];
        self.searchTextField.placeholder =@"搜索团购";
        self.searchTextField.font =KAppTextFont13;
        self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        [_middleView addSubview:self.searchTextField];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenW, 0.5)];
        lineView.backgroundColor =kGaryGroundColor;
        [self addSubview:lineView];
        
    }
    return self;
}
- (void)setIsGoBackHidden:(BOOL)isGoBackHidden
{
   
    
    if (isGoBackHidden ==YES) {
         self.goBackButton.hidden =YES;
//        self.goBackButton.frame =CGRectMake(10, (44-22)/2, 22, 22);
            _middleView.frame =CGRectMake(CGRectGetMaxX(self.goBackButton.frame)+10, (44-28)/2, kScreenW-20-CGRectGetWidth(self.goBackButton.frame)-46, 28);
        self.searchTextField.frame =CGRectMake(CGRectGetMaxX(imageView.frame)+5, 0, kScreenW-20-CGRectGetWidth(self.goBackButton.frame)-46-CGRectGetMaxX(imageView.frame), 28);
    }
    else
    {
        self.goBackButton.hidden =NO;
       self.goBackButton.frame =CGRectMake(10, (44-22)/2, 22, 22);
            _middleView.frame =CGRectMake(CGRectGetMaxX(self.goBackButton.frame)+10, (44-28)/2, kScreenW-20-CGRectGetWidth(self.goBackButton.frame)-46, 28);
        self.searchTextField.frame =CGRectMake(CGRectGetMaxX(imageView.frame)+5, 0, kScreenW-20-CGRectGetWidth(self.goBackButton.frame)-46-CGRectGetMaxX(imageView.frame), 28);
    }
}
- (void)goBackClickButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(goToBack)]) {
        [_delegate goToBack];
    }
}
- (void)searchClickBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchClickButton)]) {
        [_delegate searchClickButton];
    }
}
- (void)middleButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(middleClickBtnToView)]) {
        [_delegate middleClickBtnToView];
    }
}

@end
