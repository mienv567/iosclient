//
//  MySectionTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MySectionTableViewCell.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "RefundListViewController.h"
#import "MyOrderListVC.h"
#import "PayListViewController.h"
#import "MyOrderListVC.h"
@interface MySectionTableViewCell ()<ButtonCustomDelegate>

@end

@implementation MySectionTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelName =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 39)];
        self.labelName.font =KAppTextFont13;
        self.labelName.text =@"我的订单";
        self.labelName.textColor =KAppMainTextBackColor;
        [self.contentView addSubview:_labelName];
        self.allOrderButton =[UIButton buttonWithType:UIButtonTypeCustom];
        self.allOrderButton.frame =CGRectMake(kScreenW-106, 0, 96, 39);
        [self.allOrderButton setTitle:@"查看全部订单" forState:UIControlStateNormal];
        [self.allOrderButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        self.allOrderButton.titleLabel.font =KAppTextFont13;
        [self.allOrderButton setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
        [self.allOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [self.allOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
         [self.contentView addSubview:_allOrderButton];
        UIButton *orderButton =[UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame =CGRectMake(0, 0, kScreenW, 40);
        orderButton.backgroundColor =[UIColor clearColor];
        [orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:orderButton];
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(10, 39, kScreenW-10, 1)];
        view.backgroundColor =kWhiteGatyGroundColor;
        [self.contentView addSubview:view];

        NSArray *array =[NSArray arrayWithObjects:@"待付款",@"待确认",@"待评价",@"退款",@"买单", nil];
        NSArray *imageArray =[NSArray arrayWithObjects:@"my_payment",@"my_guardian",@"my_evaluation",@"my_ refund",@"my_ pay", nil];

        for (int i =0; i<5; i++) {
            CGFloat space =(kScreenW  -75*5)/4;
            ButtonCustom *viewButton =[[ButtonCustom alloc] initWithFrame:CGRectMake(i*(space+75), CGRectGetMaxY(view.frame), 75, 61) imageIcon:imageArray[i] titleText:array[i] angelNumber:nil ];
            viewButton.Tag =i +1000;
            [self.contentView addSubview:viewButton];
        }
        
        
    }
    return  self;
}

- (void)setModel:(MyCenterModel *)model
{
    _model =model;
    
    NSArray *array =[NSArray arrayWithObjects:@"待付款",@"待确认",@"待评价",@"退款",@"买单", nil];
    NSArray *imageArray =[NSArray arrayWithObjects:@"my_payment",@"my_guardian",@"my_evaluation",@"my_ refund",@"my_ pay", nil];
    if ([model.user_login_status isEqualToString:@"1"]) {
       _numberArray=[NSArray arrayWithObjects:model.not_pay_order_count,model.wait_confirm,model.wait_dp_count,@"",@"",nil];
    }else{
        _numberArray =[NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    }
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[ButtonCustom class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i =0; i<5; i++) {
        CGFloat space =(kScreenW  -75*5)/4;
        ButtonCustom *viewButton =[[ButtonCustom alloc] initWithFrame:CGRectMake(i*(space+75), 40, 75, 61) imageIcon:imageArray[i] titleText:array[i] angelNumber:_numberArray[i] ];
        viewButton.Tag =i+1000;
        viewButton.delegate =self;
        [self.contentView addSubview:viewButton];
    }
    
}

//我的订单按钮
- (void)orderButtonClick
{
    if ([_model.user_login_status isEqualToString:@"1"]) {
        if (kOlderVersion == 2) {
            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_order",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }else {
            MyOrderListVC *vc = [MyOrderListVC new];
            
            [[AppDelegate sharedAppDelegate] pushViewController:vc];
        }

    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(nextToLogin)]) {
            [_delegate nextToLogin];

        }
    }
}
- (void)buttonCustonToNext:(NSInteger)number
{
    if ([_model.user_login_status isEqualToString:@"1"]) {
      
        switch (number-1000) {
            case 0:
            {
                if (kOlderVersion<=2) {
                    
    
                    
                    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_order&pay_status=1",
                                          API_LOTTERYOUT_URL];
                    jumpModel.url =urlString;
                    jumpModel.type = 0;
                    
                    jumpModel.isHideNavBar = YES;
                    jumpModel.isHideTabBar = YES;
                    [FWO2OJump didSelect:jumpModel];
                }else {
                    MyOrderListVC *vc = [MyOrderListVC new];
                    vc.orderType = MyOrderWaitPayment;
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                }
            }
                break;
            case 1:
            {
                
                if (kOlderVersion<=2) {
                    
                    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_order&pay_status=3",
                                          API_LOTTERYOUT_URL];
                    jumpModel.url = urlString;
                    jumpModel.type = 0;
                    jumpModel.isHideNavBar = YES;
                    jumpModel.isHideTabBar = YES;
                    [FWO2OJump didSelect:jumpModel];
                }else {
                    MyOrderListVC *vc = [MyOrderListVC new];
                    vc.orderType = MyOrderWaitAffirm;
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                }
                
            }
                break;
             
            case 2:
            {
                
                if (kOlderVersion<=2) {
                    
    
                    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_order&pay_status=4",
                                          API_LOTTERYOUT_URL];
                    jumpModel.url = urlString;
                    jumpModel.type = 0;
                    jumpModel.isHideNavBar = YES;
                    jumpModel.isHideTabBar = YES;
                    [FWO2OJump didSelect:jumpModel];
                    
                }else {
                    
                    MyOrderListVC *vc = [MyOrderListVC new];
                    vc.orderType = MyOrderWaitEvaluate;
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                    
                }
                
            }
                break;
            case 3:
            {
                if (kOlderVersion <= 2) {
                    
                    
                    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_order&act=refund_list",
                                          API_LOTTERYOUT_URL];
                    jumpModel.url =urlString;
                    jumpModel.type = 0;
                    jumpModel.isHideNavBar = YES;
                    jumpModel.isHideTabBar = YES;
                    [FWO2OJump didSelect:jumpModel];
                    
                }else{
                    [[AppDelegate sharedAppDelegate]pushViewController:[RefundListViewController new]];
                }
                
            }
                break;
            case 4:
            {
                
                if (kOlderVersion <= 2) {
                    
                FWO2OJumpModel *jumpModel = [FWO2OJumpModel new];
                NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_store_pay_order",
                                      API_LOTTERYOUT_URL];
                jumpModel.url =urlString;
                jumpModel.type = 0;
                jumpModel.isHideNavBar = YES;
                jumpModel.isHideTabBar = YES;
                [FWO2OJump didSelect:jumpModel];
                  }else {
                     [[AppDelegate sharedAppDelegate]pushViewController:[PayListViewController new]];
                  }
                
            }
                break;
                
            default:
                break;
        }
        
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(nextToLogin)]) {
            [_delegate nextToLogin];
            
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
