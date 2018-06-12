//
//  MyOrderListTBVC.m
//  FanweO2O
//  子列表
//  Created by hym on 2017/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderListTBVC.h"
#import "MyCommonOrderTBCell.h"
#import "NSDictionary+Property.h"
#import "UIView+BlocksKit.h"
#import "MyOrderModel.h"
#import "MyOrderDetailsVC.h"
#import "UITableView+CNHEmptyDataSet.h"

@interface MyOrderListTBVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NetHttpsManager *httpManager;

@property (nonatomic, strong) GlobalVariables *fanweApp;

//@property (nonatomic, strong) MyOrderBaseModel *myOrderModel;

@end

@implementation MyOrderListTBVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 44.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [NSMutableArray new];
    _httpManager = [NetHttpsManager manager];
    
    _fanweApp = [GlobalVariables sharedInstance];
    
    tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _page = 2;
        [tableView.mj_footer resetNoMoreData];
        [tableView.mj_footer endRefreshing];
        [self updateNewData];
    }];

    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    
    
    [self.view addSubview:tableView];
    
    
    
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewData) name:FW_O2O_REFRESH_ORDER object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewData) name:FW_O2O_EVALUATE_ORDER object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"MyOrderRefresh" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyOrderRefresh" object:nil];
}
#pragma mark 网络请求

- (void)updateNewData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"index" forKey:@"act"];
    [parameters setValue:@(self.orderType) forKey:@"pay_status"];
    __weak MyOrderListTBVC *weekSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        
        
        weekSelf.page = 1;
        [weekSelf.tableView.mj_footer resetNoMoreData];
        [weekSelf.tableView.mj_header endRefreshing];
        
        [self.dataArray removeAllObjects];
        
        MyOrderBaseModel *myOrderModel = [MyOrderBaseModel mj_objectWithKeyValues:responseJson];
        
        [self.dataArray addObjectsFromArray:myOrderModel.item];
        
     
        if (myOrderModel.page.page_total <= weekSelf.page) {
            //污数据
            weekSelf.tableView.mj_footer.hidden =YES ;
        }else
        {
            _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
                [_tableView.mj_header endRefreshing];
                [self updateMoreData];
            }];
        }
      
        [weekSelf.tableView tableViewDisplayWitMsg:@"列表那么空，不如去买买买~" ifNecessaryForRowCount:self.dataArray.count];
        
        
        [weekSelf.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void)updateMoreData {
    self.page ++;
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"index" forKey:@"act"];
    [parameters setValue:@(self.page) forKey:@"page"];
    [parameters setValue:@(self.orderType) forKey:@"pay_status"];
    __weak MyOrderListTBVC *weekSelf = self;
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
     
        
        MyOrderBaseModel *myOrderModel = [MyOrderBaseModel mj_objectWithKeyValues:responseJson];
        [weekSelf.dataArray addObjectsFromArray:myOrderModel.item];
        [weekSelf.tableView.mj_footer endRefreshing];
        if (myOrderModel.page.page_total <= weekSelf.page) {
            //污数据
            weekSelf.tableView.mj_footer =[RefCustomView footerWithRefreshingBlock:^{
                
            }];
        }
        
        [weekSelf.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        weekSelf.page --;
        [weekSelf.tableView.mj_header endRefreshing];
    }];
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section + 1 == self.dataArray.count) {
        return 10.0f;
    }
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    return view;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewContainer = [UIView new];
    return viewContainer;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCommonOrderTBCell *cell = [MyCommonOrderTBCell cellWithTbaleview:tableView];
    
    MyOrderItemModel *item = self.dataArray[indexPath.section];
    
    cell.orderItem = item;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MyOrderItemModel *item = self.dataArray[indexPath.section];
//    MyOrderDetailsVC *vc = [MyOrderDetailsVC new];
//    vc.data_id = item.id;
//    [[AppDelegate sharedAppDelegate] pushViewController:vc];
}
- (void)tongzhi:(NSNotification *)text{
    [_tableView.mj_header beginRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
