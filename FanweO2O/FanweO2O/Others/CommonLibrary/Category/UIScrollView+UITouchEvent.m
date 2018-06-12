//
//  UIScrollView+UITouchEvent.m
//  FanweO2O
//
//  Created by ycp on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder]touchesBegan:touches withEvent:event];
}
@end
