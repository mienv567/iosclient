//
//  SelectRefundShopVC.m
//  FanweO2O
//  选择退款商品
//  Created by hym on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SelectRefundShopVC.h"
#import "RefundShopModel.h"
#import "SelectRefundShopTBCell.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "MyCenterViewController.h"
#import "RefundApplicationViewController.h"
@interface SelectRefundShopVC ()<UITableViewDelegate,UITableViewDataSource,SelectRefundShopTBCellDelegate,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, assign) BOOL hsSelectAll;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectAll;

@end

@implementation SelectRefundShopVC
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
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kBackGroundColor;
    self.dataArray = [NSMutableArray new];
    
    _httpManager = [NetHttpsManager manager];
    _fanweApp = [GlobalVariables sharedInstance];
    [self bulidNav];
    [self upDateNewRequest];
    
    
    
    
}
- (void)upDateNewRequest{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"order_refund" forKey:@"act"];
    [parameters setValue:self.orderId forKey:@"data_id"];
    
    __weak SelectRefundShopVC *weekSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSArray *array = responseJson[@"item"][@"deal_order_item"];
        
        NSDictionary *dic = [array firstObject];
        
        weekSelf.dataArray = [RefundShopModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        
        [weekSelf.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"选择退款商品";
    nav.isTitleOrSearch =YES;
    [self.topView addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    SelectRefundShopTBCell *cell = [SelectRefundShopTBCell cellWithTbaleview:tableView];
    RefundShopModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.orderItem = model;
    cell.delegate = self;
    if (indexPath.row + 1 == self.dataArray.count) {
        cell.line.hidden = YES;
    }else {
        cell.line.hidden = NO;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    
    return view;
}

- (void)refreshTableView:(RefundShopModel *)orderItem {
    
    BOOL hsSelectAll = YES;
    
    for (RefundShopModel *model in self.dataArray ) {
        if (!model.hsSelect) {
            hsSelectAll = NO;
            break;
        }
    }
    
    if (hsSelectAll) {
        
        self.hsSelectAll = YES;
        [self.btnSelectAll setImage:[UIImage imageNamed:@"o2o_ tick_h_icon"] forState:UIControlStateNormal];
    
    }else {
        self.hsSelectAll = NO;
        [self.btnSelectAll setImage:[UIImage imageNamed:@"o2o_ tick_icon"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)onClickSelectAll:(id)sender {
    self.hsSelectAll = !self.hsSelectAll;
    
    if (self.hsSelectAll) {
        [self.btnSelectAll setImage:[UIImage imageNamed:@"o2o_ tick_h_icon"] forState:UIControlStateNormal];
        
        for (RefundShopModel *model in self.dataArray) {
            model.hsSelect = YES;
        }
        
    }else {
        [self.btnSelectAll setImage:[UIImage imageNamed:@"o2o_ tick_icon"] forState:UIControlStateNormal];
        for (RefundShopModel *model in self.dataArray) {
            model.hsSelect = NO;
        }
    }
    
    [self.tableView reloadData];
}

- (IBAction)onClickOK:(id)sender {
    NSMutableArray *a = [NSMutableArray new];
    
    for (RefundShopModel *model in self.dataArray ) {
        if (model.hsSelect) {
            [a addObject:model];
            //break;
        }
    }
    
    if (a.count == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请选择要退款的物品"];
    }else
    {
        RefundApplicationViewController *vc =[RefundApplicationViewController new];
        vc.shopArray =a;
        [[AppDelegate sharedAppDelegate]pushViewController:vc];
        
    }
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
    [self upDateNewRequest];
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
            for (UIViewController *vc  in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
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
            for (UIViewController *vc  in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            
            break;
        default:
            break;
    }
}
@end
