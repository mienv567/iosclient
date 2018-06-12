//
//  MallViewController.m
//  FanweO2O
//  商城按钮
//  Created by ycp on 16/12/2.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "MallViewController.h"
#import "SDCycleScrollView.h"
#import "CustomGoodsTableViewCell.h"
#import "BannerContContainerTBCell.h"
#import "MallIndexsTBCell.h"
#import "MallIndexModel.h"
#import "BannerModel.h"
#import "NetHttpsManager.h"
#import "FWHeadLineTBCell.h"
#import "HeadLineModel.h"
#import "SectionHeaderView.h"
#import "CustomGoodsModel.h"
#import "CustomGoodsTableViewCell.h"
#import "ClassificationViewController.h"
#import "CustomTopTableViewCell.h"
#import "HomeZtCell.h"
#import "DiscoveryViewController.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "RightLittleButtonOnBottom.h"
#import "MallListVC.h"
#import "O2OCommonNavigationBarView.h"
#define KMallClassCellSection           0   //分类搜索
#define KMallArticleCellSection         3   //头条位置
#define KMallAdvsCellSection            1   //广告位置
#define KMallAdvs2CellSection           6
#define KMallIndexsCellSection          2   //菜单列表位置
#define KMallZt_htm3CellSection         4   //专题1
#define KMallZt_htm4CellSection         5   //专题1
#define KMallZt_htm5CellSection         7   //专题1
#define KMallZt_htm6CellSection         8   //专题1


#define KMallDeal_listCellSection       9   //猜你喜欢

/*
#define KMallSupplier_listCellSection   9   //店家推荐
#define KMallCate_listCellSection       10
#define KMallEvent_listCellSection      11  //活动列表
#define KMallYouhui_listCellSection     11  //优惠列表
*/
#define KMallSectons                    10   //Section的个数


@interface MallViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CustomGoodsTBCellDelegate,MallIndexsTBCellDelegate,CustomTopTableViewCellDelegate,BannerContContainerDelegate,HomeZtCellDelegate,RightLittleButtonOnBottomDelegate> {
    RightLittleButtonOnBottom *_rightLittleButtonOnBottom;
    BOOL _is_refresh_up;
}



@end

@implementation MallViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.fd_interactivePopDisabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    [self rightBottomButton];
    [self.tableView.mj_header beginRefreshing];
    self.fd_interactivePopDisabled = YES;
    
    O2OCommonNavigationBarView *nav = [O2OCommonNavigationBarView createView];
    nav.lbTitles.text = @"商城";
    [self.view addSubview:nav];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(44);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
}

- (void)handerData {
 
    [super handerData];

   
}
- (void)rightBottomButton
{
    //设置返回顶部按钮
    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
    _rightLittleButtonOnBottom.delegate = self;
    _rightLittleButtonOnBottom.hidden = YES;
    _rightLittleButtonOnBottom.kind =3;
    [self.view addSubview:_rightLittleButtonOnBottom];
}
- (void)backToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>kScreenH) {
        _rightLittleButtonOnBottom.hidden =NO;
    }else
    {
        _rightLittleButtonOnBottom.hidden =YES;
    }
    
    
}


- (void)updateNewData {
    
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"shop" forKey:@"ctl"];

    __weak MallViewController *weakSelf = self;
   
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
       
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        _is_refresh_up = YES;
        
        //DebugLog(@"responseJson = %@",responseJson);
        
        weakSelf.city_id = responseJson[@"city_id"];
        
        weakSelf.city_name = responseJson[@"city_name"];
        
        //头条
        weakSelf.articleArray = [HeadLineModel mj_objectArrayWithKeyValuesArray:responseJson[@"article"]];
        [weakSelf.articleArray removeAllObjects];
        //轮播图是否有圆弧
        weakSelf.is_banner_square = [responseJson[@"is_banner_square"] integerValue];
        
        //轮播图一
        weakSelf.advArray = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs"]];
        
        //轮播图二
        weakSelf.adv2Array = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs2"]];
        
        //菜单列表
        weakSelf.indexsArray = [MallIndexModel mj_objectArrayWithKeyValuesArray:responseJson[@"indexs"][@"list"]];
        //猜你喜欢列表
        weakSelf.dealListArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"supplier_deal_list"]];
        
        //专题推荐
        weakSelf.zt3Html = [responseJson toString:@"zt_html3"];
        weakSelf.zt4Html = [responseJson toString:@"zt_html4"];
        weakSelf.zt5Html = [responseJson toString:@"zt_html5"];
        weakSelf.zt6Html = [responseJson toString:@"zt_html6"];
        
        
        [weakSelf.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];

    }];
    
}

