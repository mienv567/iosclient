//
//  FavorableListVC.m
//  FanweO2O
//
//  Created by hym on 2017/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FavorableListVC.h"
#import "ClassSectionView.h"
#import "ClassSectionModel.h"
#import "ClassSectionTableViewCell.h"
#import "ClassSelcectVC.h"
#import "LMDropdownView.h"
#import "NSDictionary+Property.h"
#import "FavorableTBCell.h"
#import "FavorableModel.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "O2OAccountLoginVC.h"

#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "SecondaryNavigationBarView.h"
#define LMD_VIEW_TAG    2001
@interface FavorableListVC() <UITableViewDelegate,UITableViewDataSource,ClassSectionTableViewCellDelegate,ClassSelcectVCDelegate,LMDropdownViewDelegate,FavorableTBCellDelegate,PopViewDelegate,SecondaryNavigationBarViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (nonatomic, strong) ClassBcate_list *selectCommon;
@property (nonatomic, strong) ClassQuan_list *selectArea;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *order_type;

@end

@implementation FavorableListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
    HideIndicatorInView(self.view);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tableView.mj_header beginRefreshing];
    [self updateNewData];
    self.order_type = @"distance";
    self.kind =1;
    self.searchText =@"领券中心";
    self.judgeNav =YES;
    [self popViewController];
}
- (void)popViewController
{
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view addSubview:pop];
}
- (void)handerData {
    
    [super handerData];
    
    [self doInitSectionArray];
    
    self.dataArray = [NSMutableArray new];
   
    
    self.tableView.backgroundColor = kBackGroundColor;
    
    //[self.tableView reloadData];
    
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
    
}

- (void)doInitSectionArray {
    
    ClassSectionModel *model1 = [ClassSectionModel new];
    model1.name = @"全部分类";
    model1.image = @"o2o_classSection_down_icon";
    model1.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model2 = [ClassSectionModel new];
    model2.name = @"全部·热门";
    model2.image = @"o2o_classSection_down_icon";
    model2.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model3 = [ClassSectionModel new];
    model3.name = @"评价最高";
    model3.hsChange = YES;
    
    ClassSectionModel *model4 = [ClassSectionModel new];
    model4.name = @"离我最近";
    model4.hsSelect = YES;
    model4.hsChange = YES;
    
     self.sectionArray = @[model1,model2,model3,model4];
}

- (void)updateNewData {
    
    self.page = 1;
    self.order_type = @"distance";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"youhuis" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:@"distance" forKey:@"order_type"];
    
    if (self.haselect) {
        
        [parameters setValue:@(self.selectpid) forKey:@"cate_id"];
        
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {

        HideIndicatorInView(self.view);
        NSLog(@"================");
        NSLog(@"%@",responseJson);
        NSDictionary *dicPage = responseJson[@"page"];
        
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //[responseJson[@"item"][0] createPropertyCode];
        
        [self doInitSectionArray];
        
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
        
        
        //self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [FavorableModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        self.title = responseJson[@"page_title"];
   
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
    [parameters setValue:@"youhuis" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    [parameters setValue:@(self.page) forKey:@"page"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"================");
        NSLog(@"%@",responseJson);
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        //[responseJson[@"item"][0] createPropertyCode];
        
        
        NSArray *array =  [FavorableModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.tableView reloadData];
        
        
        
    } FailureBlock:^(NSError *error) {
        self.page--;
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark 选择
- (void)updateSelectData {
    
    [self.tableView.mj_footer resetNoMoreData];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"youhuis" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    
    ShowIndicatorTextInView(self.view,@"");
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        NSLog(@"================");
        
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        [self selectDataHandler];
        
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        
        //[responseJson[@"item"][0] createPropertyCode];
        
        //[self doInitSectionArray];
        
        /*
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        self.selectCommon = [self.classSectionModel.bcate_list firstObject];
        self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
        
        self.selectArea = [self.classSectionModel.quan_list firstObject];
        self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
        */
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [FavorableModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //self.title = responseJson[@"page_title"];
        
        [self.tableView reloadData];
        
        //[self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        //[self.tableView.mj_header endRefreshing];
        
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.sectionArray.count == 0) {
            return 0;
        }
        return 40;
    }
    
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

#define CLASS_SECTION_TAG   1001

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ClassSectionTableViewCell *cell = [ClassSectionTableViewCell cellWithTableView:tableView];
    
        cell.delegate = self;
        cell.array = self.sectionArray;
        
        return cell;
        
    }
    
    FavorableTBCell *cell = [FavorableTBCell cellWithTbaleview:tableView];
    cell.delegate = self;
    FavorableModel *model = self.dataArray[indexPath.row];
    
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    FavorableModel *model = self.dataArray[indexPath.row];
    //ActivityItem *item = self.activityArray[indexPath.row];
    
    
    jump.type = 0;
    
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=youhui&data_id=%@",
                          API_LOTTERYOUT_URL,model.id];
    jump.url =urlString;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];
    
}

