//
//  FanweToolHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  工具宏

#ifndef FanweToolHeader_h
#define FanweToolHeader_h

// Integer转String
#define StringFromInteger(i)        [NSString stringWithFormat:@"%@",@(i)]
// Int转String
#define StringFromInt(i)            [NSString stringWithFormat:@"%@",@(i)]

//角度与弧度转换
#define degreesToRadian(x)          (M_PI * (x) / 180.0)
#define radianToDegrees(x)          (180.0 * (x) / M_PI)

#endif /* FanweToolHeader_h */
