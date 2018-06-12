//
//  RefundDetailsViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundDetailsViewController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MyCenterViewController.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "RedundDetailsTableViewCell.h"
#import "RefundListModel.h"
#import "RefundDetailsContentModel.h"
#import "RefundDetailsContentTableViewCell.h"
@interface RefundDetailsViewController ()<SecondaryNavigationBarViewDelegate,PopViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
    RefundDetailsContentTableViewCell *appCell;
    RefundDetailsContentModel *appModel;
    
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)RedundDetailsTableViewCell *DTcell;

@end

@implementation RefundDetailsViewController
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
    nav = [SecondaryNavigationBarView EditNibFromXib];
    nav.frame = CGRectMake(0, 20, kScreenW, 44);
    nav.delegate = self;
    nav.searchText = @"退款详情";
    nav.isTitleOrSearch = YES;
    [self.view addSubview:nav];
    
    pop = [[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _httpManager =[NetHttpsManager manager];
    _dataArray =[NSMutableArray array];
    [self bulidNav];
    [self bulidTableView];
    [self updateNewData];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailsContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}
- (void)bulidTableView{
    
    _tableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
- (void)updateNewData
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_order" forKey:@"ctl"];
    [dic setObject:@"refund_view" forKey:@"act"];
    [dic setObject:_redundMID forKey:@"data_id"];
    if (_redundID !=nil ) {
        [dic setObject:_redundID forKey:@"did"];
    }
    ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
         HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            _dataArray = [RefundDetailsContentModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
            [_tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
         HideIndicatorInView(self.view);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if(section ==1){
        if (_dataArray.count !=0) {
            return _dataArray.count;
        }
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0.01;
    }else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 0.01;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (_dataArray.count !=0) {
            if (appModel.content ==nil) {
                return 38;
            }else{
                return 28+_DTcell.height;

            }
        }
    }else {
        
        return  appCell.height;
    }
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    view.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    return view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count !=0) {
        appModel =_dataArray[indexPath.row];
    }
    if (indexPath.section ==0) {

        _DTcell =[tableView dequeueReusableCellWithIdentifier:@"redCell"];
        if (!_DTcell) {
            _DTcell =[[RedundDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"redCell"];
        }
        _DTcell.textContent =appModel.content;
       _DTcell.selectionStyle =UITableViewCellSelectionStyleNone;
        return _DTcell;
    }else{
            appCell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (appModel !=nil) {
            appCell.model =appModel;
        }
        appCell.selectionStyle =UITableViewCellSelectionStyleNone;

        return  appCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        
        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=deal&data_id=%@",

                              API_LOTTERYOUT_URL,appModel.deal_id];
        jumpModel.url =urlString;

        jumpModel.type = 0;
        jumpModel.isHideNavBar = YES;
        jumpModel.isHideTabBar = YES;
        [FWO2OJump didSelect:jumpModel];
        
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
    [self updateNewData];
    //    [self.tableView.mj_header beginRefreshing];
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
            self.tabBarController.selectedIndex = 0;
            for (UIViewController *view in self.navigationController.viewControllers) {
                if ([view isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:view animated:YES];
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
            for (UIViewController *view in self.navigationController.viewControllers) {
                if ([view isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:view animated:YES];
                }
            }
            break;
        default:
            break;
    }
}
@end
