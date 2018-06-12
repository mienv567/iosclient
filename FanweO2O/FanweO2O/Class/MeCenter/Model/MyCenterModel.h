//
//  MyCenterModel.h
//  FanweO2O
//
//  Created by ycp on 17/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCenterModel : NSObject
/*
 "is_fx":"1",
 "uid":"120",
 "user_name":"游客_120",
 "not_read_msg":"4",
 "user_group":"普通会员",
 "user_money":"",
 "user_score":100,
 "user_avatar":"https://o2owap.fanwe.net/public/avatar/noavatar_big.gif",
 "user_mobile_empty":0,
 "new_ecv":"",
 "new_youhui":"",
 "new_coupon":"",
 "new_event":"",
 "not_pay_order_count":"",
 "wait_confirm":"",
 "wait_dp_count":"",
 "page_title":"方维O2O - 会员中心",
 "user_login_status":1,
 "ctl":"user_center",
 "act":"wap_index",
 "status":1,
 "info":"",
 "city_name":"福州",
 "return":1,
 "sess_id":"ium9ggku329f0d1bq43e2dtnc3",
 "ref_uid":null
 */

@property (nonatomic,copy)NSString *user_login_status; //0表示未登录 1表示已登录 2表示临时登录
@property (nonatomic,copy)NSString *uid;  //会员id
@property (nonatomic,copy)NSString *user_name; //会员名
@property (nonatomic,copy)NSString *user_money; //会员账户余额
@property (nonatomic,copy)NSString *user_group; //会员等级
@property (nonatomic,copy)NSString *user_score; //会员积分
@property (nonatomic,copy)NSString *user_mobile_empty; //0:已绑定手机 1未绑定手机
@property (nonatomic,copy)NSString *user_avatar; //会员头像图路径
@property (nonatomic,copy)NSString *not_read_msg; //未读消息数

@property (nonatomic,copy)NSString *New_coupon; //新发放给用户消费券数
@property (nonatomic,copy)NSString *New_youhui; //新发放给用户优惠券数
@property (nonatomic,copy)NSString *New_ecv; //新增红包数
@property (nonatomic,copy)NSString *New_event;//新增活动券数

//我的订单
@property (nonatomic,copy)NSString *wait_dp_count; //待点评的条数
@property (nonatomic,copy)NSString *not_pay_order_count; //未付款的订单数
@property (nonatomic,copy)NSString *wait_confirm; //待确认订单数
@property (nonatomic,copy)NSString *coupon_name; //券名


@property (nonatomic,copy)NSString *is_user_fx; //用户 0未开通分销 1开通分销

@end
