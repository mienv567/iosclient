//
//  PopWhiteView.m
//  FanweO2O
//
//  Created by ycp on 17/2/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PopWhiteView.h"

@implementation PopWhiteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        UIButton *refButton =[UIButton buttonWithType:UIButtonTypeCustom];
        refButton.frame =CGRectMake((kScreenW-20)/2, (frame.size.height -20)/2, 20, 20);
        [refButton setImage:[UIImage imageNamed:@"pop_refresh"] forState:UIControlStateNormal];
        [refButton addTarget:self action:@selector(refButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refButton];
    }
    return self;
}
- (void)refButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(refresh)]) {
        [_delegate refresh];
    }
}
@end
