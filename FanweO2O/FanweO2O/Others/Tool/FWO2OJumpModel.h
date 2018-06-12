//
//  FWO2OJumpModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWO2OJumpModel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *data_id; //订单详情传的id
@property (nonatomic, assign) Boolean isHideNavBar;       //是否显示导航栏
@property (nonatomic, assign) Boolean isHideTabBar;       //是否显示底部菜单栏
@end
