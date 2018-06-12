//
//  ActivityListTBVC.m
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ActivityListTBVC.h"
#import "UITableView+CNHEmptyDataSet.h"
#import "ActivityTableViewCell.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"

#import "RightLittleButtonOnBottom.h"
@interface ActivityListTBVC ()<UIScrollViewDelegate,RightLittleButtonOnBottomDelegate>
{
    RightLittleButtonOnBottom  *_rightLittleButtonOnBottom;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *activityArray;

@end

@implementation ActivityListTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //_tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.httpManager = [NetHttpsManager manager];
    self.fanweApp = [GlobalVariables sharedInstance];
    
    self.activityArray = [NSMutableArray new];
    
    self.tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _page = 2;
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self updateNewData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [self.tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    

//    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
//    _rightLittleButtonOnBottom.delegate = self;
//    _rightLittleButtonOnBottom.hidden = YES;
//    _rightLittleButtonOnBottom.kind =1;
//    [self.view addSubview:_rightLittleButtonOnBottom];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.activityArray.count == 0) {
        
        [self.tableView.mj_header beginRefreshing];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityTableViewCell *cell = [ActivityTableViewCell cellWithTbaleview:tableView];
    ActivityItem *item = self.activityArray[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    ActivityItem *item = self.activityArray[indexPath.row];

    
    jump.type = 0;
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=event&data_id=%@",
                          API_LOTTERYOUT_URL,item.id];
    jump.url = urlString;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];
}

//下拉刷新
- (void)updateNewData {
   
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"events" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.bcateModel.id forKey:@"cate_id"];
    if (_word != nil) {
        [parameters setValue:_word forKey:@"keyword"];

    }
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_header endRefreshing];
        NSLog(@"==========%@",responseJson);
        [self.activityArray removeAllObjects];
        self.activityArray = [ActivityItem mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if ([dicPage[@"page_size"] integerValue] >  self.activityArray.count) {
            //没有分页
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView tableViewDisplayWitMsg:@"暂无活动" ifNecessaryForRowCount:self.activityArray.count];
        [self.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
    
}

//上拉刷新
- (void)updateMoreData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (_word != nil) {
        [parameters setValue:_word forKey:@"keyword"];
    }
    [parameters setValue:@"events" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.bcateModel.id forKey:@"cate_id"];
    [parameters setValue:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_footer endRefreshing];
        
        //[self.activityArray removeAllObjects];
        NSArray *array = [ActivityItem mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if ([dicPage[@"page_size"] integerValue] >  array.count) {
            //没有分页
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.activityArray addObjectsFromArray:array];
        [self.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 30) {
        
        _rightLittleButtonOnBottom.hidden = NO;
        
    }else
    {
        _rightLittleButtonOnBottom.hidden = YES;
    }
}
- (void)backToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > 30) {
//        
//        _rightLittleButtonOnBottom.hidden =NO;
//        
//    }else
//    {
//        _rightLittleButtonOnBottom.hidden =YES;
//    }
//}
//- (void)backToTop
//{
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//}

@end
