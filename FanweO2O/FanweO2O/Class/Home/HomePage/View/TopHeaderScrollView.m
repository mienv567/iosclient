//
//  TopScrollView.m
//  FanweO2O
//
//  Created by ycp on 16/12/1.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "TopHeaderScrollView.h"

@implementation TopHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBezierPath *maskPath =[UIBezierPath bezierPath];
        //起点
        [maskPath moveToPoint:CGPointMake(0, 0)];
        [maskPath addLineToPoint:CGPointMake(0, 0)];
        [maskPath addLineToPoint:CGPointMake(kScreenW, 0)];
        [maskPath addLineToPoint:CGPointMake(kScreenW, CGRectGetMaxY(self.frame)-20)];
        [maskPath addQuadCurveToPoint:CGPointMake(0, CGRectGetMaxY(self.frame)-20) controlPoint:CGPointMake(kScreenW/2, CGRectGetMaxY(self.frame))];
        CAShapeLayer *maskLayer =[[CAShapeLayer alloc] init];
        maskLayer.path =maskPath.CGPath;
        self.layer.mask =maskLayer;

    }
    return self;
}

@end
