//
//  ConsumptionMeselfLiftViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionMeselfLiftViewController.h"
#import "QrCodeTableViewCell.h"
#import "ConsumptionLiftView.h"
#import "ConsumptionBottomView.h"
#import "MyOrderDetailsVC.h"
@interface ConsumptionMeselfLiftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation ConsumptionMeselfLiftViewController
- (void)updateNewData {
    self.page =1;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_coupon" forKey:@"ctl"];
    if (_order_id !=nil) {
        [dic setObject:_order_id forKey:@"order_id"];
    }
    [dic setObject:@"wap_index" forKey:@"act"];
    [dic setObject:@"1" forKey:@"coupon_status"];
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
            _dateArray=[ConsumptionModel mj_objectArrayWithKeyValuesArray:responseJson[@"pick_item"]];
            [self.tableView.mj_header endRefreshing];
            
            [_tableView tableViewDisplayWitMsg:@"暂无自提消费券" ifNecessaryForRowCount:_dateArray.count];
       
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
            NSArray *array =[ConsumptionModel mj_objectArrayWithKeyValuesArray:responseJson[@"pick_item"]];
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
    if (_dateArray.count !=0) {
        ConsumptionModel *cModel=_dateArray[section];
        if (cModel.open ==NO) {
            if ([cModel.count intValue]>1 || [cModel.count intValue]==1) {
                return 1;
            }
        }else{
            return cModel.coupon.count;
        }
    }
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsumptionLiftView *vc =[[ConsumptionLiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 63+20)];
    ConsumptionModel *cModel=_dateArray[section];
    vc.model =cModel;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_headerTap:)];
    vc.tag = 5200 + section;
    [vc addGestureRecognizer:tapClick];
    return vc;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ConsumptionModel *cModel=_dateArray[section];
    if ([cModel.count intValue]>1) {
        ConsumptionBottomView * vc =[[ConsumptionBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 56)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
        vc.tag = 300 + section;
        if (cModel.open) {
            vc.type =@"2";
        }else{
            vc.type =@"1";
        }
        [vc addGestureRecognizer:tap];
        return vc;
    }else
    {
        UIView *grayView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        grayView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
        return grayView;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45+47;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ConsumptionModel *cModel=_dateArray[section];
    if ([cModel.count intValue]>1) {
        return 56;
    }else
    {
        
        return 10;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConsumptionModel *cModel =_dateArray[indexPath.section];
    CouponCount * couponModel =cModel.coupon[indexPath.row];
    if ([couponModel.status intValue] ==1) {
        if (_delegate && [_delegate respondsToSelector:@selector(qrCodeView:andQrcode:)]) {
            [_delegate qrCodeView:couponModel.password andQrcode:couponModel.qrcode];
        }
    }else{
        return;
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QrCodeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"QCcell"];
    ConsumptionModel *cModel =_dateArray[indexPath.section];
    CouponCount * couponModel =cModel.coupon[indexPath.row];
    cell.model =couponModel;
    return cell;
}
- (void)action_tap:(UIGestureRecognizer *)tap{
    
    NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 300];
    ConsumptionModel *cModel=_dateArray[[str integerValue]];
    cModel.open = !cModel.open;
    //    [self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str intValue]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)action_headerTap:(UIGestureRecognizer *)tap
{
    BOOL hsFind = false;
    for (UIViewController *vc in [[AppDelegate sharedAppDelegate] navigationViewController].viewControllers) {
        if ([vc isKindOfClass:[MyOrderDetailsVC class]]) {
            [[AppDelegate sharedAppDelegate] popViewController];
            hsFind = true;
        }
    }
    if (!hsFind) {
        NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 5200];
        ConsumptionModel *cModel=_dateArray[[str integerValue]];
        MyOrderDetailsVC *vc =[MyOrderDetailsVC new];
        vc.data_id =cModel.order_id;
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
    
 
   
}
- (void)tongzhi:(NSNotification *)text{
    if ([text.userInfo[@"index"] intValue] ==1) {
        [_tableView.mj_header beginRefreshing];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
