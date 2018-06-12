//
//  ConsumptionPickUpGoodsViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/21.
//  Copyright © 2017年 xfg. All rights reserved.
//  

#import "ConsumptionPickUpGoodsViewController.h"
#import "QrCodeTableViewCell.h"
#import "ConsumptionLiftView.h"
#import "PickUpGoodsModel.h"
#import "MyOrderDetailsVC.h"
@interface ConsumptionPickUpGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;


@end

@implementation ConsumptionPickUpGoodsViewController
- (void)updateNewData {
    self.page =1;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_coupon" forKey:@"ctl"];
    if (_order_id !=nil) {
        [dic setObject:_order_id forKey:@"order_id"];
    }
    [dic setObject:@"wap_index" forKey:@"act"];
    [dic setObject:@"2" forKey:@"coupon_status"];
    //    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        //         HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            [_dateArray removeAllObjects ];
            
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                self.tableView.mj_footer.hidden =YES;
            }else
            {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
                    [_tableView.mj_header endRefreshing];
                    [self updateMoreData];
                }];
            }
            _dateArray=[PickUpGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"dist_item"]];
            [self.tableView.mj_header endRefreshing];
         
            [_tableView tableViewDisplayWitMsg:@"暂无驿站取货码" ifNecessaryForRowCount:_dateArray.count];
            
         
            [_tableView reloadData];
            
        }
    } FailureBlock:^(NSError *error) {
        //         HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)updateMoreData {
    self.page ++;
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_coupon" forKey:@"ctl"];
    [dic setObject:@"wap_index" forKey:@"act"];
    [dic setObject:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                _tableView.mj_footer = [RefCustomView footerWithRefreshingBlock:^{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }];
                
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            NSArray *array =[PickUpGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"dist_item"]];
            [_dateArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.httpManager =[NetHttpsManager manager];
    _dateArray =[NSMutableArray array];
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
    [_tableView registerNib:[UINib nibWithNibName:@"QrCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"QCcell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"Refresh" object:nil];
    
}
- (void)bulidTableView{
    _tableView =[[UITableView alloc]  initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
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
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsumptionLiftView *vc =[[ConsumptionLiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 63+20)];
    PickUpGoodsModel *cModel=_dateArray[section];
    vc.pModel =cModel;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_headerTap:)];
    vc.tag = 5200 + section;
    [vc addGestureRecognizer:tapClick];
    return vc;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45+47;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PickUpGoodsModel *cModel =_dateArray[indexPath.section];
    if ([cModel.status intValue] ==1) {
        if (_delegate && [_delegate respondsToSelector:@selector(qrCodeView:andQrcode:)]) {
            [_delegate qrCodeView:cModel.sn andQrcode:cModel.qrcode];
        }
    }else{
        return;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QrCodeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"QCcell"];
    PickUpGoodsModel *cModel =_dateArray[indexPath.section];
    cell.PGmodel =cModel;
    return cell;
}

- (void)action_headerTap:(UITapGestureRecognizer *)tap{
    BOOL hsFind = false;
    for (UIViewController *vc in [[AppDelegate sharedAppDelegate] navigationViewController].viewControllers) {
        if ([vc isKindOfClass:[MyOrderDetailsVC class]]) {
            [[AppDelegate sharedAppDelegate] popViewController];
            hsFind = true;
        }
    }
    if (!hsFind) {
        NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 5200];
        PickUpGoodsModel *cModel=_dateArray[[str integerValue]];
        MyOrderDetailsVC *vc =[MyOrderDetailsVC new];
        vc.data_id =cModel.order_id;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
}
- (void)tongzhi:(NSNotification *)text{
    if ([text.userInfo[@"index"] intValue] ==2) {
        [_tableView.mj_header beginRefreshing];
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
