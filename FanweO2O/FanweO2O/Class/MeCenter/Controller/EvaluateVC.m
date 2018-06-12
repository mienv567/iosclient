//
//  EvaluateVC.m
//  FanweO2O
//  订单评论
//  Created by hym on 2017/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EvaluateVC.h"

#import "EvaluateModel.h"

#import "EvaluateView.h"

#import "NSMutableDictionary+Json.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
@interface EvaluateVC ()<SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NetHttpsManager *httpManager;

@property (nonatomic, strong) GlobalVariables *fanweApp;

@property (nonatomic, strong) NSMutableArray *evaluateArray;


@end

@implementation EvaluateVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _httpManager = [NetHttpsManager manager];
    _fanweApp = [GlobalVariables sharedInstance];
    _evaluateArray = [NSMutableArray new];
    UIScrollView *scrollView = [UIScrollView new];
    
    [scrollView setBackgroundColor:RGB(53, 53, 53)];
    
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        make.top.equalTo(self.view.mas_top).with.offset(0);
    }];
    
    UIView *view = [UIView new];
    [view setBackgroundColor:RGB(53, 53, 53)];
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.top.equalTo(scrollView.mas_bottom).with.offset(0);
    }];
    
    UIButton *btn = [UIButton new];
    
    [btn setBackgroundColor:RGB(255, 34, 28)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn setTitle:@"发表评价" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 4.0;
    [view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(76, 26));
        make.centerY.equalTo(view).with.offset(0);
        make.right.equalTo(view.mas_right).with.offset(-10);
    }];

    [self updateNewData];
    [self bulidNav];

}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"发表评价";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)updateNewData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"order_dp" forKey:@"act"];
    [parameters setValue:self.orderId forKey:@"id"];
    
    __weak EvaluateVC *weekSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        //[responseJson[@"item"][0] createPropertyCode]
        weekSelf.evaluateArray = [EvaluateModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        [weekSelf doHandler];

        
    } FailureBlock:^(NSError *error) {
        
        
    }];
    
}

- (void)doHandler {
    CGFloat height = 0;
    for (EvaluateModel *model in self.evaluateArray) {
        
        EvaluateView *view = [EvaluateView appView];
        //UIView *view = [UIView new];
        view.model = model;
        [view setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.view.mas_top).with.offset(64);
            make.height.mas_offset(150);
        }];
        
        height = height + 150;
        
    }
}

- (void)onClick {
    
    
    NSString *item_id = @"";
    NSMutableDictionary *dicContent = [NSMutableDictionary new];
    NSMutableDictionary *dicPoint = [NSMutableDictionary new];
    for (EvaluateModel *model in self.evaluateArray) {
        
        if (model.strContent.length > 0 || model.sartRank > 0) {
            if (model.strContent.length > 0) {
                if (model.sartRank == 0) {
                    [[HUDHelper sharedInstance] tipMessage:@"请选择评分"];
                    return;
                }
                
                if (item_id.length != 0) {
                    item_id = [item_id stringByAppendingString:@","];
                }
                item_id = [item_id stringByAppendingString:model.id];
                [dicContent setObject:model.strContent forKey:model.id];
                [dicPoint setObject:@(model.sartRank) forKey:model.id];
            }else if (model.sartRank > 0 ) {
                if (model.strContent.length == 0) {
                    [[HUDHelper sharedInstance] tipMessage:@"请填写评价内容"];
                    return;
                }
                
                if (item_id.length != 0) {
                    item_id = [item_id stringByAppendingString:@","];
                }
                item_id = [item_id stringByAppendingString:model.id];
                [dicContent setObject:model.strContent forKey:model.id];
                [dicPoint setObject:@(model.sartRank) forKey:model.id];
            }
        }else  {
            [[HUDHelper sharedInstance] tipMessage:@"请填写评价内容"];
            return;
        }
        
    
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"order_dp_do" forKey:@"act"];
    [parameters setValue:item_id forKey:@"item_id"];
    [parameters setValue:[dicContent convertToJSONString] forKey:@"content"];
    [parameters setValue:[dicPoint convertToJSONString] forKey:@"point"];
    [parameters setValue:self.orderId forKey:@"order_id"];
    
    //NSLog(@"%@",[dicContent convertToJSONString]);
    __weak EvaluateVC *weekSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"responseJson = %@",responseJson);
        NSLog(@"info = %@",responseJson[@"info"]);
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
        
        if ([responseJson toInt:@"status"] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_EVALUATE_ORDER
                                                                object:nil
                                                              userInfo:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weekSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        
        //[responseJson[@"item"][0] createPropertyCode];
        
        //weekSelf.evaluateArray = [EvaluateModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        //[weekSelf doHandler];
        //weekSelf.myOrderModel = [MyOrderDetailsModel mj_objectWithKeyValues:responseJson[@"item"]];
        //weekSelf.storeInfoSection = weekSelf.myOrderModel.deal_order_item.count;
        
        //[weekSelf createButtonView];
        //[weekSelf.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
       
    }];

}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popNewView
{
    [self.view bringSubviewToFront:pop];
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.1f options:UIViewAnimationOptionLayoutSubviews animations:^{
                pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180, 40, 40);
            } completion:nil];
        });
    }];
}

- (void)noReadMessage
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"countNotRead" forKey:@"act"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            pop.no_msg =[responseJson[@"count"] integerValue];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma make PopViewDelegate
-(void)back
{
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =0.0;
        pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180-80, 40, 40);
    }];
}
- (void)toRefresh
{
    
    [self back];
    [self updateNewData];
}
- (void)selectButton:(NSInteger)count
{
    NSNumber *number = [NSNumber numberWithInteger:count];
    [self back];
    [self performSelector:@selector(performButtonClick:) withObject:number afterDelay:0.5];
}

- (void)performButtonClick:(NSNumber *)number
{
    NSInteger count =[number integerValue];
    switch (count) {
        case 0:
        {
            self.tabBarController.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
            
            [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
            
        }
            break;
        case 3:
        {
            ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
        case 4:
        {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
            
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
