//
//  MyOrderImageView.m
//  FanweO2O
//
//  Created by hym on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderImageView.h"

@implementation MyOrderImageView

+ (instancetype )createView {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"MyOrderImageView" owner:nil options:nil];
    
    return [objs firstObject];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CALayer *layer= [self layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:2];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[kLineColor CGColor]];
    
}

@end
