//
//  FWO2OJump.m
//  FanweO2O
//
//  Created by hym on 2016/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "MallViewController.h"
#import "GroupBuyTBVC.h"
#import "MyWebViewController.h"
#import "O2OWebController.h"
#import "InteractiveWebController.h"
#import "GroupBuyListVC.h"
#import "FavorableListVC.h"
#import "ActivityListVC.h"
#import "MallListVC.h"
#import "StoreListVC.h"
#import "EvaluateVC.h"
#import "ConsumptionCouponsViewController.h"
#import "SelectRefundShopVC.h"
#import "AccountManagementViewController.h"
#import "PreferentialViewController.h"
#import "ConsumptionCouponsViewController.h"
#import "MyOrderDetailsVC.h"
#import "SRAlertView.h"
@implementation FWO2OJump


/*************************************************
 
 url地址: 这个是直接打开浏览器的地址
 type = 0
 
 首页
 type = 1
 
 团购列表
 type = 11
 
 商品列表
 type = 12
 
 优惠卷列表
 type = 15
 
 活动列表
 type = 14
 
 门店列表
 type = 26
 
 商城首页
 type = 102
 
 团购首页
 type = 103
 
 会员中心
 type = 107
 
 账户管理
 type = 201
 
 我的积分
 type = 202
 
 优惠券
 type = 203
 
 分享有礼
 type = 204
 
 红包
 type = 206
 
 消费券
 type = 207
 
 资金明细
 type = 301
 
 订单详情
 type = 302
 
 分销收益统计
 type = 303
 
 提现明细
 type = 304
 
 评价
 type = 310
 
 
 *************************************************/

