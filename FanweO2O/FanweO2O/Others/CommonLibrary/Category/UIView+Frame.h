//
//  UIView+Frame.h
//  3.15 彩票
//
//  Created by 安分守己小年轻 on 16/3/16.
//  Copyright © 2016年 zsj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 分类里面不能生成成员属性
// 会自动生成get，set方法和成员属性

// @property如果在分类里面只会生成get,set方法的声明，并不会生成成员属性。
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

/**
 *  设置view的圆角
 */
- (void)setCornerRadius:(float)radius;

@end
