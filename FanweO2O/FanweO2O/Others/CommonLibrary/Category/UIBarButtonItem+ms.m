//
//  UIBarButtonItem+ms.m
//  微博微微
//
//  Created by GuoMS on 14-6-18.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import "UIBarButtonItem+ms.h"

@implementation UIBarButtonItem (ms)
- (id)initWithIcon:(NSString*)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action
{
    //创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置普通图片背景
    UIImage *image = [UIImage imageNamed:icon];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    //设置高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:lighted] forState:UIControlStateHighlighted];
    
    //设置尺寸
    btn.bounds = (CGRect){CGPointZero,image.size};
    [btn addTarget:tagget action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithIcon:(NSString*)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action
{
    return [[self alloc]initWithIcon:icon highlighted:lighted target:tagget action:action];
}

+ (id)itemWithTitle:(NSString*)title btnIcon:(NSString *)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action
{
    return [[self alloc]itemWithTitle:title btnIcon:icon highlighted:lighted target:tagget action:action];
}

- (id)itemWithTitle:(NSString*)title btnIcon:(NSString *)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action
{
    //创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置普通图片背景
//    UIImage *image = [UIImage imageNamed:icon];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
    //设置高亮图片
//    [btn setBackgroundImage:[UIImage imageNamed:lighted] forState:UIControlStateHighlighted];
    //设置图片
    [btn setTitle:title forState:UIControlStateNormal];
    
    //设置尺寸
//    btn.bounds = (CGRect){CGPointZero,image.size};
    [btn addTarget:tagget action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.bounds = (CGRect){CGPointZero,{50,30}};
    return [self initWithCustomView:btn];
}
@end
