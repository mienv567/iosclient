//
//  FanweMessage.h
//  FanweApp
//
//  Created by mac on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FanweMessage : NSObject

/**
 *  系统自带的消息提示框
 *  @param str 提示框显示内容
 */
+ (void)alert:(NSString *) message;

/**
 *  HUD的消息
 *  @param str 提示框显示内容
 */
+ (void)alertHUD:(NSString *) message;

@end
