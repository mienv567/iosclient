//
//  ClassSectionDataModel.m
//  FanweO2O
//
//  Created by hym on 2017/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassSectionDataModel.h"

@implementation ClassBcate_type



@end

@implementation ClassBcate_list

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"bcate_type":@"ClassBcate_type",
             
             };
}


@end

@implementation ClassQuan_sub



@end

@implementation ClassQuan_list

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"quan_sub":@"ClassQuan_sub",
             
             };
}

@end

@implementation ClassNavs



@end

@implementation ClassBrand_list



@end

@implementation ClassSectionDataModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             
             @"quan_list":@"ClassQuan_list",
             @"bcate_list":@"ClassBcate_list",
             @"navs":@"ClassNavs",
             @"brand_list":@"ClassBrand_list"
             
             };
}

@end
