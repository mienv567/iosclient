//
//  StoreListModel.h
//  FanweO2O
//
//  Created by hym on 2017/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreListModel : NSObject

@property (nonatomic, copy) NSString *app_url;

@property (nonatomic, copy) NSString *preview;

@property (nonatomic, copy) NSString *quan_name;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) CGFloat avg_point;

@property (nonatomic, assign) NSInteger ypoint;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger format_point;

@property (nonatomic, copy) NSString *store_type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger xpoint;

@property (nonatomic, copy) NSString *preview_v1;

@property (nonatomic, copy) NSString *preview_v2;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *is_verify;

@property (nonatomic, copy) NSString *supplier_id;

@property (nonatomic, copy) NSString *deal_cate_id;

@property (nonatomic, copy) NSString *open_store_payment;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *promote_info;

@property (nonatomic, copy) NSString *promote_url;

@end
