//
//  MyOrderModel.m
//  FanweO2O
//
//  Created by hym on 2017/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderStoreItem



@end

@implementation DealOrderItem

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"list":@"MyOrderStoreItem"
             };
}


@end

@implementation MyOrderParam



@end

@implementation MyOrderOperation



@end

@implementation MyOrderItemModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"deal_order_item":@"DealOrderItem",
             
             @"operation":@"MyOrderOperation"
             };
}


@end

@implementation MyOrderPage



@end


@implementation MyOrderBaseModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"item":@"MyOrderItemModel"
             };
}

@end
