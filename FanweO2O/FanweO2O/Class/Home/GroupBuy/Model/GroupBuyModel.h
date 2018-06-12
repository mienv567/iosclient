//
//  GroupBuyModel.h
//  FanweO2O
//
//  Created by hym on 2017/1/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomGoodsModel.h"
@interface GroupBuyDeal : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger buyin_app;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *f_icon;

@property (nonatomic, assign) NSInteger allow_promote;

@property (nonatomic, copy) NSString *location_dp_xpoint;

@property (nonatomic, assign) NSInteger location_avg_point;

@property (nonatomic, copy) NSString *area_name;

@property (nonatomic, copy) NSString *sub_name;

@property (nonatomic, assign) NSInteger origin_price;

@property (nonatomic, copy) NSString *open_store_payment;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger bfb;

@property (nonatomic, assign) NSInteger ypoint;

@property (nonatomic, copy) NSString *end_time_format;

@property (nonatomic, copy) NSString *location_name;

@property (nonatomic, assign) NSInteger is_today;

@property (nonatomic, copy) NSString *f_icon_v1;

@property (nonatomic, assign) NSInteger deal_score;

@property (nonatomic, copy) NSString *location_dp_ypoint;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon_v1;

@property (nonatomic, copy) NSString *is_lottery;

@property (nonatomic, assign) NSInteger location_id;

@property (nonatomic, assign) NSInteger xpoint;

@property (nonatomic, copy) NSString *buy_count;

@property (nonatomic, copy) NSString *location_address;

@property (nonatomic, copy) NSString *auto_order;

@property (nonatomic, copy) NSString *location_dp_count;

@property (nonatomic, copy) NSString *is_verify;

@property (nonatomic, copy) NSString *begin_time_format;

@property (nonatomic, copy) NSString *supplier_id;

@property (nonatomic, assign) NSInteger current_price;

@property (nonatomic, copy) NSString *share_url;

@property (nonatomic, copy) NSString *brief;

@property (nonatomic, copy) NSString *begin_time;

@property (nonatomic, copy) NSString *is_refund;

@property (nonatomic, copy) NSString *app_url;

@end

@interface GroupBuyModel : NSObject

@property (nonatomic, copy) NSString *location_dp_count;

@property (nonatomic, copy) NSString *location_name;

@property (nonatomic, assign) double distance;

@property (nonatomic, strong) NSArray *deal;

@property (nonatomic, copy) NSString *area_name;

@property (nonatomic, assign) NSInteger location_id;

@property (nonatomic, assign) NSInteger bfb;

@property (nonatomic, assign) float avg_point;

@property (nonatomic, assign) Boolean hsExpanded;

@end
