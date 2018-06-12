//
//  MyOrderDetailsModel.h
//  FanweO2O
//
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyOrderModel.h"

@interface MyOrderDetailsStoreItem : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger total_price;

@property (nonatomic, copy) NSString *buy_type;

@property (nonatomic, assign) NSInteger supplier_id;

@property (nonatomic, copy) NSString *deal_orders;

@property (nonatomic, copy) NSString *deal_icon;

@property (nonatomic, copy) NSString *deal_id;

@property (nonatomic, assign) NSInteger unit_price;

@property (nonatomic, copy) NSString *sub_name;

@property (nonatomic, assign) NSInteger is_arrival;

@property (nonatomic, copy) NSString *attr_str;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, assign) NSInteger consume_count;

@property (nonatomic, assign) NSInteger dp_id;

@property (nonatomic, assign) NSInteger delivery_status;

@property (nonatomic, copy) NSString *app_format_unit_price;

@property (nonatomic, assign) NSInteger is_refund;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger refund_status;

@end

@interface DealOrderDetailsItem : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, copy) NSString *supplier_name;

@end

@interface MyOrderDetailsFeeinfo : NSObject

@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) NSInteger symbol;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger buy_type;

@end

@interface MyOrderDetailsDeliveryinfo : NSObject

@property (nonatomic, copy) NSString *weight_id;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *first_fee;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *first_weight;

@property (nonatomic, copy) NSString *is_effect;

@property (nonatomic, copy) NSString *allow_default;

@property (nonatomic, copy) NSString *continue_fee;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *continue_weight;

@end

@interface MyOrderPayment_infoModel : NSObject

@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *payment_config;
@property (nonatomic, copy) NSString *name;

@end

@interface MyOrderDetailsModel : NSObject

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *fact_return_total_score;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger order_total_price;

@property (nonatomic, copy) NSString *app_format_youhui_price;

@property (nonatomic, strong) NSArray *operation;

@property (nonatomic, assign) NSInteger record_delivery_fee;

@property (nonatomic, strong) NSArray *feeinfo;

@property (nonatomic, assign) NSInteger is_del;

@property (nonatomic, copy) NSString *pay_status;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, assign) NSInteger payment_fee;

@property (nonatomic, copy) NSString *is_coupon;

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, copy) NSString *is_cancel;

@property (nonatomic, assign) NSInteger ecv_money;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, strong) NSArray *deal_order_item;

@property (nonatomic, copy) NSString *app_format_order_total_price;

@property (nonatomic, copy) NSString *delivery_id;

@property (nonatomic, strong) NSArray *paid;

@property (nonatomic, assign) NSInteger youhui_price;

@property (nonatomic, copy) NSString *app_format_order_pay_price;

@property (nonatomic, assign) NSInteger discount_price;

@property (nonatomic, copy) NSString *app_format_pay_amount;

@property (nonatomic, copy) NSString * location_id;

@property (nonatomic, copy) NSString *location_address_url;

@property (nonatomic, copy) NSString *location_name;

@property (nonatomic, copy) NSString *location_address;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) NSInteger pay_amount;

@property (nonatomic, assign) NSInteger order_pay_price;

@property (nonatomic, assign) NSInteger deal_total_price;

@property (nonatomic, assign) NSInteger is_check_logistics;

@property (nonatomic, copy) NSString *status_name;

@property (nonatomic, assign) NSInteger is_groupbuy_or_pick;

@property (nonatomic, copy) NSString *app_format_total_price;

@property (nonatomic, assign) NSInteger delivery_fee;

@property (nonatomic, assign) NSInteger total_price;

@property (nonatomic, assign) NSInteger is_dp;

@property (nonatomic, assign) NSInteger buy_type;

@property (nonatomic, copy) NSString *memo;     //订单备注

@property (nonatomic, copy) NSString *delivery_status;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger is_refund;

@property (nonatomic, strong) MyOrderDetailsDeliveryinfo *delivery_info;

@property (nonatomic, assign) NSInteger existence_expire_refund;

@property (nonatomic, strong) MyOrderPayment_infoModel *payment_info;



@end
