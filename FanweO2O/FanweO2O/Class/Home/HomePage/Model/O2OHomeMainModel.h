//
//  O2OHomeMainModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeadLineModel.h"
#import "BannerModel.h"
#import "MallIndexModel.h"
#import "RecommendModel.h"
#import "CustomGoodsModel.h"
//"return": 1,
//"read_msg": 0,
//"city_id": "15",
//"city_name": "福州",

@interface O2OHomeMainModel : NSObject

@property (nonatomic, assign) NSInteger returns;
@property (nonatomic, assign) NSInteger not_read_msg;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, strong) NSMutableArray *article;
@property (nonatomic, assign) NSInteger is_banner_square;
@property (nonatomic, strong) NSMutableArray *advs;
@property (nonatomic, strong) NSMutableArray *advs2;
@property (nonatomic, strong) MallIndexMainModel *indexs;
@property (nonatomic, strong) NSMutableArray *supplier_list;
@property (nonatomic, strong) NSMutableArray *deal_list;


@property (nonatomic, copy) NSString *zt_html3;
@property (nonatomic, copy) NSString *zt_html4;
@property (nonatomic, copy) NSString *zt_html5;
@property (nonatomic, copy) NSString *zt_html6;



@end
