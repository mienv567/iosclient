//
//  RefundApplicationModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundApplicationModel : NSObject
@property (nonatomic,copy)NSString *supplier_name;
@property (nonatomic,copy)NSArray *list;
@end

@interface MainContent : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *deal_icon;
@property (nonatomic,copy)NSString *attr_str;
@property (nonatomic,copy)NSString *unit_price;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *app_format_unit_price;
@end
