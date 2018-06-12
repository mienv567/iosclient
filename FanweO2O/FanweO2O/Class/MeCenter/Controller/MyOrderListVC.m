//
//  MyOrderListVC.m
//  FanweO2O
//  我的订单
//  Created by hym on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderListVC.h"
#import "TYTabButtonPagerController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
@interface MyOrderListVC ()<TYPagerControllerDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate>{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}

@property (nonatomic, strong) TYTabButtonPagerController *pagerVC;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation MyOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.httpManager =[NetHttpsManager manager];
    self.titlesArray = @[@"全部",@"待付款",@"待发货",@"待确认",@"待评价"];
    [self bulidNav];
    TYTabButtonPagerController *pagerVC = [TYTabButtonPagerController new];
    [self.view addSubview:pagerVC.view];
    
    [pagerVC.view  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    pagerVC.dataSource = self;
    //pagerVC.adjustStatusBarHeight = YES;
    pagerVC.barStyle = TYPagerBarStyleProgressView;
    //pagerVC.progressWidth = SCREEN_WIDTH/5;
    
    pagerVC.cellSpacing = 0;
    pagerVC.normalTextColor = kAppFontColorLightGray;
    pagerVC.selectedTextColor = kAppFontColorComblack;
    pagerVC.normalTextFont = [UIFont systemFontOfSize:13];
    pagerVC.selectedTextFont = [UIFont systemFontOfSize:13];
    pagerVC.animateDuration = 0;
    pagerVC.progressRadius = 0;
    [pagerVC reloadData];
    [pagerVC moveToControllerAtIndex:_orderType animated:NO];
    
    self.pagerVC = pagerVC;
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"我的订单";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    self.title =@"";
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
     self.title =@"";
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return 5;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    MyOrderListTBVC *vc = [MyOrderListTBVC new];
    
    vc.orderType = index;
    
    //[vc.view setBackgroundColor:kRandomFlatColor];
    
    return vc;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.titlesArray[index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)goBack
{
    if (_isComingOrderDetails ==YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
   
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
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.pagerVC.curIndex],@"index", nil];
    NSNotification * notice = [NSNotification notificationWithName:@"MyOrderRefresh" object:nil userInfo:dict];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
  
   
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



@end
