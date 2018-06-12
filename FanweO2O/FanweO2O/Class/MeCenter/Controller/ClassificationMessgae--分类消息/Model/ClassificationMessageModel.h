//
//  ClassificationMessageModel.h
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppType;

@interface ClassificationMessageModel : NSObject
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *data_id;
@property (nonatomic,strong)NSString *wap_link;
@property (nonatomic,strong)AppType *app;
@end
@interface AppType : NSObject
@property (nonatomic,strong)NSString *type;
@end
