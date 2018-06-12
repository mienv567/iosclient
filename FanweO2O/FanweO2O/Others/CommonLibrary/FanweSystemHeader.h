//
//  FanweSystemHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  系统宏

#ifndef FanweSystemHeader_h
#define FanweSystemHeader_h

// 屏幕frame,bounds,size,scale
#define kScreenFrame            [UIScreen mainScreen].bounds
#define kScreenBounds           [UIScreen mainScreen].bounds
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define kScreenScale            [UIScreen mainScreen].scale
#define kScreenW                [[UIScreen mainScreen] bounds].size.width
#define kScreenH                [[UIScreen mainScreen] bounds].size.height
#define kScaleW                 (kScreenW)*(kScreenScale)
#define kScaleH                 (kScreenH)*(kScreenScale)
#define kMainColor              RGB(98, 178, 249)

#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height

// 主窗口的宽、高
#define kMainScreenWidth        MainScreenWidth()
#define kMainScreenHeight       MainScreenHeight()
static __inline__ CGFloat MainScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat MainScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

// 状态栏、导航栏、标签栏高度
#define kStatusBarHeight        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kNavigationBarHeight    (self.navigationController.navigationBar.frame.size.height)
#define kTabBarHeight           (self.tabBarController.tabBar.frame.size.height)

// 日志输出宏定义1
#ifdef DEBUG
// 调试状态
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
// 发布状态
#define NSLog(...)

#endif

// 日志输出宏定义2
#ifdef DEBUG
// 调试状态
#ifndef DebugLog
#define DebugLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif
#else
// 发布状态
#ifndef DebugLog
#define DebugLog(fmt, ...) // NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif
#endif


#endif /* FanweSystemHeader_h */
