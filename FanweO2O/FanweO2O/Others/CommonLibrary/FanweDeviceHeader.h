//
//  FanweDeviceHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FanweDeviceHeader_h
#define FanweDeviceHeader_h

#define isIPad()                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone()              (!isIPad())

#define isIPhone5()             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone4()             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS7()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

#define isIOS6()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)

//判断设备是否是ipad
#define isiPad                  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//判断设备是否IPHONE5
#define iPhone5                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//ios系统版本
#define ios8x                   [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f
#define ios7x                   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x                   [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iosNot6x                [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

//各个版本手机
#define iphone4x_3_5            ([UIScreen mainScreen].bounds.size.height==480.0f)
#define iphone5x_4_0            ([UIScreen mainScreen].bounds.size.height==568.0f)
#define iphone6_4_7             ([UIScreen mainScreen].bounds.size.height==667.0f)
#define iphone6Plus_5_5         ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

#endif /* FanweDeviceHeader_h */
