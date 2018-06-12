//
//  UIBarButtonItem+ms.h
//  微博微微
//
//  Created by GuoMS on 14-6-18.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ms)
- (id)initWithIcon:(NSString*)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action;
+ (id)itemWithIcon:(NSString*)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action;

- (id)itemWithTitle:(NSString*)title btnIcon:(NSString *)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action;
+ (id)itemWithTitle:(NSString*)title btnIcon:(NSString *)icon highlighted:(NSString *)lighted target:(id)tagget action:(SEL)action;
@end
