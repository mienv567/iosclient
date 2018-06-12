//
//  MyOrderListTBVC.h
//  FanweO2O
//
//  Created by hym on 2017/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyOrderType) {
    MyOrderAll = 0,                 //全部
    MyOrderWaitPayment = 1,         //待付款
    MyOrderWaitDispatch = 2,        //待发货
    MyOrderWaitAffirm = 3,          //待确认
    MyOrderWaitEvaluate = 4,        //待评价
    
};

@interface MyOrderListTBVC : UIViewController

@property (nonatomic, assign) MyOrderType orderType;

@end