- (void)updateMoreData {
    //ctl=shop&act=load_index_list_data
    self.page ++;
    [self.tableView.mj_header endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"shop" forKey:@"ctl"];
    [parameters setValue:@"load_index_list_data" forKey:@"act"];
    [parameters setValue:@(self.page) forKey:@"page"];
    __weak MallViewController *weakSelf = self;
    
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_footer endRefreshing];
        
        
        
        NSArray *array = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        [self.supplierListArray addObjectsFromArray:array];
        if ([responseJson[@"page_total"] integerValue] <= self.page) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [weakSelf.dealListArray addObjectsFromArray:array];
        
        //weakSelf.dealListArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        
        [self.tableView reloadData];

        
    } FailureBlock:^(NSError *error) {
        
        self.page --;
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KMallClassCellSection) {
                 
        return _is_refresh_up ? 1:0;
        
    }else if (section == KMallAdvsCellSection) {
        
        return self.advArray.count == 0 ? 0 : 1;
        
    }else if (section == KMallIndexsCellSection){
        
        return self.indexsArray.count == 0 ? 0 : 1;
        
    }else if (section == KMallArticleCellSection) {
        
        return self.articleArray.count == 0 ? 0 : 1;
        
    }else if (section == KMallDeal_listCellSection) {
        
        return self.dealListArray.count == 0 ? 0 : ceil(self.dealListArray.count/2.0);
        
    }else if (section == KMallZt_htm3CellSection ) {
       
        return [self.zt3Html length] > 0 ? 1 : 0;
        
    }else if (section == KMallZt_htm4CellSection ) {
        
        return [self.zt4Html length] > 0 ? 1 : 0;
        
    }else if (section == KMallZt_htm5CellSection ) {
        
        return [self.zt5Html length] > 0 ? 1 : 0;
        
    }else if (section == KMallZt_htm6CellSection ) {
        
        return [self.zt6Html length] > 0 ? 1 : 0;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return KMallSectons;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
    
    //分类
    if (indexPath.section == KMallClassCellSection ) {
        CustomTopTableViewCell *cell = [CustomTopTableViewCell cellWithTbaleview:tableView];
        cell.delegate =self;
        return cell;
        
    }else if (indexPath.section == KMallAdvsCellSection) {
        BannerContContainerTBCell *cell = [BannerContContainerTBCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.bannerArray = self.advArray;

        return cell;
        
    }else if (indexPath.section == KMallIndexsCellSection) {
        
        MallIndexsTBCell *cell = [MallIndexsTBCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.indexsArray = self.indexsArray;
        return cell;
        
    }else if (indexPath.section == KMallArticleCellSection) {
        
        FWHeadLineTBCell *cell = [FWHeadLineTBCell cellWithTbaleview:tableView];
        
        cell.headLineArray = self.articleArray;
        return cell;
        
    }else if (indexPath.section == KMallDeal_listCellSection) {
        
        CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
        cell.delegate = self;
        cell.hsShowPrice =YES;
        [cell upDataWith:self.dealListArray indexPath:indexPath];
        
        return cell;
    }else if (indexPath.section == KMallZt_htm3CellSection) {
        static NSString *cellIndent3 =  @"KMallZt_htm3CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent3] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KMallZt_htm3CellSection];
        
        [cell setCellContent:self.zt3Html isWebViewDidFinishLoad:self.zt3_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KMallZt_htm4CellSection) {
        
        static NSString *cellIndent4 =  @"KMallZt_htm4CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent4] ;
        
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KMallZt_htm4CellSection];
        
        [cell setCellContent:self.zt4Html isWebViewDidFinishLoad:self.zt4_isWebViewDidFinishLoad];
        return cell;
        
    }else if (indexPath.section == KMallZt_htm5CellSection) {
        static NSString *cellIndent5 =  @"KMallZt_htm5CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent5] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KMallZt_htm5CellSection];
        [cell setCellContent:self.zt5Html isWebViewDidFinishLoad:self.zt5_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KMallZt_htm6CellSection) {
        static NSString *cellIndent6 =  @"KMallZt_htm6CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent6] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KMallZt_htm6CellSection];
        [cell setCellContent:self.zt6Html isWebViewDidFinishLoad:self.zt6_isWebViewDidFinishLoad];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (section == KMallDeal_listCellSection && self.dealListArray.count > 0) {

        SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FW_SECTION_HEADEVIEW_HIGHT) imageName:@"guess" titleName:@"猜你喜欢"];
        [view setBackgroundColor:kBackGroundColor];
        return view;
    }
    
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == KMallDeal_listCellSection) {
    
        return self.dealListArray.count == 0 ? 0.001f : FW_SECTION_HEADEVIEW_HIGHT;
        
    }else if (section == KMallZt_htm3CellSection) {
        
        return [self.zt3Html length] > 0 ? 10.0f : 0.001f;
        
    }else if (section == KMallZt_htm4CellSection) {
        
        return [self.zt4Html length] > 0 ? 10.0f : 0.001f;
        
    }else if (section == KMallZt_htm5CellSection) {
        
        return [self.zt5Html length] > 0 ? 10.0f : 0.001f;
        
    }else if (section == KMallZt_htm6CellSection) {
        return [self.zt6Html length] > 0 ? 10.0f : 0.001f;
        
    }else if (section == KMallAdvs2CellSection) {
        
        return self.adv2Array.count > 0 ? 10.0f : 0.001f;
    }else if (section == KMallArticleCellSection ){
        
        return self.articleArray.count > 0 ? 10.0f : 0.001f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    if (KMallSectons - 1 == section) {
        
        return 10.0f;
    }
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == KMallClassCellSection) {
        
        return 40;
        
    }else if (indexPath.section == KMallAdvsCellSection) {
        
        return FW_O2O_BANNER_HIGHT;
        
    }else if (indexPath.section == KMallIndexsCellSection) {
       
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == KMallArticleCellSection) {
        
        return FW_HEADELINE_HIGHT;
        
    }else if (indexPath.section == KMallAdvs2CellSection) {
        
        return FW_O2O_BANNER_HIGHT;
        
    }else if(indexPath.section == KMallZt_htm3CellSection) {
        
        return self.myZt3Height;
        
    }else if(indexPath.section == KMallZt_htm4CellSection) {
        
        return self.myZt4Height;
        
    }else if(indexPath.section == KMallZt_htm5CellSection) {
        
        return self.myZt5Height;
        
    }else if(indexPath.section == KMallZt_htm6CellSection) {
        
        return self.myZt6Height;
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark 事件代理

- (void)refreshTableView:(NSString *)myHeight withTag:(NSInteger)Tag{
    
    NSIndexPath *indexPath;
    switch (Tag) {
        case KMallZt_htm3CellSection:
        {
            self.zt3_isWebViewDidFinishLoad = YES;
            self.myZt3Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KMallZt_htm3CellSection];
            
        }
            break;
        case KMallZt_htm4CellSection:
        {
            self.zt4_isWebViewDidFinishLoad = YES;
            self.myZt4Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KMallZt_htm4CellSection];
            
        }
            break;
        case KMallZt_htm5CellSection:
        {
            self.zt5_isWebViewDidFinishLoad = YES;
            self.myZt5Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KMallZt_htm5CellSection];
            
        }
            break;
        case KMallZt_htm6CellSection:
        {
            self.zt6_isWebViewDidFinishLoad = YES;
            self.myZt6Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KMallZt_htm6CellSection];
            
        }
            break;
        default:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    //[_tableView reloadData];
}

