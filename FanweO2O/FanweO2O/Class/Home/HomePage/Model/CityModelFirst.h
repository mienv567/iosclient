//
//  CityModelFirst.h
//  FanweO2O
//
//  Created by ycp on 16/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModelSecond.h"

@interface CityModelFirst : NSObject

@property (strong, nonatomic) NSArray *hot_city;


@end

@interface CityBaseModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger is_open;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *zm;

@end

@interface CityValueModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSMutableArray *coent;

@property (nonatomic, assign) CGFloat hight;           //行高

@end
