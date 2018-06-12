//
//  FWO2OJump.h
//  FanweO2O
//
//  Created by hym on 2016/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FWO2OJumpModel;

@interface FWO2OJump : NSObject

+ (void)didSelect:(FWO2OJumpModel *)jump;

+ (void)myOrderHandler:(NSString *)strType orderId:(NSString *)orderId couponType:(NSInteger )couponType;

//+ (void)XNChatViewController:()

@end
