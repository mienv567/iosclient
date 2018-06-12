//
//  O2OHomeMainModel.m
//  FanweO2O
//
//  Created by hym on 2016/12/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "O2OHomeMainModel.h"

@implementation O2OHomeMainModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"article":@"HeadLineModel",
             @"advs":@"BannerModel",
             @"advs2":@"BannerModel",
             @"supplier_list":@"RecommendModel",
             @"deal_list":@"CustomGoodsModel",
             };
}
@end
