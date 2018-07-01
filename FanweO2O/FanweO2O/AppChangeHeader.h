//
//  AppChangeHeader.h
//  FanweO2O
//
//  Created by mac on 16/12/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef AppChangeHeader_h
#define AppChangeHeader_h

// app时间版本号（主要用来提示升级等）
#define     VersionTime             @"2017083003"
// app版本号
#define     VersionNum              @"2.6.4"


#define DEBUGMODE 0

#if DEBUGMODE == 0

#define API_BASE_URL          @"https://dev.yitonggo.com/mapi/index.php"
#define API_LOTTERYOUT_URL    @"https://dev.yitonggo.com/wap/index.php"

//#define API_BASE_URL        @"http://o2o.fanwe.cn/mapi/index.php"
//#define API_LOTTERYOUT_URL  @"http://o2o.fanwe.cn/wap/index.php"

#else

#define API_BASE_URL          @"https://app.yitonggo.com/mapi/index.php"
#define API_LOTTERYOUT_URL    @"https://app.yitonggo.com/wap/index.php"
//#define API_BASE_URL        @"http://testo2onew.fanwe.net/mapi/index.php"
//#define API_LOTTERYOUT_URL  @"http://testo2onew.fanwe.net/wap/index.php"

#endif

#define WEB_BASE_INFO   @"&from=app&r_type=5&page_finsh=1"


//版本判断
//1-->一期 2-->二期 3-->三期
#ifndef kOlderVersion

#define kOlderVersion                           3

#endif

#define     AlipayScheme            @"fanwe.o2oNew.shopping"
// 友盟KEY
#define     UmengKey                @"57689a68e0f55a2a32004ca8"
// 友盟Secret
#define     UmengSecret             @"z3ikva5jfcurxvtrycgrbzglayl0lkml"
// 微信AppID     需要修改的上线
#define     WeixinAppId             @"wxe85ae2c668d01c8f"
// 微信Secret
#define     WeixinSecret            @"80d9d4026fe15d63245f44819b3fe315"
// QQ的AppID
#define     QQAppId                 @"1105454078"
// QQ的Secret
#define     QQSecret                @"9TIcsfE9EpeamO4R"
// 新浪AppID
#define     SinaAppId               @"3310867184"
// 新浪Secret
#define     SinaSecret              @"94ccd4786bdaf1967fb2f4d9b2531ae8"
// 百度地图KEY
#define     BaiMapKey               @"5XJBZ-TFWA6-OVASI-M4QSO-RH723-FBFOR"
// 小能客服SiteID
#define     XNSiteID                @"md_1000"
// 小能客服KEY
#define     XNKey                   @"B3124B43-8F9B-4A93-A0A2-5160797EC8BF"

#endif /* AppChangeHeader_h */
