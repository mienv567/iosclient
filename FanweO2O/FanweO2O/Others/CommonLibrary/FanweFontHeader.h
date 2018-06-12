//
//  FanweFontHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  字体宏

#ifndef FanweFontHeader_h
#define FanweFontHeader_h

#define kAppTextFont16          [UIFont systemFontOfSize:16]
#define KAppTextFont15          [UIFont systemFontOfSize:15]
#define kAppTextFont14          [UIFont systemFontOfSize:14]
#define KAppTextFont13          [UIFont systemFontOfSize:13]
#define kAppTextFont12          [UIFont systemFontOfSize:12]
#define KAppTextFont11          [UIFont systemFontOfSize:11]
#define kAppTextFont10          [UIFont systemFontOfSize:10]

//根据屏幕尺寸适配字体大小
#define kAppSystemFontOfSiz17       [UIFont systemFontOfSize:17*Adaptive]
#define kAppSystemFontOfSiz16       [UIFont systemFontOfSize:16*Adaptive]
#define kAppSystemFontOfSiz15       [UIFont systemFontOfSize:15*Adaptive]
#define kAppSystemFontOfSiz14       [UIFont systemFontOfSize:14*Adaptive]
#define kAppSystemFontOfSiz13       [UIFont systemFontOfSize:13*Adaptive]
#define kAppSystemFontOfSiz12       [UIFont systemFontOfSize:12*Adaptive]
#define kAppSystemFontOfSiz11       [UIFont systemFontOfSize:11*Adaptive]
#define kAppSystemFontOfSiz10       [UIFont systemFontOfSize:10*Adaptive]

#define Adaptive  SCREEN_WIDTH /375 < 0 ? 1 : (SCREEN_WIDTH > 414 ? 414 :  SCREEN_WIDTH) /375


//字体颜色从深到淡
#define kAppFontColorComblack       RGB(53,61,68)
#define kAppFontColorLightGray      RGB(102,102,102)
#define kAppFontColorGray           RGB(153,153,153)
#define kAppFontColorTheme          RGB(255,34,68)
#define kAppFontColorRed            RGB(255,48,80)


#endif /* FanweFontHeader_h */
