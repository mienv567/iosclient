//
//  PayListViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PayListViewController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "PayListModel.h"
#import "PayListTableViewCell.h"
@interface PayListViewController ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation PayListViewController
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
    self.page =1;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_store_pay_order" forKey:@"ctl"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] ==1) {
            [_dateArray removeAllObjects ];
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            _dateArray=[PayListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
            [_tableView tableViewDisplayWitMsg:@"暂无数据~" ifNecessaryForRowCount:_dateArray.count];
            
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
    [dic setObject:@"uc_store_pay_order" forKey:@"ctl"];
    [dic setObject:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            NSArray *array =[PayListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
            [_dateArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
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
    [_tableView registerNib:[UINib nibWithNibName:@"PayListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PLcell"];
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"买单订单";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)bulidTableView{
    _tableView =[[UITableView alloc]  initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.rowHeight =170;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dateArray.count !=0) {
        return _dateArray.count;
    }
    return 0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *grayView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    grayView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    return grayView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section+1 ==_dateArray.count  ) {
        return 0.01;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PLcell"];
    PayListModel *cModel =_dateArray[indexPath.section];
    cell.model =cModel;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
