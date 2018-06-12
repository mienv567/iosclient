//
//  XNTextMessage.h
//  XNChatCore
//
//  Created by Ntalker on 15/9/8.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//  文本消息

#import "XNBaseMessage.h"

#define kFontSize 12

@interface XNTextMessage : XNBaseMessage

@property (nonatomic, strong) NSString *textMsg;
@property (nonatomic, assign) NSUInteger fontSize;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL underLine;

//机器人进留言
@property (nonatomic, strong) NSString *systype;
//转人工链接 渲染
@property (nonatomic, strong) NSMutableArray *clickTextArray;
//是否是机器人转接链接
@property (nonatomic, assign) BOOL isRobotLink;
//机器人反问引导
@property (nonatomic, assign) BOOL isRobotAsklink;
//******link********
@property (nonatomic, strong) NSString *onlyOneUrl;//唯一连接URL
@property (nonatomic, strong) NSString *linkTitle;//链接标题
@property (nonatomic, strong) NSString *linkImageUrl;//链接图片
@property (nonatomic, strong) NSString *linkdescription;//链接描述
@property (nonatomic, strong) NSString *linkUrl;//链接url(返回)
@property (nonatomic, assign) int subtype;//用于判断链接所处位置


+ (XNTextMessage *)textMessageWithMsgTime:(long long)msgTime
                                andUserid:(NSString *)userid
                              andUserInfo:(NSString *)userInfo
                               andMsgInfo:(NSString *)msgInfo;

+ (NSString *)XMLStrFromTextMessage:(XNTextMessage *)textMessage;

@end
