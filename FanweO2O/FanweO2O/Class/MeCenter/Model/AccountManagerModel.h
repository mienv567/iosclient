//
//  AccountManagerModel.h
//  FanweO2O
//
//  Created by ycp on 17/1/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Content;
@class CurrdisInfo;

@interface AccountManagerModel : NSObject

@property (nonatomic,strong)Content *user_info;
//@property (nonatomic,copy)NSString *key;
@property (nonatomic,strong)NSArray *level_info;
@property (nonatomic,strong)NSArray *group_info;
@property (nonatomic,strong)CurrdisInfo *currdis;
@property (nonatomic,assign)int ghighest;
@property (nonatomic,assign)int phighest;
@end

@interface UserInfo : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *score;
@property (nonatomic,copy)NSString *discount;
@property (nonatomic,copy)NSString *point;

@end

@interface Content : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *user_name;
@property (nonatomic,copy)NSString *total_score;
@property (nonatomic,copy)NSString *point;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *user_avatar;
@property (nonatomic,copy)NSString *user_pwd;
@property (nonatomic,copy)NSString *is_tmp;  //1.为改名字 0.不能改

@end
@interface CurrdisInfo : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *score;
@property (nonatomic,copy)NSString *discount;
@end
