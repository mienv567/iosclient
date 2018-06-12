//
//  CustomGoodsModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomGoodsModel : NSObject
@property (nonatomic, copy) NSString *f_icon;
@property (nonatomic, copy) NSString *sub_name;
@property (nonatomic, copy) NSString *buy_count;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat current_price;
@property (nonatomic, assign) CGFloat origin_price;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *app_url;
@property (nonatomic, copy) NSString *supplier_name;
@property (nonatomic, copy) NSString *distance;
@end
