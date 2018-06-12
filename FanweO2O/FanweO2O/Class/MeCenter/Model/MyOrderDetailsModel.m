//
//  MyOrderDetailsModel.m
//  FanweO2O
//
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsModel.h"

@implementation MyOrderDetailsStoreItem


@end

@implementation DealOrderDetailsItem

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"list":@"MyOrderDetailsStoreItem"
             };
}

@end

@implementation MyOrderDetailsFeeinfo



@end

@implementation MyOrderDetailsDeliveryinfo

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"Description":@"description",
            
             };
}

@end

@implementation MyOrderPayment_infoModel



@end

@implementation MyOrderDetailsModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"deal_order_item":@"DealOrderDetailsItem",
             
             @"operation":@"MyOrderOperation",
             
             @"feeinfo":@"MyOrderDetailsFeeinfo",
             
             @"paid":@"MyOrderDetailsFeeinfo",
             
             
             };
}

@end
