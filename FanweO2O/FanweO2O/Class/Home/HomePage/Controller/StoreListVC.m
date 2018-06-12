//
//  StoreListVC.m
//  FanweO2O
//  门店列表
//  Created by hym on 2017/1/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "StoreListVC.h"
#import "ClassSectionView.h"
#import "ClassSectionModel.h"
#import "ClassSectionTableViewCell.h"
#import "ClassSelcectVC.h"
#import "LMDropdownView.h"
#import "NSDictionary+Property.h"
#import "ListRefreshLocationTBCell.h"
#import "StoreListTBCell.h"
#import "StoreListModel.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "ListRefreshLocationModel.h"
#import "UITableView+CNHEmptyDataSet.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import <UserNotifications/UserNotifications.h>
#import "RightLittleButtonOnBottom.h"
@interface StoreListVC ()<UITableViewDelegate,UITableViewDataSource,ClassSectionTableViewCellDelegate,ClassSelcectVCDelegate,ListRefreshLocationTBCellDelegate,StoreListTBCellDelegate,LMDropdownViewDelegate,PopViewDelegate,UIScrollViewDelegate,RightLittleButtonOnBottomDelegate>
{
    PopView *pop;
    RightLittleButtonOnBottom  *_rightLittleButtonOnBottom;
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (nonatomic, strong) ClassBcate_list *selectCommon;
@property (nonatomic, strong) ClassQuan_list *selectArea;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, strong) ListRefreshLocationModel *location;

@end

#define LMD_VIEW_TAG    2001

@implementation StoreListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(64);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 44.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//        self.page = 1;
//        [self.tableView.mj_footer resetNoMoreData];
//        [self.tableView.mj_footer endRefreshing];
//        [self updateNewData];
//    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [self.tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    self.page = 1;
    [self updateNewData];
    //[self.tableView.mj_header beginRefreshing];

    self.order_type = @"distance";

    
    self.kind =1;
    if (_content !=nil || ![_content isEqualToString:@""]) {
        self.searchText =_content;

    }
    self.judgeNav = NO;
    [self popViewController];

}
- (void)setContent:(NSString *)content
{
    _content = content;
}
- (void)popViewController
{
    pop = [[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
    
    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
    _rightLittleButtonOnBottom.delegate = self;
    _rightLittleButtonOnBottom.hidden = YES;
    _rightLittleButtonOnBottom.kind = 0;
    [self.view addSubview:_rightLittleButtonOnBottom];
}
- (void)handerData {
    
    [super handerData];
    
    [self doInitSectionArray];
    
    self.dataArray = [NSMutableArray new];
    
    
    self.tableView.backgroundColor = kBackGroundColor;
    
    [self.tableView reloadData];
    
    //赋于下拉的里效果视图
    self.dropdownView = [[LMDropdownView alloc] init];
    self.dropdownView.contentBackgroundColor = [UIColor clearColor];
    self.dropdownView.closedScale = 1;

    self.dropdownView.animationDuration = 0.3;
    self.dropdownView.delegate = self;


    UIView *dropdownView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_HEIGHT, CGRectGetHeight(self.view.frame) - 104)];

    dropdownView.backgroundColor = kBackGroundColor;
    dropdownView.tag = LMD_VIEW_TAG;
    
    [self.view addSubview:dropdownView];
    
    [self.view sendSubviewToBack:dropdownView];
    
    
    ListRefreshLocationModel *location = [ListRefreshLocationModel new];
    location.location = self.fanweApp.locateName;
    
    self.location = location;
    
}

- (void)doInitSectionArray {
    
    ClassSectionModel *model1 = [ClassSectionModel new];
    model1.name = @"全部分类";
    model1.image = @"o2o_classSection_down_icon";
    model1.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model2 = [ClassSectionModel new];
    model2.name = @"全部";
    model2.image = @"o2o_classSection_down_icon";
    model2.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model3 = [ClassSectionModel new];
    model3.name = @"距离";
    model3.hsSelect = YES;
    model3.hsChange = YES;
    
    ClassSectionModel *model4 = [ClassSectionModel new];
    model4.name = @"最新";
    
    model4.hsChange = YES;
    
    ClassSectionModel *model5 = [ClassSectionModel new];
    model5.name = @"评分";
    model5.hsChange = YES;
    
    self.sectionArray = @[model1,model2,model3,model4,model5];
}


