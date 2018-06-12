//
//  leftTextFieldView.m
//  FanweO2O
//
//  Created by ycp on 16/12/16.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LeftTextFieldView.h"

@implementation LeftTextFieldView


- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 5; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
}

@end
