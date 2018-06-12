//
//  BindingModel.h
//  FanweO2O
//
//  Created by ycp on 17/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindingModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *user_name;
@property (nonatomic,copy)NSString *user_pwd;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *is_tmp;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *user_login_status;
@property (nonatomic,copy)NSString *is_luck;

@end