- (void)updateNewData {
    
    self.page = 1;
    self.order_type = @"distance";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"stores" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:@"distance" forKey:@"order_type"];
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    
    if (self.haselect) {
        
        [parameters setValue:@(self.selectpid) forKey:@"cate_id"];
        
        
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"================");
        HideIndicatorInView(self.view);
        
        [self doInitSectionArray];
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        if (self.haselect) {
            self.haselect = NO;
            BOOL hsFind = NO;
            for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
                if (a.id == self.selectpid ) {
                    self.selectCommon = a;
                    self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
                    ClassSectionModel *model1 = self.sectionArray[0];
                    model1.name = self.selectCommon.name;
                    //self.selectCommon.hsSelectModel.name = self.selectCommon.name;
                    hsFind = YES;
                }
            }
            if (!hsFind) {
                self.selectCommon = [self.classSectionModel.bcate_list firstObject];
                self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
                
            }
            
            self.selectArea = [self.classSectionModel.quan_list firstObject];
            self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
            
        }else {
            
            self.selectCommon = [self.classSectionModel.bcate_list firstObject];
            self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
            
            self.selectArea = [self.classSectionModel.quan_list firstObject];
            self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
            
        }
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [StoreListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        self.title = responseJson[@"page_title"];
        [self.tableView tableViewDisplayWitMsg:@"暂无详情" ifNecessaryForRowCount:self.dataArray.count];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)updateMoreData {
    self.page++;
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"stores" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    [parameters setValue:@(self.page) forKey:@"page"];
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSDictionary *dicPage = responseJson[@"page"];
        [self.tableView.mj_footer endRefreshing];
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //[self.dataArray removeAllObjects];
        
        //self.dataArray = [StoreListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        NSArray *array = [StoreListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        [self.dataArray addObjectsFromArray:array];
        //self.title = responseJson[@"page_title"];
        
        [self.tableView reloadData];
        
        
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];

        
    
}

#pragma mark 选择
- (void)updateSelectData {
    [self.tableView.mj_footer resetNoMoreData];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"stores" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    [parameters setValue:@(Bcate_type.id) forKey:@"tid"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        NSLog(@"================");
        //[responseJson[@"item"][0] createPropertyCode];
        
        //[self doInitSectionArray];
        
        /*
         self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
         self.selectCommon = [self.classSectionModel.bcate_list firstObject];
         self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
         
         self.selectArea = [self.classSectionModel.quan_list firstObject];
         self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
         */
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        [self selectDataHandler];
        
        self.page = 1;
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [StoreListModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        //self.title = responseJson[@"page_title"];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.sectionArray.count == 0) {
            return 0;
        }
        return 40;
    }else if (indexPath.section == 1) {
        
        return 36;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return 20.0f;
    }
    
    return 0.0001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }
    
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}




#define CLASS_SECTION_TAG   1001

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ClassSectionTableViewCell *cell = [ClassSectionTableViewCell cellWithTableView:tableView];
        
        cell.delegate = self;
        cell.iCount = 5;
        cell.array = self.sectionArray;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        ListRefreshLocationTBCell *cell = [ListRefreshLocationTBCell cellWithTbaleview:tableView];
        
        cell.delegate = self;
        cell.model = self.location;
        return cell;
    }
    
    StoreListModel *model = self.dataArray[indexPath.row];
    
    StoreListTBCell *cell = [StoreListTBCell cellWithTbaleview:tableView];
    cell.delegate = self;
    cell.model = model;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view  = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    StoreListModel *model = self.dataArray[indexPath.row];
    //ActivityItem *item = self.activityArray[indexPath.row];
    
    jump.type = 0;
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=store&data_id=%@",
                          API_LOTTERYOUT_URL,model.id];
    jump.url =urlString;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];

}