#pragma marl ClassSectionTableViewCellDelegate 

- (void)ClassSectionSelect:(ClassSectionModel *)model {
    
    
    //[self.view addSubview:vc.view];
    

    //if (self.dropdownView.isOpen) {
        //[self LMDropdownHide];
    //}

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
        
        self.order_type = @"avg_point";
        [self LMDropdownHide];
        [self updateSelectData];
        
    }else if (model.tag == 3) {
        
        self.order_type = @"distance";
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

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView {
    
    ClassSectionModel *model1 = self.sectionArray[0];
    
    model1.hsSelect = NO;
    
    ClassSectionModel *model2 = self.sectionArray[1];
    
    model2.hsSelect = NO;
    
    [self.tableView reloadData];
    
}

- (void)immediatelyGetWithModel:(FavorableModel *)model {
    
    if (model.status == 1) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:@"youhui" forKey:@"ctl"];
        [parameters setValue:@"download_youhui" forKey:@"act"];
        [parameters setValue:model.id forKey:@"data_id"];
        ShowIndicatorTextInView(self.view,@"");
        
        __weak FavorableListVC *weakSelf = self;
        [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
            HideIndicatorInView(weakSelf.view);
            NSLog(@"================");
            NSLog(@"%@",responseJson);
            
            
            if ([[responseJson allKeys] containsObject:@"user_login_status"])
            { //判断字典中是否含有这个key
                if ([responseJson toInt:@"user_login_status"] == 0) { //判断是否登录状态
                    //未登录
                    O2OAccountLoginVC *vc = [[O2OAccountLoginVC alloc] initWithNibName:@"O2OAccountLoginVC" bundle:nil];
                    
                    [[AppDelegate sharedAppDelegate] pushViewController:vc];
                    
                }else{
                    if ([responseJson[@"status"] integerValue] == 1) {
                        FavorableModel *model = [FavorableModel mj_objectWithKeyValues:responseJson[@"data"]];
                        
                        for (int i = 0; i < weakSelf.dataArray.count; i++) {
                            FavorableModel *a = weakSelf.dataArray[i];
                            if ([a.id isEqualToString:model.id]) {
                                a.status = model.status;
                                a.info = model.info;
                                a.youhui_type = model.youhui_type;
                                [weakSelf.dataArray replaceObjectAtIndex:i withObject:a];
                                break;
                            }
                        }
                        [weakSelf.tableView reloadData];
                        
                    }else {
                        [[HUDHelper sharedInstance] tipMessage:[MyTool dicObject:responseJson[@"info"]]];
                    }
                }
            }else{
                if ([responseJson[@"status"] integerValue] == 1) {
                    FavorableModel *model = [FavorableModel mj_objectWithKeyValues:responseJson[@"data"]];
                    
                    for (int i = 0; i < weakSelf.dataArray.count; i++) {
                        FavorableModel *a = weakSelf.dataArray[i];
                        if ([a.id isEqualToString:model.id]) {
                            a.status = model.status;
                            a.info = model.info;
                            a.youhui_type = model.youhui_type;
                            [weakSelf.dataArray replaceObjectAtIndex:i withObject:a];
                            break;
                        }
                    }
                    [weakSelf.tableView reloadData];
                    
                }else {
                    [[HUDHelper sharedInstance] tipMessage:[MyTool dicObject:responseJson[@"info"]]];
                }

            }
        } FailureBlock:^(NSError *error) {
            HideIndicatorInView(weakSelf.view);
            
        }];

    }else if(model.status == 2) {
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        
        //ActivityItem *item = self.activityArray[indexPath.row];
        

        jump.type = 0;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",
                              API_LOTTERYOUT_URL,model.jump];
        jump.url = urlString;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        [FWO2OJump didSelect:jump];
    }

}
- (void)nextToNewViewController{
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
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popViewControllerAnimated:YES];
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
            self.tabBarController.selectedIndex =3;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
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
