//
//  RightLittleButtonOnBottom.m
//  FanweO2O
//
//  Created by ycp on 16/12/2.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "RightLittleButtonOnBottom.h"

@implementation RightLittleButtonOnBottom
{
//    UIButton           *_rightLittleButtonOnBottom;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
     
    }
    return self;
}
- (void)backToTop
{
    if (_delegate && [_delegate respondsToSelector:@selector(backToTop)]) {
        [_delegate backToTop];
    }
}
- (void)setKind:(NSInteger)kind
{
    if (kind ==0) {
         self.frame =CGRectMake(kScreenW-45-8, kScreenH-45-52, 54, 50);
    }else if (kind ==1){
        self.frame =CGRectMake(kScreenW-45-8, kScreenH, 54, 50);
    }
    else{
        self.frame =CGRectMake(kScreenW-45-8, kScreenH-130, 54, 50);
    }
}
@end
