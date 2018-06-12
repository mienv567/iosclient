//
//  CommonBaseListVC.m
//  FanweO2O
//  通用列表1
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "CommonBaseListVC.h"
#import "SecondaryNavigationBarView.h"
#import "DiscoveryViewController.h"
#import "UINavigationController+WXSTransition.h"
@interface CommonBaseListVC ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate>
{
    SecondaryNavigationBarView *nav;
    
}
@end

@implementation CommonBaseListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_kind == 1) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.top.equalTo(self.view.mas_top).with.offset(64);
        }];
    }else if (_kind ==2){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.top.equalTo(self.view.mas_top).with.offset(64+40);
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bulidNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView = [[UITableView alloc] init];
    
    [self.view addSubview:self.tableView];
  
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 44.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
    
    
    //初始化参数
    [self handerData];
    
//    _tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//        _page = 1;
//        [_tableView.mj_footer resetNoMoreData];
//        [_tableView.mj_footer endRefreshing];
//        [self updateNewData];
//    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [_tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFun) name:FW_O2O_LOCATION_SUCCESS object:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HideIndicatorInView(self.view);
}



- (void)setKind:(int)kind
{
    _kind =kind;
    
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    [self.view addSubview:nav];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText =searchText;
     nav.searchText =_searchText;
}
- (void)setJudgeNav:(BOOL)judgeNav
{
    _judgeNav =judgeNav;
    nav.isTitleOrSearch =_judgeNav;
}
//初始化参数
- (void)handerData {
    

    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToDiscovery
{
    [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
}

- (void)popNewView
{
    
    [self nextToNewViewController];
}

- (void)nextToNewViewController
{
    
}


- (void)locationFun {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
