//
//  ConsumptionModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ConsumptionModel : NSObject
@property (nonatomic,strong)NSString *deal_id;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *order_id;
@property (nonatomic,strong)NSString *coupon_end_time;
@property (nonatomic,strong)NSString *count; //二维码个数
@property (nonatomic,strong)NSString *end_time;
@property (nonatomic,strong)NSString *begin_time;
@property (nonatomic,strong)NSArray *coupon;
@property (nonatomic,assign)BOOL open;

@property (nonatomic,strong)NSString *order_sn;
@property (nonatomic,strong)NSString *supplier_name;
@property (nonatomic,strong)NSString *is_valid;
@property (nonatomic,strong)NSString *all_number;
@end


@interface CouponCount : NSObject
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *password; //券码
@property (nonatomic,strong)NSString *end_time;
@property (nonatomic,strong)NSString *confirm_time;
@property (nonatomic,strong)NSString *is_new;
@property (nonatomic,strong)NSString *begin_time;
@property (nonatomic,strong)NSString *is_valid;
@property (nonatomic,strong)NSString *refund_status;
@property (nonatomic,strong)NSString *qrcode; //二维码
@property (nonatomic,strong)NSString *status; //1:可使用，0：不可使用
@property (nonatomic,strong)NSString *info; //状态说明
@end
