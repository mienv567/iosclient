//
//  ConsumptionCouponsViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionCouponsViewController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "TYTabButtonPagerController.h"
#import "TYPagerController.h"
#import "ConsumptionContentViewController.h"
#import "ConsumptionMeselfLiftViewController.h"
#import "QrCodeView.h"
#import "ConsumptionPickUpGoodsViewController.h"
@interface ConsumptionCouponsViewController ()<SecondaryNavigationBarViewDelegate,PopViewDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,ConsumptionContentViewControllerDelegate,QrCodeViewDelegate,ConsumptionMeselfLiftViewControllerDelegate,ConsumptionPickUpGoodsViewControllerDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
    QrCodeView *qrView;
}

@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, strong) TYTabButtonPagerController *pagerVC;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic,strong)NetHttpsManager *httpManager;
@end

@implementation ConsumptionCouponsViewController
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
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =_fanweApp.vouchersName;
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha=0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _fanweApp =[GlobalVariables sharedInstance];
    if (_fanweApp.O2OConfig.is_open_distribution ==1) {
        self.titlesArray = @[@"团购",@"自提",@"取货"];
    }else
    {
        self.titlesArray = @[@"团购",@"自提"];
    }
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self bulidNav];
    [self bulidSliderView];
    [self qrCode];
    
   
}
- (UIView *)qrCode
{
    qrView =[QrCodeView EditNibFromXib];
    qrView.frame =CGRectMake(0,0, kScreenW, kScreenH);
    qrView.alpha =0;
    qrView.delegate =self;
    [self.view bringSubviewToFront:qrView];
    [self.view addSubview:qrView];
    return qrView;
}
- (void)bulidSliderView
{
    TYTabButtonPagerController *pagerVC = [TYTabButtonPagerController new];
    
    pagerVC.dataSource = self;
//    pagerVC.adjustStatusBarHeight = YES;
    pagerVC.barStyle = TYPagerBarStyleProgressElasticView;
    pagerVC.progressWidth =40;
    pagerVC.cellSpacing = 8;
    pagerVC.selectedTextColor = [UIColor blackColor];
    pagerVC.normalTextFont = [UIFont systemFontOfSize:13];
    pagerVC.selectedTextFont = [UIFont systemFontOfSize:13];
    pagerVC.animateDuration = 0;
    pagerVC.progressRadius = 0;
    pagerVC.view.frame =CGRectMake(0, 64, kScreenW, kScreenH-64);
    [pagerVC reloadData];
    [pagerVC moveToControllerAtIndex:_couponType animated:NO];
    [self.view addSubview:pagerVC.view];
     self.pagerVC = pagerVC;
    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 40-1, kScreenW, 1)];
    lineView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    [pagerVC.view addSubview:lineView];
}
#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return  self.titlesArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    ConsumptionContentViewController *vc = [ConsumptionContentViewController new];
    vc.order_id = self.orderId;
    vc.delegate =self;
    ConsumptionMeselfLiftViewController *lvc =[ConsumptionMeselfLiftViewController new];
    lvc.order_id = self.orderId;
    lvc.delegate =self;
    ConsumptionPickUpGoodsViewController *cvc =[ConsumptionPickUpGoodsViewController new];
    cvc.delegate =self;
    cvc.order_id=self.orderId;
    if (index ==0) {
        return vc;
    }
    if (index ==1) {
        return lvc;
    }
    if (_fanweApp.O2OConfig.is_open_distribution ==1) {
        if (index ==2) {
            return cvc;
        }
    }
    return nil;
}
- (void)qrCodeView:(NSString *)password andQrcode:(NSString *)qrcode
{
    qrView.qrCodeNumber.text =[NSString stringWithFormat:@"劵码: %@",password];
    [qrView.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcode]];
    [UIView animateWithDuration:0.5 animations:^{
        qrView.alpha =1;
    }];
}
- (void)goBackToView
{
    [UIView animateWithDuration:0.5 animations:^{
        qrView.alpha =0;
    }];
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.titlesArray[index];
}
- (void)goBack
{
    
    [[[AppDelegate sharedAppDelegate] navigationViewController] popViewControllerAnimated:YES];
}
- (void)popNewView
{
    [self.view bringSubviewToFront:pop];
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha=1;
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
    if (self.orderId) {
        [dic setObject:self.orderId forKey:@"data_id"];
    }
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
         pop.alpha=0.0;
        pop.closeButton.frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180-80, 40, 40);
    }];
}
- (void)toRefresh
{
    [self back];
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.pagerVC.curIndex],@"index", nil];
    NSNotification * notice = [NSNotification notificationWithName:@"Refresh" object:nil userInfo:dict];
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Refresh" object:nil];
}
@end
