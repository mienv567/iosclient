
//  PreferentialViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
// 优惠券控制器

#import "PreferentialViewController.h"
#import "PreferentialView.h"
#import "PreferentialModel.h"
#import "QrCodeTableViewCell.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "QrCodeView.h"

@interface PreferentialViewController ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate,QrCodeViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
    QrCodeView *qrView;
    
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation PreferentialViewController
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
    [dic setObject:@"uc_youhui" forKey:@"ctl"];
    [dic setObject:@"wap_index" forKey:@"act"];

    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {

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
            _dateArray=[PreferentialModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
            [self.tableView.mj_header endRefreshing];
           
            [_tableView tableViewDisplayWitMsg:@"暂无优惠券" ifNecessaryForRowCount:_dateArray.count];
            
            [_tableView reloadData];
            
        }
    } FailureBlock:^(NSError *error) {

        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)updateMoreData {
    self.page ++;
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_youhui" forKey:@"ctl"];
    [dic setObject:@"wap_index" forKey:@"act"];
    [dic setObject:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                _tableView.mj_footer = [RefCustomView footerWithRefreshingBlock:^{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }];
                
            }
            [self.tableView.mj_footer endRefreshing];
            
            NSArray *array =[PreferentialModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
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
    [self qrCode];
    
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
     [_tableView registerNib:[UINib nibWithNibName:@"ShareLasterBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"lasterCell"];
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"优惠券";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (UIView *)qrCode
{
    qrView =[QrCodeView EditNibFromXib];
    qrView.frame =CGRectMake(0,0, kScreenW, kScreenH);
    qrView.alpha =0;
    qrView.delegate =self;
    [self.view bringSubviewToFront:qrView];
    [self.view addSubview:qrView];
    return qrView;
}
- (void)bulidTableView{
    _tableView =[[UITableView alloc]  initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
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

    
    PreferentialView *vc =[[PreferentialView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 86)];
    PreferentialModel *cModel=_dateArray[section];
    vc.pModel =cModel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    vc.tag = 300 + section;
    [vc addGestureRecognizer:tap];
    return vc;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *grayView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    grayView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    return grayView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    
    return 86;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 46;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PreferentialModel *cModel =_dateArray[indexPath.section];
    if ([cModel.status intValue] ==1) {
        qrView.qrCodeNumber.text =[NSString stringWithFormat:@"劵码: %@",cModel.youhui_sn];
        [qrView.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:cModel.qrcode]];
        [UIView animateWithDuration:0.5 animations:^{
            qrView.alpha =1;
        }];
    }else{
        return;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    QrCodeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"QCcell"];
    PreferentialModel *cModel =_dateArray[indexPath.section];
    cell.pModel =cModel;
    return cell;
    
}

- (void)goBackToView
{
    [UIView animateWithDuration:0.5 animations:^{
        qrView.alpha =0;
    }];
    
    
}

- (void)action_tap:(UIGestureRecognizer *)tap
{
    
    NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 300];
    PreferentialModel *cModel=_dateArray[[str intValue]];
    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=youhui&data_id=%@",
                          API_LOTTERYOUT_URL,cModel.youhui_id];
    jumpModel.url =urlString;
    jumpModel.type = 0;
    jumpModel.isHideNavBar = YES;
    jumpModel.isHideTabBar = YES;
    [FWO2OJump didSelect:jumpModel];
    
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
        {
            self.tabBarController.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
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
        {
          
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
 
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
