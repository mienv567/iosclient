//
//  MyCenterModel.m
//  FanweO2O
//
//  Created by ycp on 17/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyCenterModel.h"

@implementation MyCenterModel
/*
 @property (nonatomic,copy)NSString *New_coupon; //新发放给用户消费券数
 @property (nonatomic,copy)NSString *New_youhui; //新发放给用户优惠券数
 @property (nonatomic,copy)NSString *New_ecv; //新增红包数
 @property (nonatomic,copy)NSString *New_event;//新增活动券数
 */
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"New_coupon":@"new_coupon",
             @"New_youhui":@"new_youhui",
             @"New_ecv":@"new_ecv",
             @"New_event":@"new_event"};
}
@end
