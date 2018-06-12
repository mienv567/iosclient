//
//  RefundDetailsContentModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundDetailsContentModel : NSObject
@property (nonatomic,strong)NSString *content;      //退款原因
@property (nonatomic,strong)NSString *create_time;  //退款时间
@property (nonatomic,strong)NSString *deal_icon;    //图片
@property (nonatomic,strong)NSString *deal_id;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *is_coupon;  //1:有劵码
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,strong)NSString *name;         //商品名字
@property (nonatomic,strong)NSString *number;       //商品数量
@property (nonatomic,strong)NSString *password;    //劵码
@property (nonatomic,strong)NSString *refund_info; //退款信息
@property (nonatomic,strong)NSString *refund_money; //退款金额
@property (nonatomic,strong)NSString *rs2;      //1申请退款中；2退款成功； 3:拒绝退款
@property (nonatomic,strong)NSString *sid1;
@property (nonatomic,strong)NSString *supplier_name; //店家
@property (nonatomic,strong)NSString *total_price;   //总价格
@property (nonatomic,strong)NSString *unit_price;    //单价
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *admin_memo;  //备注

@end
