//
//  MyOrderModel.h
//  FanweO2O
//
//  Created by hym on 2017/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderStoreItem : NSObject

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

@property (nonatomic, assign) NSInteger is_refund;

@property (nonatomic, assign) NSInteger refund_status;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *app_format_unit_price;

@end

@interface DealOrderItem : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, copy) NSString *supplier_name;

@property (nonatomic, copy) NSString *status_name;

@end

@interface MyOrderParam : NSObject

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, assign) NSInteger coupon_status;

@end

@interface MyOrderOperation : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) MyOrderParam *param;

@end

@interface MyOrderItemModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, copy) NSString *pay_status;

@property (nonatomic, assign) NSInteger total_price;

@property (nonatomic, assign) NSInteger buy_type;

@property (nonatomic, copy) NSString *is_coupon;

@property (nonatomic, assign) NSInteger is_groupbuy_or_pick;

@property (nonatomic, assign) NSInteger pay_amount;

@property (nonatomic, strong) NSArray *deal_order_item;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger is_dp;

@property (nonatomic, assign) NSInteger is_del;

@property (nonatomic, copy) NSString *app_format_total_price;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, copy) NSString *is_delete;

@property (nonatomic, assign) NSInteger is_check_logistics;

@property (nonatomic, copy) NSString *delivery_status;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *status_name;

@property (nonatomic, strong) NSArray *operation;       //行为按钮

@end


@interface MyOrderPage : NSObject

@property (nonatomic, assign) NSInteger page_total;

@property (nonatomic, assign) NSInteger page_size;

@property (nonatomic, copy) NSString *data_total;

@property (nonatomic, assign) NSInteger page;

@end


@interface MyOrderBaseModel : NSObject

@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, assign) NSInteger pay_status;

@property (nonatomic, copy) NSString *sess_id;

@property (nonatomic, assign) NSInteger user_login_status;

@property (nonatomic, strong) NSArray *item;

@property (nonatomic, copy) NSString *page_title;

@property (nonatomic, copy) NSString *not_pay;

@property (nonatomic, strong) MyOrderPage *page;

@property (nonatomic, copy) NSString *ctl;

@property (nonatomic, copy) NSString *act;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@end

