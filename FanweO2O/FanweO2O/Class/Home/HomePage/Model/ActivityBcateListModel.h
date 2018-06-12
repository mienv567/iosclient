//
//  ActivityBcateListModel.h
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityBcateListModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@end


@interface ActivityItem : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *submit_begin_time_format;

@property (nonatomic, copy) NSString *submit_count;     //已经报名人数

@property (nonatomic, assign) NSInteger xpoint;

@property (nonatomic, assign) NSInteger ypoint;

@property (nonatomic, copy) NSString *submit_end_time_format;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger out_time;       //1-超时

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *supplier_info_name;

@property (nonatomic, copy) NSString *sheng_time_format;

@property (nonatomic, copy) NSString *district;

@property (nonatomic, assign) NSInteger is_over;        //1-结束

@property (nonatomic, assign) double distance;

@property (nonatomic, copy) NSString *total_count;      //最大报名人数

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *supplier_info_preview;

@end