+ (void)didSelect:(FWO2OJumpModel *)jump {
    
    if (jump.type == 0) {
        
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:jump.url andNavTitle:jump.name isShowIndicator:YES isHideNavBar:jump.isHideNavBar isHideTabBar:jump.isHideTabBar];
        
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];

        
      
    }else if (jump.type == 1 ){
        
        UIViewController *owner = [[AppDelegate sharedAppDelegate] topViewController];
        owner.tabBarController.selectedIndex = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [owner.navigationController popToRootViewControllerAnimated:NO];
        });
    }
    else if (jump.type == 102) {
        
        MallViewController *vc = [MallViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 103) {
        
        GroupBuyTBVC *vc = [[GroupBuyTBVC alloc] init];
        
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 11) {
        
        GroupBuyListVC *vc = [GroupBuyListVC new];
        vc.haselect = YES;
        vc.selectpid = [jump.data_id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 12) {
        
        MallListVC *vc = [MallListVC new];
        vc.haselect = YES;
        vc.selectpid = [jump.data_id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 14) {
        
        ActivityListVC *vc = [ActivityListVC new];
        
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 15) {
        
        FavorableListVC *vc = [FavorableListVC new];
        vc.kind = 1;
        vc.haselect = YES;
        vc.selectpid = [jump.data_id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 26) {
        
        StoreListVC *vc = [StoreListVC new];
        vc.haselect = YES;
        vc.selectpid = [jump.data_id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type == 107 ){
        
        UIViewController *owner = [[AppDelegate sharedAppDelegate] topViewController];
        owner.tabBarController.selectedIndex = 3;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [owner.navigationController popToRootViewControllerAnimated:NO];
        });
    }else if (jump.type ==201){
        
        AccountManagementViewController *vc =[AccountManagementViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type ==202){
        
        
 

        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_score",
                                                            API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"我的积分" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if (jump.type ==203){
        
        PreferentialViewController *vc =[PreferentialViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type ==204){
        
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_share",
                              API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"分享有礼" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }
    else if (jump.type ==206){
        
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_ecv",
                              API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"我的红包" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if (jump.type ==207){
        
        ConsumptionCouponsViewController *vc =[ConsumptionCouponsViewController new];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if (jump.type ==301){
        
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_money&act=money_log",
                              API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"资金明细" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }
    else if (jump.type ==303){
        
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_fx&act=income",
                              API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"收益统计" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if (jump.type ==304){
        
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_money&act=withdraw_log",
                              API_LOTTERYOUT_URL];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"提现明细" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if (jump.type == 308 || jump.type == 302) {
        UIViewController *ower = [[AppDelegate sharedAppDelegate] topViewController];
        BOOL hsFind = NO;
        for (UIViewController *vc in ower.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MyOrderDetailsVC class]]) {
                
                hsFind = YES;
                
                MyOrderDetailsVC *order = (MyOrderDetailsVC *)vc;
                if ([order.data_id isEqualToString:jump.data_id]) {
                    [[[AppDelegate sharedAppDelegate] navigationViewController] popToViewController:vc animated:YES];
                }else {
                    
                    MyOrderDetailsVC *vc = [MyOrderDetailsVC new];
                    vc.data_id =jump.data_id;
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                }
                
            }
        }
        
        if (!hsFind) {
            
            MyOrderDetailsVC *vc =[MyOrderDetailsVC new];
            vc.data_id =jump.data_id;
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
            
            
            
        }
        if ([ower isKindOfClass:[InteractiveWebController class]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ower.navigationController removeChild:ower animation:^{
                    
                }];
            });
        }

    }else if (jump.type == 310) {
        EvaluateVC *vc = [EvaluateVC new];
        vc.orderId = jump.data_id;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }else {
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:jump.url andNavTitle:jump.name isShowIndicator:YES isHideNavBar:jump.isHideNavBar isHideTabBar:jump.isHideTabBar];
        
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }

}

+ (void)myOrderHandler:(NSString *)strType orderId:(NSString *)orderId couponType:(NSInteger )couponType{
    if ([strType isEqualToString:@"j-dp"]) {
        //评价
        EvaluateVC *vc = [EvaluateVC new];
        vc.orderId = orderId;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if ([strType isEqualToString:@"j-logistics|goodsreceipt"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_order&act=logistics&data_id=%@",
                              API_LOTTERYOUT_URL,orderId];
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if ([strType isEqualToString:@"j-coupon"]) {
        //查看消费券
        ConsumptionCouponsViewController *vc = [ConsumptionCouponsViewController new];
        vc.orderId = orderId;
        vc.couponType = couponType;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if ([strType isEqualToString:@"j-refund"]) {
        //退款
        SelectRefundShopVC *vc = [[SelectRefundShopVC alloc ] initWithNibName:@"SelectRefundShopVC" bundle:nil];
        vc.orderId = orderId;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
        
    }else if ([strType isEqualToString:@"j-payment"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=cart&act=pay&id=%@",
                              API_LOTTERYOUT_URL,orderId];
    
        InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
        
    }else if ([strType isEqualToString:@"j-del"]) {
        
        //删除订单
        
        [SRAlertView sr_showAlertViewWithTitle:@"温馨提示"
                                       message:@"确定要删除该订单"
                               leftActionTitle:@"取消"
                              rightActionTitle:@"确定"
                                animationStyle:AlertViewAnimationZoom
                                  selectAction:^(AlertViewActionType actionType) {
                                      if (actionType == AlertViewActionTypeRight) {
                                          UIViewController *owner = [[AppDelegate sharedAppDelegate] topViewController];
                                          ShowIndicatorTextInView(owner.view,@"");
                                          NSMutableDictionary *parameters = [NSMutableDictionary new];
                                          [parameters setValue:@"uc_order" forKey:@"ctl"];
                                          [parameters setValue:@"cancel" forKey:@"act"];
                                          [parameters setValue:orderId forKey:@"id"];
                                          //"/wap/index.php?ctl=uc_order&act=cancel&id=470",
                                          
                                          [[NetHttpsManager manager] POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
                                              
                                              HideIndicatorInView(owner.view);
                                              //NSLog(@"%@",responseJson);
                                              if ([[responseJson objectForKey:@"status"] integerValue] == 1) {
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_REFRESH_ORDER
                                                                                                      object:@"删除订单"
                                                                                                    userInfo:nil];
                                              }else {
                                                  [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                                            
                                              }
                                              
                                              
                                              
                                          } FailureBlock:^(NSError *error) {
                                              HideIndicatorInView(owner.view);
                                              [[HUDHelper sharedInstance] tipMessage:@"网络异常，请重试"];
                                          }];
                                          
                                          
                                      }
                                      
                                      NSLog(@"%zd", actionType);
                                  }];

    }else if ([strType isEqualToString:@"j-cancel"]) {
        //取消订单
        [SRAlertView sr_showAlertViewWithTitle:@"温馨提示"
                                       message:@"确定要取消该订单"
                               leftActionTitle:@"取消"
                              rightActionTitle:@"确定"
                                animationStyle:AlertViewAnimationZoom
                                  selectAction:^(AlertViewActionType actionType) {
                                      if (actionType == AlertViewActionTypeRight) {
                                          UIViewController *owner = [[AppDelegate sharedAppDelegate] topViewController];
                                          ShowIndicatorTextInView(owner.view,@"");
                                          NSMutableDictionary *parameters = [NSMutableDictionary new];
                                          [parameters setValue:@"uc_order" forKey:@"ctl"];
                                          [parameters setValue:@"cancel" forKey:@"act"];
                                          [parameters setValue:orderId forKey:@"id"];
                                          [parameters setValue:@"1" forKey:@"is_cancel"];
                                          //"/wap/index.php?ctl=uc_order&act=cancel&id=460&is_cancel=1"
                                          [[NetHttpsManager manager] POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
                                              
                                              HideIndicatorInView(owner.view);
                                              
                                              if ([[responseJson objectForKey:@"status"] integerValue] == 1) {
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_REFRESH_ORDER
                                                                                                      object:nil
                                                                                                    userInfo:nil];
                                              }else {
                                                  [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                                              }

                                              
                                          } FailureBlock:^(NSError *error) {
                                            HideIndicatorInView(owner.view);
                                            [[HUDHelper sharedInstance] tipMessage:@"网络异常，请重试"];
                                          }];

                                          
                                      }
                                      
                                      NSLog(@"%zd", actionType);
                                  }];
    }
    
    
    
}

@end
