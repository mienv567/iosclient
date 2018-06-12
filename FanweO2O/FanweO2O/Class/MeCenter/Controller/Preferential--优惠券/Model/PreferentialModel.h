//
//  PreferentialModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferentialModel : NSObject
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *youhui_id;
@property (nonatomic,strong)NSString *youhui_sn; //劵码
@property (nonatomic,strong)NSString *expire_time;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *yName;
@property (nonatomic,strong)NSString *youhui_type;
@property (nonatomic,strong)NSString *youhui_value;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *qrcode;
@property (nonatomic,strong)NSString *value;
@end
