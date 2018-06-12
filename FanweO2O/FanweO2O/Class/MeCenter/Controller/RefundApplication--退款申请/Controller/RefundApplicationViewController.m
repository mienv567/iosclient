//
//  RefundApplicationViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundApplicationViewController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "RefundApplicationHeaderView.h"
#import "RefundApplicationModel.h"
#import "RefSectionHeaderView.h"
#import "RefundApplicationContentTableViewCell.h"
#import "MyOrderDetailsVC.h"
@interface RefundApplicationViewController ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
    NSMutableString *str;
    NSMutableString *string;
    RefundApplicationHeaderView *refundApplicationHeaderview;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation RefundApplicationViewController
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
- (void)updateNewData {
  
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_order" forKey:@"ctl"];
    [dic setObject:@"refund" forKey:@"act"];
    str =[[NSMutableString alloc] init];
     string =[[NSMutableString alloc] init];
    if (_shopArray.count !=0) {
        for (int i =0; i<_shopArray.count; i++) {
            _shopModel =_shopArray[i];
            if (i != 0) {
                if (([_shopModel.is_shop intValue]==1 && [_shopModel.is_pick intValue]==1) ||[_shopModel.is_shop intValue]==0) {
                    [string appendString:@","];
                }else
                {
                     [str appendString:@","];
                }
                
                
               
            }
            if (([_shopModel.is_shop intValue]==1 && [_shopModel.is_pick intValue]==1) ||[_shopModel.is_shop intValue]==0) {
                [string appendString:_shopModel.id];
            }else{
                [str appendString:_shopModel.id];
            }
            
            
            
        }
    }
   
    if (string.length !=0) {
        [dic setObject:string forKey:@"coupon_id"];
    }
    if (str.length != 0) {
        [dic setObject:str forKey:@"deal_id"];
    }
    
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            [_dateArray removeAllObjects ];
            _dateArray=[RefundApplicationModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            
        }
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.httpManager =[NetHttpsManager manager];
    _dateArray =[NSMutableArray array];
    _content =[NSMutableArray array];
    [self bulidNav];
    [self bulidTableView];
    [self updateNewData];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundApplicationContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"退款申请";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}

- (void)bulidTableView{
    
    _tableView =[[UITableView alloc]  initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64-50) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.rowHeight =170;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, kScreenH-50, kScreenW, 50);
    btn.backgroundColor =[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00];
    [btn setTitle:@"提交申请" forState:UIControlStateNormal];
    btn.titleLabel.font =KAppTextFont15;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dateArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 0;
    }else
    {
        if (_dateArray.count != 0) {
            RefundApplicationModel *model =_dateArray[section-1];
            return model.list.count;
        }
    }
    return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        refundApplicationHeaderview =[[RefundApplicationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        return refundApplicationHeaderview;
    }else
    {
        RefSectionHeaderView *view =[[RefSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
        view.model =_dateArray[section -1];
        return view;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 150;
    }else
    {
        return 46;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundApplicationContentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_dateArray.count != 0) {
        RefundApplicationModel *model =_dateArray [indexPath.section-1];
        MainContent *mModel =model.list[indexPath.row];
        cell.model =mModel;
    }
    return cell;
}

- (void)btnClick
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_order" forKey:@"ctl"];
    [dic setObject:@"do_refund" forKey:@"act"];
    if (string.length !=0) {
        [dic setObject:string forKey:@"coupon_id"];
    }
    if (str.length != 0) {
        [dic setObject:str forKey:@"deal_id"];
    }
    if ([refundApplicationHeaderview.textView.text isEqualToString:@""]) {
        [[HUDHelper sharedInstance] tipMessage:@"请添加退款原因"];
        return;
    }else
    {
         [dic setObject:refundApplicationHeaderview.textView.text forKey:@"content"];
    }
    
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyOrderDetailsVC class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
        
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
    [self.tableView.mj_header beginRefreshing];
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
            [self.navigationController popViewControllerAnimated:YES];
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
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