- (void)selectPayTheBill:(StoreListModel *)model {
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    //StoreListModel *model = self.dataArray[indexPath.row];
    //ActivityItem *item = self.activityArray[indexPath.row];
    
    jump.type = 0;
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=store_pay&id=%@",
                          API_LOTTERYOUT_URL,model.id];
    jump.url = urlString;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];
}


#pragma marl ClassSectionTableViewCellDelegate

- (void)ClassSectionSelect:(ClassSectionModel *)model {
    
    
    //[self.view addSubview:vc.view];
    
    if (model.tag == 0) {
        
        ClassSelcectVC *vc = [[ClassSelcectVC alloc] initWithNibName:@"ClassSelcectVC" bundle:nil];
        
        vc.view.frame = CGRectMake(0, 64 + 40 - (SCREEN_HEIGHT - 64 - 40), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        
        [vc classSelectCommonInitWith:self.selectCommon
                             delegate:self
                           selectType:ClassSelectCommon];
        vc.dataArray = self.classSectionModel.bcate_list;
        
        
        if (model.hsSelect) {
            
            if (self.dropdownView.isOpen) {
                
                //[self LMDropdownHide];
                [self.dropdownView hide];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ClassSectionModel *model1 = self.sectionArray[0];
                    
                    model1.hsSelect = YES;
                    
                    [self.tableView reloadData];
                    
                    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                    
                    [self.view bringSubviewToFront:dropdownView];
                    
                    [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
                });
                
            }else {
                UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                
                [self.view bringSubviewToFront:dropdownView];
                
                [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
            }

            
        }else {
            [self LMDropdownHide];
        }
        
    }else if (model.tag == 1) {
        
        
        ClassSelcectVC *vc = [[ClassSelcectVC alloc] initWithNibName:@"ClassSelcectVC" bundle:nil];
        
        
        vc.view.frame = CGRectMake(0, 64 + 40 - (SCREEN_HEIGHT - 64 - 40), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        
        
        [vc classSelectAreaInitWith:self.selectArea
                           delegate:self
                         selectType:ClassSelectArea];
        
        vc.dataArray = self.classSectionModel.quan_list;
        
        
        if (model.hsSelect) {
            
            if (self.dropdownView.isOpen) {
                
                //[self LMDropdownHide];
                [self.dropdownView hide];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ClassSectionModel *model1 = self.sectionArray[1];
                    
                    model1.hsSelect = YES;
                    
                    [self.tableView reloadData];
                    
                    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                    
                    [self.view bringSubviewToFront:dropdownView];
                    
                    [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
                });
                
            }else {
                UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                
                [self.view bringSubviewToFront:dropdownView];
                
                [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
            }

            
        }else {
            [self LMDropdownHide];
        }
        
    }else if (model.tag == 2) {
        //距离
        self.order_type = @"distance";
        [self LMDropdownHide];
        [self updateSelectData];
        
    }else if (model.tag == 4) {
        
        self.order_type = @"avg_point";
        [self LMDropdownHide];
        [self updateSelectData];
        
    }else if (model.tag == 3) {
        self.order_type = @"newest";
        [self LMDropdownHide];
        [self updateSelectData];
    }
    
    //[self.tableView reloadData];
}

#pragma mark ClassSelcectVCDelegate


- (void)ClassSelectModel:(id)model classSelectType:(ClassSelectType)classSelectType{
    
    
    if (classSelectType == ClassSelectCommon) {
        
        self.selectCommon = (ClassBcate_list *)model;
        
        ClassSectionModel *model1 = self.sectionArray[0];
        model1.name = self.selectCommon.hsSelectModel.name;
        model1.hsSelect = NO;
        
        ClassSectionModel *model2 = self.sectionArray[1];
        
        model2.hsSelect = NO;
        
    }else if (classSelectType == ClassSelectArea) {
        
        self.selectArea = (ClassQuan_list *)model;
        
        ClassSectionModel *model1 = self.sectionArray[1];
        model1.name = self.selectArea.hsSelectModel.name;
        model1.hsSelect = NO;
        
        ClassSectionModel *model2 = self.sectionArray[0];
        
        model2.hsSelect = NO;
    }
    
    [self updateSelectData];
    
    [self LMDropdownHide];
    
    //[self.tableView reloadData];
}

- (void)LMDropdownHide {
    
    [self.dropdownView hide];
    
    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
    [self.view sendSubviewToBack:dropdownView];
    
}


- (void)startLocation {
    self.location.hsStart = YES;
    [self.fanweApp startLocation];
    [self.tableView reloadData];
}


- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView {
    
    ClassSectionModel *model1 = self.sectionArray[0];
    
    model1.hsSelect = NO;
    
    ClassSectionModel *model2 = self.sectionArray[1];
    
    model2.hsSelect = NO;
    
    [self.tableView reloadData];
    
}

- (void)locationFun {
    self.location.hsStart = NO;
    
    ListRefreshLocationModel *location = [ListRefreshLocationModel new];
    location.location = self.fanweApp.locateName;
    
    self.location = location;
    
    [self updateSelectData];
    //[self.tableView reloadData];
    
}
- (void)nextToNewViewController{
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
     [self LMDropdownHide];
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
            if (self.fanweApp.is_login ==NO) {
                [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
            }else
            {
                [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
            }
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
            self.tabBarController.selectedIndex = 3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    if (scrollView.contentOffset.y > 300) {
        
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

- (void)selectDataHandler {
    
    
    //ClassBcate_list *selectCommon = [self.classSectionModel.bcate_list firstObject];
    
    BOOL hsFind = NO;
    for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
        if (a.id == self.selectCommon.id ) {
            
            //self.selectCommon = a;
            //self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
            BOOL hsFind1 = NO;
            for (ClassBcate_type *b in a.bcate_type) {
                
                if (b.id == self.selectCommon.hsSelectModel.id) {
                    
                    self.selectCommon = a;
                    self.selectCommon.hsSelectModel = b;
                    
                    if (b.cate_id == 0) {
                        ClassSectionModel *model1 = self.sectionArray[0];
                        model1.name = self.selectCommon.name;
                        //self.selectCommon.hsSelectModel.name = self.selectCommon.name;
                    }
                    hsFind1 = YES;
                    break;
                }
            }
            
            if (!hsFind1) {
                
                self.selectCommon = a;
                self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
                ClassSectionModel *model1 = self.sectionArray[0];
                model1.name = self.selectCommon.name;
                //self.selectCommon.hsSelectModel.name = self.selectCommon.name;
            }
            
            
            hsFind = YES;
            break;
        }
    }
    
    if (!hsFind) {
        self.selectCommon = [self.classSectionModel.bcate_list firstObject];
        self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
        
        ClassSectionModel *model1 = self.sectionArray[0];
        model1.name = self.selectCommon.name;
        //self.selectCommon.hsSelectModel.name = self.selectCommon.name;
    }
    
    
    
    hsFind = NO;
    
    for (ClassQuan_list *selectArea in self.classSectionModel.quan_list) {
        if (selectArea.id == self.selectArea.id) {
            hsFind = YES;
            BOOL hsFind1 = NO;
            for (ClassQuan_sub *hsSelectModel in selectArea.quan_sub) {
                if (hsSelectModel.id == self.selectArea.hsSelectModel.id) {
                    self.selectArea = selectArea;
                    self.selectArea.hsSelectModel = hsSelectModel;
                    
                    if (hsSelectModel.pid == 0) {
                        ClassSectionModel *model1 = self.sectionArray[1];
                        model1.name = selectArea.name;
                    }
                    
                    hsFind1 = YES;
                    
                    break;
                }
            }
            
            if (!hsFind1) {
                self.selectArea = selectArea;
                self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
                ClassSectionModel *model1 = self.sectionArray[1];
                model1.name = self.selectArea.name;
                //self.selectArea.hsSelectModel.name = self.selectArea.name;
            }
            
            break;
        }
    }
    
    if (!hsFind) {
        self.selectArea = [self.classSectionModel.quan_list firstObject];
        self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
        
        ClassSectionModel *model1 = self.sectionArray[1];
        model1.name = self.selectArea.name;
        //self.selectArea.hsSelectModel.name = self.selectArea.name;
    }
    
}



@end
