//
//  LcLeftTextField.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/13.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "LcLeftTextField.h"

@implementation LcLeftTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self setTextFieldLeftPaddingWidth:50];
    }return self;
}

- (void)awakeFromNib {
    [self setTextFieldLeftPaddingWidth:50];

}


-(void)setTextFieldLeftPaddingWidth:(CGFloat)leftWidth
{
    CGRect frame = self.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
}
@end
