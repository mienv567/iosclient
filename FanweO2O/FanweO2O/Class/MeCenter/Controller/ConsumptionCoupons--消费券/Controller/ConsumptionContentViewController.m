//
//  ConsumptionContentViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionContentViewController.h"
#import "ConsumptionModel.h"
#import "QrCodeTableViewCell.h"
#import "ConsumptionView.h"
#import "ConsumptionBottomView.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"

@interface ConsumptionContentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation ConsumptionContentViewController
- (void)updateNewData {
    self.page =1;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_coupon" forKey:@"ctl"];
    if (_order_id !=nil) {
        [dic setObject:_order_id forKey:@"order_id"];
    }
    [dic setObject:@"wap_index" forKey:@"act"];

    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            [_tableView.mj_footer resetNoMoreData];
            [_tableView.mj_header endRefreshing];
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
            _dateArray=[ConsumptionModel mj_objectArrayWithKeyValuesArray:responseJson[@"tuan_item"]];
           
            [_tableView tableViewDisplayWitMsg:@"暂无团购消费券" ifNecessaryForRowCount:_dateArray.count];
            
            
            [_tableView reloadData];
            
        }
    } FailureBlock:^(NSError *error) {
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
            NSArray *array =[ConsumptionModel mj_objectArrayWithKeyValuesArray:responseJson[@"tuan_item"]];
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
    ConsumptionView *vc =[[ConsumptionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 63+20)];
    ConsumptionModel *cModel=_dateArray[section];
    vc.model =cModel;
    vc.backColor =[UIColor whiteColor];
    vc.lineColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_header:)];
    vc.tag = 4000 + section;
     [vc addGestureRecognizer:tap];
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
    return 63+20;
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
- (void)action_header:(UIGestureRecognizer *)tap
{
    NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 4000];
    ConsumptionModel *cModel=_dateArray[[str intValue]];
    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
    

    
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=deal&data_id=%@",
                          API_LOTTERYOUT_URL,cModel.deal_id];
    jumpModel.url =urlString;
    jumpModel.type = 0;
    jumpModel.isHideNavBar = YES;
    jumpModel.isHideTabBar = YES;
    [FWO2OJump didSelect:jumpModel];
    
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tongzhi:(NSNotification *)text{
    if ([text.userInfo[@"index"] intValue] ==0) {
        [_tableView.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
