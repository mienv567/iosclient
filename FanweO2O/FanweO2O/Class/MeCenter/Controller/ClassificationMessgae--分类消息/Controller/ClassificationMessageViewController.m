//
//  ClassificationMessageViewController.m
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassificationMessageViewController.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "ClassificationMessageModel.h"
#import "ClassificationMessageTableViewCell.h"
#import "MyCenterViewController.h"
#import "MyOrderDetailsVC.h"

@interface ClassificationMessageViewController ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation ClassificationMessageViewController
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
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"cate" forKey:@"act"];
    [dic setObject:_type forKey:@"msgType"];
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            [_dateArray removeAllObjects ];
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                _tableView.mj_footer.hidden =YES;
            }else
            {
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
                    [_tableView.mj_header endRefreshing];
                    [self updateMoreData];
                }];
            }
            _dateArray=[ClassificationMessageModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"]];
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            
        }
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)updateMoreData {
    self.page ++;
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"cate" forKey:@"act"];
    [dic setObject:_type forKey:@"msgType"];
    [dic setObject:@(self.page) forKey:@"page"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NSDictionary *pageDic =responseJson[@"page"];
            if (self.page >=[pageDic[@"page_total"] integerValue]) {
                _tableView.mj_footer =[RefCustomView footerWithRefreshingBlock:^{
                     [_tableView.mj_footer endRefreshingWithNoMoreData];
                }];
               
            }
            [self.tableView.mj_footer endRefreshing];
            
            NSArray *array =[ClassificationMessageModel mj_objectArrayWithKeyValuesArray:responseJson[@"data"]];
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
    [self updateNewData];
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
    [_tableView registerNib:[UINib nibWithNibName:@"ClassificationMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"CMcell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ShareLasterBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"lasterCell"];

}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =_typeName;
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
    _tableView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    _tableView.rowHeight =70;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenW-20, 45)];
    view.backgroundColor =[UIColor clearColor];
    UILabel *label =[[UILabel alloc] initWithFrame:view.frame];
    label.backgroundColor =[UIColor clearColor];
    label.font =kAppTextFont12;
    label.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    if (_dateArray.count != 0) {
        ClassificationMessageModel *model =_dateArray[section];
        label.text =model.create_time;
    }
    label.textAlignment =NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dateArray.count !=0) {
        if (section+1 ==_dateArray.count) {
            return 10;
        }
    }
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ClassificationMessageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CMcell"];
    cell.model =_dateArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ClassificationMessageModel *model =_dateArray[indexPath.section];

        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
        if ([model.app.type intValue]==302) {
            jumpModel.data_id =model.data_id;
        }
         jumpModel.type = [model.app.type integerValue];
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
        pop.alpha =1;
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
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
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
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
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



@end
