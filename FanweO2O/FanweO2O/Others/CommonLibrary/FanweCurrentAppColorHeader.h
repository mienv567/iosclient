//
//  CurrentAppColorMacro.h
//  FanweApp
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef CurrentAppColorMacro_h
#define CurrentAppColorMacro_h

// 以下为大众色值（可能整个app都有用到）

// app主色调(237, 79, 80)
#define kAppMainColor               RGB(255, 34, 68)       // app主色调
#define kAppMainHeaderColor         [UIColor whiteColor]
#define kNavBarThemeColor           [UIColor whiteColor]    // 导航主色调
// app主颜色 黑色 大部分黑色都用这个
#define KAppMainTextBackColor       [UIColor colorWithRed:0.239 green:0.255 blue:0.271 alpha:1.00]

// 默认背景色
#define kBackGroundColor            RGB(238, 238, 238)
#define kGaryGroundColor            [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.00]
#define kWhiteGatyGroundColor       [UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00]

//// 灰色字体(颜色：由深到浅)
#define kAppGrayColor1              RGB(85, 85, 85)
#define kAppGrayColor2              RGB(153, 153, 153)
#define kAppGrayColor3              RGB(168, 168, 168)
#define kAppGrayColor4              RGB(203, 203, 203)

//线条颜色
#define kLineColor                  RGB(227,229,233)
#define kLineLightColor             RGB(202,202,202)
#define K_O2OLineColor              [UIColor colorWithRed:0.945 green:0.949 blue:0.957 alpha:1.00];

// 间隔、线条颜色
#define kAppSpaceColor              RGB(229, 229, 229)
#define kAppSpaceColor2             RGB(235, 238, 238)


// 边框颜色
#define kAppBorderColor             [(kAppSpaceColor) CGColor]

// 黑色透明色（透明度：由高到低）
#define kGrayTransparentColor1      [[UIColor blackColor] colorWithAlphaComponent:0.1]
#define kGrayTransparentColor2      [[UIColor blackColor] colorWithAlphaComponent:0.2]
#define kGrayTransparentColor3      [[UIColor blackColor] colorWithAlphaComponent:0.4]
#define kGrayTransparentColor4      [[UIColor blackColor] colorWithAlphaComponent:0.6]
#define kGrayTransparentColor5      [[UIColor blackColor] colorWithAlphaComponent:0.85]
#define kGrayTransparentColor6      [[UIColor blackColor] colorWithAlphaComponent:0.95]



// 以下为小众色值（可能单纯某个类用到）


#endif /* CurrentAppColorMacro_h */
