//
//  MyThirdSectionTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyThirdSectionTableViewCell.h"
#import "MyAddrVC.h"
#import "ConsumptionCouponsViewController.h"
#import "PreferentialViewController.h"
#import "MyCollectVC.h"
#import "ActivityViewController.h"
#import "GlobalVariables.h"
@interface MyThirdSectionTableViewCell ()<ButtonCustomDelegate>
{
    GlobalVariables * fanweApp;
    NSMutableArray *nameArray;
    NSArray *imageArray;
}
@end
@implementation MyThirdSectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        fanweApp = [GlobalVariables sharedInstance];
        nameArray =[NSMutableArray arrayWithObjects:@"红包",@"消费券",@"优惠券",@"活动券",@"我的抽奖",@"积分商城",@"分享有礼",@"我的收藏",@"收货地址",@"我的评价", nil];
        imageArray =[NSArray arrayWithObjects:@"my_redenvelope",@"my_vouchers",@"my_ coupons",@"my_activityCoupons",@"my_luckyDraw",@"my_IntegralMall",@"my_sharePpolite",@"my_collection",@"my_shippingAddress",@"my_evaluationGreen", nil];
        
        for (int i=0 ; i<10; i++) {
            CGFloat space =(kScreenW  -75*5)/4;
            ButtonCustom *btn =[[ButtonCustom alloc] initWithFrame:CGRectMake(i%5*(space+75), i/5*(61), 75, 61) imageIcon:imageArray[i] titleText:nameArray[i] angelNumber:nil ];
            [self.contentView addSubview:btn];
        }
    }
    return self;
}
- (void)setModel:(MyCenterModel *)model
{
    _model =model;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[ButtonCustom class]]) {
            [view removeFromSuperview];
        }
    }
    if (fanweApp.needCustomUI)
    {
        nameArray =[NSMutableArray arrayWithObjects:@"红包",@"消费券",@"优惠券",@"活动券",@"积分商城",@"分享有礼",@"我的收藏",@"收货地址",@"我的评价", nil];
       imageArray =[NSArray arrayWithObjects:@"my_redenvelope",@"my_vouchers",@"my_ coupons",@"my_activityCoupons",@"my_IntegralMall",@"my_sharePpolite",@"my_collection",@"my_shippingAddress",@"my_evaluationGreen", nil];
        if ([model.user_login_status isEqualToString:@"1"]) {
            _numberArray =[NSArray arrayWithObjects:model.New_ecv,model.New_coupon,model.New_youhui,model.New_event,@"",@"",@"",@"",@"", nil];
        }else
        {
            _numberArray =[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
        }
    }
    else
    {
        nameArray =[NSMutableArray arrayWithObjects:@"红包",@"消费券",@"优惠券",@"活动券",@"我的抽奖",@"积分商城",@"分享有礼",@"我的收藏",@"收货地址",@"我的评价", nil];
        imageArray =[NSArray arrayWithObjects:@"my_redenvelope",@"my_vouchers",@"my_ coupons",@"my_activityCoupons",@"my_luckyDraw",@"my_IntegralMall",@"my_sharePpolite",@"my_collection",@"my_shippingAddress",@"my_evaluationGreen", nil];
        if ([model.user_login_status isEqualToString:@"1"]) {
            _numberArray =[NSArray arrayWithObjects:model.New_ecv,model.New_coupon,model.New_youhui,model.New_event,@"",@"",@"",@"",@"",@"", nil];
        }else
        {
            _numberArray =[NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
        }
    }
    
    if (model.coupon_name !=nil) {
       [nameArray replaceObjectAtIndex:1 withObject:model.coupon_name];
    }
    
    for (int i=0 ; i<nameArray.count; i++) {
        CGFloat space =(kScreenW  -75*5)/4;
        ButtonCustom *btn =[[ButtonCustom alloc] initWithFrame:CGRectMake(i%5*(space+75), i/5*(61), 75, 61) imageIcon:imageArray[i] titleText:nameArray[i] angelNumber:_numberArray[i] ];
        btn.Tag =i+5555;
        btn.delegate =self;
        [self.contentView addSubview:btn];
    }
}

- (void)buttonCustonToNext:(NSInteger)number
{
    if (fanweApp.needCustomUI)
    {
        if (number -5555 ==4) {
            
            
            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=scores_index",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }else
        {
            if ([_model.user_login_status isEqualToString:@"1"]) {
                switch (number-5555) {
                    case 0:
                    {
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_ecv",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                        
                        
                    }
                        break;
                    case 1:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_coupon",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else{
                            ConsumptionCouponsViewController *vc =[ConsumptionCouponsViewController new];
                            [[AppDelegate sharedAppDelegate]pushViewController:vc];
                        }
                        
                    }
                        break;
                        
                    case 2:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_youhui",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                        }else{
                            [[AppDelegate sharedAppDelegate]pushViewController:[PreferentialViewController new]];
                        }
                        
                        
                    }
                        break;
                    case 3:
                    {
                        
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_event",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else {
                            [[AppDelegate sharedAppDelegate]pushViewController:[ActivityViewController new]];
                        }
                    }
                        break;
                     
                        
                    case 5:
                    {
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_share",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                    }
                        break;
                    case 6:
                    {
                        
                        
                        if (kOlderVersion<=2) {
                            
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_collect",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else {
                            [[AppDelegate sharedAppDelegate]pushViewController:[[MyCollectVC alloc]initWithNibName:@"MyCollectVC" bundle:nil]];
                        }
                        
                        
                        
                    }
                        break;
                    case 7:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_address",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else{
                            [[AppDelegate sharedAppDelegate]pushViewController:[[MyAddrVC alloc]initWithNibName:@"MyAddrVC" bundle:nil]];
                        }
                        break;
                    }
                        break;
                    case 8:
                    {
                        
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_review",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(loginView1)]) {
                    [_delegate loginView1];
                }
            }
        }
    }
    else
    {
        if (number -5555 ==5) {
            
            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=scores_index",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }else
        {
            if ([_model.user_login_status isEqualToString:@"1"]) {
                switch (number-5555) {
                    case 0:
                    {
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_ecv",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                        
                        
                    }
                        break;
                    case 1:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_coupon",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else{
                            ConsumptionCouponsViewController *vc =[ConsumptionCouponsViewController new];
                            [[AppDelegate sharedAppDelegate]pushViewController:vc];
                        }
                        
                    }
                        break;
                        
                    case 2:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_youhui",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                        }else{
                            [[AppDelegate sharedAppDelegate]pushViewController:[PreferentialViewController new]];
                        }
                        
                        
                    }
                        break;
                    case 3:
                    {
                        
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_event",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else {
                            [[AppDelegate sharedAppDelegate]pushViewController:[ActivityViewController new]];
                        }
                    }
                        break;
                    case 4:
                    {
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_lottery",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                    }
                        break;
                        
                    case 6:
                    {
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_share",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                    }
                        break;
                    case 7:
                    {
                        
                        
                        if (kOlderVersion<=2) {
                            
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_collect",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else {
                            [[AppDelegate sharedAppDelegate]pushViewController:[[MyCollectVC alloc]initWithNibName:@"MyCollectVC" bundle:nil]];
                        }
                        
                        
                        
                    }
                        break;
                    case 8:
                    {
                        if (kOlderVersion<=2) {
                            
                            
                            
                            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_address",
                                                  API_LOTTERYOUT_URL];
                            jumpModel.url =urlString;
                            jumpModel.type = 0;
                            jumpModel.isHideNavBar = YES;
                            jumpModel.isHideTabBar = YES;
                            [FWO2OJump didSelect:jumpModel];
                            
                        }else{
                            [[AppDelegate sharedAppDelegate]pushViewController:[[MyAddrVC alloc]initWithNibName:@"MyAddrVC" bundle:nil]];
                        }
                        break;
                    }
                        break;
                    case 9:
                    {
                        
                        
                        
                        
                        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_review",
                                              API_LOTTERYOUT_URL];
                        jumpModel.url =urlString;
                        jumpModel.type = 0;
                        jumpModel.isHideNavBar = YES;
                        jumpModel.isHideTabBar = YES;
                        [FWO2OJump didSelect:jumpModel];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(loginView1)]) {
                    [_delegate loginView1];
                }
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
