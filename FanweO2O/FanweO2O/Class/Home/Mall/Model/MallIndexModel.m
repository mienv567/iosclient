//
//  MallIndexModel.m
//  FanweO2O
//
//  Created by hym on 2016/12/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MallIndexModel.h"

@implementation MallIndexModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"recommend_deal_cate":@"BottomModel"};
}
@end


@implementation MallIndexMainModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list":@"MallIndexModel"};
}

@end


@implementation BottomModel

@end
