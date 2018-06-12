//
//  RefundListModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundListModel : NSObject
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,strong)NSString *supplier_name;
@property (nonatomic,strong)NSString *deal_icon;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *unit_price;
@property (nonatomic,strong)NSString *refund_money;

@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *refund_status;
@property (nonatomic,strong)NSString *status_str;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *attr_str;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *refund_info;
@property (nonatomic,strong)NSString *deal_id;

@end
