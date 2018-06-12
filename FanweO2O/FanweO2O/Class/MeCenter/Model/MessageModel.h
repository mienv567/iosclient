//
//  MessageModel.h
//  FanweO2O
//
//  Created by ycp on 17/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Info;
@interface MessageModel : NSObject
@property (nonatomic,strong)Info *account; //资产消息
@property (nonatomic,strong)Info *confirm; //验证消息
@property (nonatomic,strong)Info *delivery; //物流消息
@property (nonatomic,strong)Info *notify; //通知消息
@end

@interface Info : NSObject
@property (nonatomic,copy)NSString *content; //最新一条消息内容
@property (nonatomic,copy)NSString *create_time; //最新一条消息时间
@property (nonatomic,copy)NSString *title; //最新一条消息标题
@property (nonatomic,copy)NSString *unread; //未读消息数量
@end
