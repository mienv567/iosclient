//
//  RefundListViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundListViewController.h"

#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "RefundListModel.h"
#import "RefundTableViewCell.h"
#import "RefundDetailsViewController.h"
@interface RefundListViewController ()<SecondaryNavigationBarViewDelegate,PopViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
    RefundTableViewCell *cell;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation RefundListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"退款订单";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)updateNewData {
    self.page =1;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_order" forKey:@"ctl"];
    [dic setObject:@"refund_list" forKey:@"act"];
   [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
       if ([responseJson toInt:@"status"] ==1) {
           [_dateArray removeAllObjects ];
           NSDictionary *pageDic =responseJson[@"page"];
           if (self.page >=[pageDic[@"page_total"] integerValue]) {
               [self.tableView.mj_footer endRefreshingWithNoMoreData];
           }
           self.dateArray=[RefundListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
          
            [_tableView tableViewDisplayWitMsg:@"暂无退款记录" ifNecessaryForRowCount:_dateArray.count];
           
           [self.tableView.mj_header endRefreshing];
           [_tableView reloadData];
          
       }
   } FailureBlock:^(NSError *error) {
     
       [self.tableView.mj_header endRefreshing];
   }];
    
}
- (void)updateMoreData {
    self.page ++;
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_order" forKey:@"ctl"];
    [dic setObject:@"refund_list" forKey:@"act"];
    [dic setObject:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NSArray *array =[RefundListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.dateArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        self.page --;
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.httpManager =[NetHttpsManager manager];
    _dateArray =[NSMutableArray array];
    [self bulidNav];
    [self bulidTableView];
    _tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _page = 1;
        [_tableView.mj_footer resetNoMoreData];
        [_tableView.mj_footer endRefreshing];
        [self updateNewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [_tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    [_tableView.mj_header beginRefreshing];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundTableViewCell" bundle:nil] forCellReuseIdentifier:@"appCell"];

}
- (void)bulidTableView{
    _tableView =[[UITableView alloc]  initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dateArray.count !=0) {
        return self.dateArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dateArray.count !=0) {
        if (cell.height !=0) {
            return cell.height;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

     cell =[tableView dequeueReusableCellWithIdentifier:@"appCell"];
    if (!cell) {
        cell =[[RefundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"appCell"];
    }
    if (self.dateArray.count !=0) {
        RefundListModel *model = self.dateArray[indexPath.row];
        cell.storeNameLabel.text =model.supplier_name;
        cell.refundTypeLabel.text =model.status_str;
        [cell.stroeImageView.imageView sd_setImageWithURL: [NSURL URLWithString:model.deal_icon]];
        cell.goodsDateilLabel.text =model.name;
        cell.goodsPricesLabel.text =[NSString stringWithFormat:@"￥%@",model.unit_price];
        cell.goodsCountLabel.text =[NSString stringWithFormat:@"x%@",model.number];
        cell.refund_type =model.refund_status;
        cell.money.text =[NSString stringWithFormat:@"退款金额: ￥%@",model.refund_money];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundDetailsViewController *vc =[RefundDetailsViewController new];
    RefundListModel *model = self.dateArray[indexPath.row];
    if (model.id !=nil) {
        vc.redundID=model.id;
    }
    vc.redundMID =model.mid;
    [self.navigationController pushViewController:vc animated:YES];
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


@end
