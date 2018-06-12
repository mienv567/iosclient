//
//  EvaluateModel.h
//  FanweO2O
//
//  Created by hym on 2017/3/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *is_coupon;

@property (nonatomic, copy) NSString *deal_icon;

@property (nonatomic, copy) NSString *deal_id;

@property (nonatomic, copy) NSString *is_shop;

@property (nonatomic, copy) NSString *sub_name;

@property (nonatomic, copy) NSString *is_arrival;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *consume_count;

@property (nonatomic, copy) NSString *dp_id;

@property (nonatomic, copy) NSString *delivery_status;

@property (nonatomic, copy) NSString *name;


@property (nonatomic, assign) NSInteger sartRank;       //级别
@property (nonatomic, strong) NSString *strContent;     //内容

@end
