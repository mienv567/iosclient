//
//  O2OConfigModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;
@interface O2OConfigModel : NSObject


@property (nonatomic, copy) NSString *program_title;

@property (nonatomic, copy) NSString *ctl;

@property (nonatomic, copy) NSString *qq_app_secret;

@property (nonatomic, copy) NSString *wx_app_secret;

@property (nonatomic, assign) NSInteger api_sina;

@property (nonatomic, copy) NSString *app_url_white_list_cfg;

@property (nonatomic, assign) NSInteger only_one_delivery;

@property (nonatomic, copy) NSString *sina_bind_url;

@property (nonatomic, assign) NSInteger menu_user_charge;

@property (nonatomic, assign) NSInteger version;

@property (nonatomic, copy) NSString *sina_app_key;

@property (nonatomic, assign) NSInteger about_info;

@property (nonatomic, copy) NSString *act;

@property (nonatomic, copy) NSString *qq_app_key;

@property (nonatomic, copy) NSString *kf_phone;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *kf_email;

@property (nonatomic, assign) NSInteger region_version;

@property (nonatomic, copy) NSString *sina_app_secret;

@property (nonatomic, copy) NSString *sess_id;

@property (nonatomic, assign) NSInteger api_qq;

@property (nonatomic, copy) NSString *wx_app_key;

@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, copy) NSString *city_id;

@property (nonatomic, assign) NSInteger api_wx;

@property (nonatomic, assign) NSInteger is_store_pay;

@property (nonatomic, copy) NSString *index_logo;

@property (nonatomic, assign) NSInteger menu_user_withdraw;

@property (nonatomic, strong) NSArray *citylist;

@property (nonatomic, assign) NSInteger is_open_distribution;

@property (nonatomic, copy) NSString *is_fx;

@property (nonatomic, copy) NSString *serverVersion;        //版本号

@property (nonatomic, copy) NSString *ios_forced_upgrade;   //是否强制升级 1-是 0-否

@property (nonatomic, copy) NSString *is_ios_upgrading;     //是否审核中 1-是 0-否

@property(nonatomic,copy) NSString *ios_upgrade;    //更新内容

@property(nonatomic,copy) NSString *ios_down_url;   //下载地址

@end

/******
 
 备注：  1、如果审核中： 根据本地版本号与服务端版本号一样，如果相等则显示审核配置；
        2、如果审核中： 根据本地版本号与服务端版本号不一样 则不是审核状态，根据是否强制升级提示更新内
        3、如果不是审核中：根据是否强制更新提示更新信息
 *****/


@interface City : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *py;


@end
