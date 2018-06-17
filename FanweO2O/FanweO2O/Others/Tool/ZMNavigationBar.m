//
//  ZMNavigationBar.m
//  MyBoRuiSi
//
//  Created by baoqiang song on 2017/9/28.
//  Copyright © 2017年 itcast.com. All rights reserved.
//

#import "ZMNavigationBar.h"

@implementation ZMNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setShadowImage:[[UIImage alloc] init]];
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    return self;

}

//支持ios11
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 注意导航栏及状态栏高度适配
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.frame.size.height);
    for (UIView *view in self.subviews) {
        view.backgroundColor = [UIColor clearColor];

        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.backgroundColor = [UIColor clearColor];
 
            view.frame = self.bounds;
//            调整cotentview的位置
        }else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            if(iPhoneX){
                frame.origin.y = 40;

            }else {
                frame.origin.y = 20;

            }
            frame.size.height = self.bounds.size.height - frame.origin.y;
    
            view.frame = frame;
        }
    }
}
@end
