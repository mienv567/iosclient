//
//  RefCustomView.m
//  FanweO2O
//
//  Created by ycp on 17/3/30.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefCustomView.h"

@interface RefCustomView()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UILabel *label2;
@property (weak, nonatomic) UILabel *label3;

@end

@implementation RefCustomView

- (void)prepare
{
    [super prepare];
    
    self.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text =@"没有更多信息~";
    [self addSubview:label];
    self.label =label;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.backgroundColor =[UIColor colorWithRed:0.922 green:0.933 blue:0.937 alpha:1.00];
    [self addSubview:label2];
    self.label2 =label2;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.backgroundColor =[UIColor colorWithRed:0.922 green:0.933 blue:0.937 alpha:1.00];
    [self addSubview:label3];
    self.label3 =label3;
    
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame =CGRectMake((kScreenW-90)/2, 0, 90, 40);
    self.label2.frame =CGRectMake(CGRectGetMinX(self.label.frame)-40, 0, 30, 0.5);
    self.label2.centerY =self.label.centerY;
    self.label3.frame =CGRectMake(CGRectGetMaxX(self.label.frame)+10, 0, 30, 0.5);
    self.label3.centerY =self.label.centerY;
    
}


@end
