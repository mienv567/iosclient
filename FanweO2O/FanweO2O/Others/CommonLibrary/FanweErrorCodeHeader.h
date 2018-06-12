//
//  FanweErrorCodeHeader.h
//  FanweApp
//
//  Created by mac on 16/11/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FanweErrorCodeHeader_h
#define FanweErrorCodeHeader_h

// 定义
typedef NS_ENUM(NSInteger, FWCodeTag)
{
    FWCode_Normal_Error         =   9000, // 一般错误
    FWCode_Net_Error            =   9001, // 网络加载失败
    FWCode_Biz_Error            =   9002, // 业务请求失败，如：服务端返回的 status=0
};


#endif /* FanweErrorCodeHeader_h */
