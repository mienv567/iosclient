//
//  RefundShopModel.h
//  FanweO2O
//
//  Created by hym on 2017/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundShopModel : NSObject
@property (nonatomic, assign) NSInteger dp_id;

@property (nonatomic, copy) NSString *deal_orders;

@property (nonatomic, copy) NSString *deal_icon;

@property (nonatomic, copy) NSString *sub_name;

@property (nonatomic, copy) NSString *attr_str;

@property (nonatomic, copy) NSString *is_shop;

@property (nonatomic, assign) NSInteger delivery_status;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *buy_type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *is_pick;

@property (nonatomic, assign) NSInteger consume_count;

@property (nonatomic, assign) NSInteger total_price;

@property (nonatomic, assign) NSInteger unit_price;

@property (nonatomic, assign) NSInteger is_refund;

@property (nonatomic, assign) NSInteger supplier_id;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *deal_id;

@property (nonatomic, assign) NSInteger refund_status;

@property (nonatomic, assign) NSInteger is_arrival;

@property (nonatomic, copy) NSString *coupon_id;

@property (nonatomic, assign) BOOL hsSelect;

@end
