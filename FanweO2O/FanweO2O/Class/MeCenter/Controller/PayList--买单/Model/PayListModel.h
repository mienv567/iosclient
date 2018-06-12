//
//  PayListModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayListModel : NSObject
/*
location_name	string	商户名称
status	string	订单状态描述
total_price	float	消费金额
discount_price	float	优惠金额
pay_amount	float	实付金额
create_time	string	买单时间
 */
@property (nonatomic,strong)NSString *location_name;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *total_price;
@property (nonatomic,strong)NSString *discount_price;
@property (nonatomic,strong)NSString *pay_amount;
@property (nonatomic,strong)NSString *create_time;
@end
