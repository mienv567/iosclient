//
//  AppModel.h
//  ZCTest
//
//  Created by mac on 16/2/17.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"
#import "AppUrlModel.h"

@interface AppModel : NSObject

@property (nonatomic,copy) NSString         *site_url;              //程序主链接
@property (assign,nonatomic) NSInteger      sina_app_api;
@property (assign,nonatomic) NSInteger      qq_app_api;
@property (assign,nonatomic) NSInteger      wx_app_api;
@property (assign,nonatomic) NSInteger      statusbar_hide;         //0:显示状态栏;1隐藏状态栏
@property (nonatomic, copy) NSString        *statusbar_color;       //状态栏颜色
@property (nonatomic, copy) NSString        *topnav_color;          //导航栏颜色
@property (assign,nonatomic) NSInteger      ad_open;            //点击广告内容打开方式：0:在第一个webveiw中打开;1:新建一个webview打开连接
@property (nonatomic, assign) NSInteger     reload_time;        //重新加载程序时间
@property (nonatomic, assign) NSInteger     monitor_second;     //主播心跳监听，每隔monitor_second秒监听一次;监听数据：时间点，印票数，房间人数
@property (nonatomic, assign) NSInteger     bullet_screen_diamond; //弹幕一次消费的金币
@property (nonatomic, assign) NSInteger     jr_user_level;      //加入房间时,如果用户等级超过或等于jr_user_level时，有用户进入房间提醒操作

@property (nonatomic, strong) VersionModel  *version;
@property (nonatomic, assign) NSInteger     has_qq_login;       //是否可以qq登录
@property (nonatomic, assign) NSInteger     has_sina_login;     //是否可以新浪登录
@property (nonatomic, assign) NSInteger     has_wx_login;       //是否可以微信登录
@property (nonatomic, assign) NSInteger     has_mobile_login;    //是否可以手机登录
@property (nonatomic, copy) NSString        *agreement_link;    //协议链接
@property (nonatomic, copy) NSString        *privacy_link;      //privacy链接
@property (nonatomic, copy) NSString        *city ;             //服务器地址名
@property (nonatomic, copy) NSDictionary    *ip_info;           //服务器地址名

@property (nonatomic, copy) NSString        *short_name ;       // app称呼
@property (nonatomic, copy) NSString        *ticket_name ;      // app票据的称呼
@property (nonatomic, copy) NSString        *account_name ;     // app账号的称呼

@property (nonatomic, assign) float         beauty_ios;         // IOS美颜度，默认值
@property (nonatomic, assign) NSInteger     beauty_close;       // 客户端是否允许自义美颜度 0:开; 1:关; 当beauty_close=1时,美颜功能只有 开/关；美颜值直接取：服务端返回的值
@property (nonatomic, copy) NSString        *app_name;          // app名称  方维直播
@property (nonatomic, assign) NSInteger     has_save_video;     // 保存视频（可用于回播）

@property (nonatomic, copy) NSString        *spear_live ;       // 主播
@property (nonatomic, copy) NSString        *spear_normal ;     // 观众
@property (nonatomic, copy) NSString        *spear_interact ;   // 连麦

@property (nonatomic, copy) NSString        *region_versions ;  //版本的存储

@property (nonatomic, assign) NSInteger     auto_login;         //1:自动创建帐户登陆;苹果审核跟云测试时使用

@property (nonatomic, strong) NSMutableArray *api_link;         // 服务端下传的动态链接地址
@property (nonatomic, strong) AppUrlModel   *h5_url;            // app用到的h5链接地址

@property (nonatomic, copy) NSString        *ios_check_version; // 苹果审核版本号
@property (nonatomic, assign) NSInteger     has_dirty_words;    // 是否支持脏字库 1：支持 0：不支持

//支持什么竞拍
@property (nonatomic, copy) NSString        *pai_real_btn;
@property (nonatomic, copy) NSString        *pai_virtual_btn;

@property (nonatomic, copy) NSString        *open_family_module;
@property (nonatomic, copy) NSString        *open_ranking_list; //是否打开总排行榜

@property (nonatomic, assign) NSInteger     open_upgrade_prompt;//是否开启每日登录升级提示
@property (nonatomic, assign) NSInteger     new_level;          //是否解锁飞屏
@property (nonatomic, copy) NSString        *first_login;        //是否是每日首次登录
@property (nonatomic, copy) NSString        *login_send_score;  //登陆赠送积分值;

@property (nonatomic,copy) NSString *version_time;      //版本号时间用于审核

@end
