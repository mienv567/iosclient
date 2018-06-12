//
//  FWCommonViewController.m
//  FanweO2O
//
//  Created by hym on 2016/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWCommonViewController.h"

@interface FWCommonViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation FWCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    [self.view setBackgroundColor:kBackGroundColor];
    [self.tableView setBackgroundColor:kBackGroundColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //初始化参数
    [self handerData];
    
    _tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _page = 2;
        [_tableView.mj_footer resetNoMoreData];
        [_tableView.mj_footer endRefreshing];
        [self updateNewData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [_tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    
}

//初始化参数
- (void)handerData {
    
    _advArray = [NSMutableArray new];
    _adv2Array = [NSMutableArray new];
    
    _indexsArray = [NSMutableArray new];
    _articleArray = [NSMutableArray new];
    _dealListArray = [NSMutableArray new];
    _supplierListArray = [NSMutableArray new];
    _cateListArray = [NSMutableArray new];
    _eventListArray = [NSMutableArray new];
    _youhuiListArray = [NSMutableArray new];
    
    _httpManager = [NetHttpsManager manager];
    
    _fanweApp = [GlobalVariables sharedInstance];
    
    _page = 2;
}

//下拉刷新
- (void)updateNewData {
    [self.tableView.mj_header endRefreshing];
}

//上拉刷新
- (void)updateMoreData {
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

@end
