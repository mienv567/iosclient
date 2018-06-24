//
//  GlobalVariables.h
//  FanweApp
//
//  Created by mac on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.

#import <Foundation/Foundation.h>
#import "AppModel.h"
#import "O2OConfigModel.h"

@interface GlobalVariables : NSObject

@property (nonatomic, copy) NSString *user_id;        //用户id
@property (nonatomic, copy) NSString *user_name;      //用户名
@property (nonatomic, copy) NSString *user_money;      //用户钱
@property (nonatomic, copy) NSString *user_pwd;       //用户密码
@property (nonatomic, copy) NSString *user_avatar;    //用户头像
@property (nonatomic, copy) NSString *user_email;     //用户邮箱
@property (nonatomic, copy) NSString *user_mobile;    //用户手机号
@property (nonatomic, copy) NSString *session_id;     //session_id
@property (nonatomic, assign) BOOL needCustomUI;      //是否审核
@property (nonatomic, assign) BOOL forcedUpgrade;     //是否强制升级
@property (nonatomic, assign) BOOL needUpgrade;       //是否强制升级
@property (nonatomic, copy) NSString *ios_upgrade;    //更新内容
@property (nonatomic, copy) NSString *ios_down_url;   //下载地址
@property (nonatomic, strong) AppModel      *appModel;
@property (nonatomic, copy) NSString        *deviceToken;           //设备id
@property (nonatomic, assign) double        latitude;               //用户当前位置纬度
@property (nonatomic, assign) double        longitude;              //用户当前位置经度

@property (nonatomic, assign) NSInteger     city_id;                //指定的城市ID

@property (nonatomic, copy) NSString        *city_name;             //指定城市名称

@property (nonatomic, copy) NSString        *city;                  //定位出的位置

@property (nonatomic, copy) NSString        *province;              //定位出来的省

@property (nonatomic, copy) NSString        *area;                  //定位出来的行政区

@property (nonatomic, copy) NSString        *locateName;            //定位出来的具体地址

@property (nonatomic, assign) Boolean       is_refresh_tableview;  //城市发生改变数据刷新

@property (nonatomic, strong) O2OConfigModel *O2OConfig;

@property (nonatomic, assign) BOOL          is_login;               //是否登录
@property (nonatomic, copy) NSString          *is_fx;                 //App 0未开通分销 1开通分销

@property (nonatomic, copy) NSString          *vouchersName;          //消费券名字

+ (GlobalVariables *)sharedInstance;

- (void)startLocation;

@end