#pragma mark  HomeZtCellDelegate

- (void)goDetail:(NSString *)detailType detailId:(NSString *)detailId {
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    
    jump.type = [detailType integerValue];
    jump.url = detailId;
    jump.data_id = detailId;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];
    
}

#pragma mark BannerContContainerDelegate

- (void)bannerContContainerGoNextVC:(BannerModel *)model {
    
//    FWO2OJumpModel *jump = [FWO2OJumpModel new];
//    if ([model.type integerValue]== 0) {
//        jump.type = 0;
//        
//        if ([model.data.url length] == 0) {
//            return;
//        }
//        
//        jump.url = model.data.url;
//        jump.isHideNavBar = YES;
//        jump.name = model.name;
//        jump.isHideTabBar = YES;
//        
//    }else {
//        
//        jump.isHideTabBar = YES;
//        jump.isHideNavBar = YES;
//        jump.url = [NSString stringWithFormat:@"%@?ctl=%@",API_LOTTERYOUT_URL,model.ctl];
//    }
//    
//    [FWO2OJump didSelect:jump];
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    //NSLog(@"%@",[model.data JSONString]);
    NSMutableString *muString = [NSMutableString new];
    
    for (NSString *key in model.data.allKeys) {
        
        NSString *value = [model.data stringForKey:key];
        
        if (value.length > 0) {
            [muString appendFormat:@"&%@=%@",key,[model.data stringForKey:key]];
        }
        
    }
    
    if ([model.ctl isEqualToString:@"shop"]) {
        jump.type = 102;
        
    }else if ([model.ctl isEqualToString:@"main"]) {
        jump.type = 103;
    }else if ([model.ctl isEqualToString:@"tuan"]) {
        jump.type = 11;
        if ( model.data.allKeys.count > 0) {
            jump.data_id = [model.data.allValues firstObject];
        }
    }
    else if([model.ctl isEqualToString:@"youhuis"]) {
        
        if (kOlderVersion >= 2) {
            jump.type = 15;
            if ( model.data.allKeys.count > 0) {
                jump.data_id = [model.data.allValues firstObject];
            }
        }else{
            
            
            jump.isHideTabBar = YES;
            jump.isHideNavBar = YES;
            jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        }
        
    }else if ([model.ctl isEqualToString:@"events"]) {
        
        if (kOlderVersion >= 2) {
            jump.type = 14;
        }else{
            
            
            jump.isHideTabBar = YES;
            jump.isHideNavBar = YES;
            jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        }
        
    }else if ([model.ctl isEqualToString:@"goods"]) {
        
        if (kOlderVersion >= 2) {
            jump.type = 12;
            if ( model.data.allKeys.count > 0) {
                jump.data_id = [model.data.allValues firstObject];
            }
        }else{
            
            
            
            jump.isHideTabBar = YES;
            jump.isHideNavBar = YES;
            jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        }
        
    }else if ([model.ctl isEqualToString:@"stores"]) {
        
        if (kOlderVersion >= 2) {
            jump.type = 26;
            if ( model.data.allKeys.count > 0) {
                jump.data_id = [model.data.allValues firstObject];
            }
        }else{
            
            
            
            jump.isHideTabBar = YES;
            jump.isHideNavBar = YES;
            jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        }
        
    }else if ([model.ctl isEqualToString:@"user_center"]) {
        
        if (kOlderVersion >= 2) {
            jump.type = 107;
        }else{
            
            
            
            jump.isHideTabBar = YES;
            jump.isHideNavBar = YES;
            jump.url = [NSString stringWithFormat:@"%@?ctl=%@",API_LOTTERYOUT_URL,model.ctl];
        }
        
    }else if ([model.ctl isEqualToString:@"index"]) {
        return;
    }else if ([model.ctl isEqualToString:@"search"]) {
        self.tabBarController.selectedIndex =1;
        return;
    }else {
        
        
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        
    }
    NSLog(@"%@",jump.url);
    [FWO2OJump didSelect:jump];
}
- (void)goNextVC:(MallIndexModel *)model {
    
  
    
    if (kOlderVersion == 1) {
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.type = 0;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        //jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,WEB_BASE_INFO];
        jump.url = [NSString stringWithFormat:@"%@%@",model.url,WEB_BASE_INFO];
        [FWO2OJump didSelect:jump];
        
    }else {
        
        MallListVC *vc = [MallListVC new];
        vc.haselect = YES;
        vc.selectpid = [model.id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
    
}

- (void)customGoodGoNextVC:(CustomGoodsModel *)model {
    
    FWO2OJumpModel *fw =[FWO2OJumpModel new];
    fw.type = 0;
    fw.url = model.app_url;
    fw.name = model.brief;
    fw.isHideNavBar = YES;
    fw.isHideTabBar = YES;
    [FWO2OJump didSelect:fw];
    
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)leftBtn
{
     [self.navigationController pushViewController:[[ClassificationViewController alloc] init] animated:YES];
}

//搜索按钮
- (void)rightBtn
{
     [self.navigationController pushViewController:[[DiscoveryViewController alloc] init] animated:YES];
}

@end
