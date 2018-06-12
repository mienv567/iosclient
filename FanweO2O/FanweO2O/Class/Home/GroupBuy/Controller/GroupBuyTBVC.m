//
//  GroupBuyTBVC.m
//  FanweO2O
//  团购
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GroupBuyTBVC.h"
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
#import "CustomGoodsComTBCell.h"
#import "HomeZtCell.h"
#import "DiscoveryViewController.h"
#import "CityPositioningViewController.h"
#import "GlobalVariables.h"
#import "ZFModalTransitionAnimator.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "RightLittleButtonOnBottom.h"
#import "GroupBuyListVC.h"
#import "GroupBuyTBNav.h"
#define KGroupArticleCellSection       2   //头条位置
#define KGroupAdvsCellSection          0   //广告位置
#define KGroupIndexsCellSection        1   //菜单列表位置
#define KGroupZt_htm3CellSection       3   //专题1
#define KGroupZt_htm4CellSection       4   //专题1
#define KGroupZt_htm5CellSection       5   //专题1
#define KGroupZt_htm6CellSection       6   //专题1
#define KGroupDeal_listCellSection     7   //团购推荐
#define KGroupSectons                  8   //Section的个数

@interface GroupBuyTBVC ()<MallIndexsTBCellDelegate,HomeZtCellDelegate,CityPositioningViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,BannerContContainerDelegate,RightLittleButtonOnBottomDelegate,GroupBuyTBNavDelegate>

{
    GroupBuyTBNav *nav;
//    UIButton *btn;
    UIImageView *imageView;
    RightLittleButtonOnBottom *_rightLittleButtonOnBottom;
   
}
@property (nonatomic,strong)ZFModalTransitionAnimator *animator;
@end

@implementation GroupBuyTBVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
//    [ setTitle:[NSString stringWithFormat:@"团购·%@",self.fanweApp.city_name] forState:UIControlStateNormal];
    nav.titleText =[NSString stringWithFormat:@"团购·%@",self.fanweApp.city_name];
    [self updateNewData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.lastArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self handerData];
    [self navView];
    [self rightBottomButton];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(44);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];


}
- (void)navView
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    [self.navigationItem setTitleView:view];
//
//    btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame =CGRectMake((200-150)/2,(44-25)/2,150 ,25);
//   
//    [btn addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
//    [view addSubview:btn];
//    imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dc_takeout_down" ]];
//    imageView.frame =CGRectMake(120,(25-10)/2,12,12);
////    imageView.hidden=YES;
//    [btn addSubview:imageView];
//
//    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame =CGRectMake(0, 0, 22, 22);
//    [rightButton setImage:[UIImage imageNamed:@"o2o_search_h_icon"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = right;
    nav = [GroupBuyTBNav EditNibFromXib];
    nav.frame = CGRectMake(0, 20, kScreenW, 44);
    nav.delegate = self;
    [self.view addSubview:nav];
  
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
#pragma mark 网络请求

- (void)updateNewData {
    _isAccordingCell =NO;
    [self.tableView.mj_footer setHidden:NO];
    self.page = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"main" forKey:@"ctl"];

    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
       
        
        [self.tableView.mj_header endRefreshing];
        
        //DebugLog(@"responseJson = %@",responseJson);
        
        self.city_id = responseJson[@"city_id"];
        
        self.city_name = responseJson[@"city_name"];
        
        self.articleArray = [HeadLineModel mj_objectArrayWithKeyValuesArray:responseJson[@"article"]];
        [self.articleArray removeAllObjects];
        
        self.indexsArray = [MallIndexModel mj_objectArrayWithKeyValuesArray:responseJson[@"indexs"][@"list"]];
        _lastArray =[MallIndexModel mj_objectArrayWithKeyValuesArray:responseJson[@"recommend_deal_cate"]];
        self.advArray = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs"]];
        
        self.adv2Array = [HeadLineModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs2"]];
        
        self.is_banner_square = [responseJson[@"is_banner_square"] integerValue];
        
        self.dealListArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        
        //专题推荐
        self.zt3Html = [responseJson toString:@"zt_html3"];
        
        self.zt4Html = [responseJson toString:@"zt_html4"];
        self.zt5Html = [responseJson toString:@"zt_html5"];
        self.zt6Html = [responseJson toString:@"zt_html6"];
        

        [self.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)updateMoreData {
    //ctl=shop&act=load_index_list_data
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"main" forKey:@"ctl"];
    [parameters setValue:@"load_index_list_data" forKey:@"act"];
    [parameters setValue:@(self.page ++) forKey:@"page"];
    //__weak MallViewController *weakSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_footer endRefreshing];

        NSArray *array = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        [self.dealListArray addObjectsFromArray:array];
        if ([responseJson[@"page_total"] integerValue] <= self.page) {
            _isAccordingCell =YES;
            [self.tableView.mj_footer setHidden:YES];
        }
        
   
        
        [self.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        self.page --;
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KGroupAdvsCellSection) {
        
        return self.advArray.count == 0 ? 0 : 1;
        
    }else if (section == KGroupIndexsCellSection){
        
        return self.indexsArray.count == 0 ? 0 : 1;
        
    }else if (section == KGroupArticleCellSection) {
        
        return self.articleArray.count == 0 ? 0 : 1;
        
    }else if (section == KGroupZt_htm3CellSection) {
        if ([self.zt3Html length]) {
            return 1;
        }else{
            return 0;
        }

    }else if (section == KGroupZt_htm4CellSection) {
        if ([self.zt4Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KGroupZt_htm5CellSection) {
        if ([self.zt5Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KGroupZt_htm6CellSection) {
        if ([self.zt6Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KGroupDeal_listCellSection) {
        return self.dealListArray.count == 0 ? 0 : self.dealListArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return KGroupSectons;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
    
    //广告栏
    if (indexPath.section == KGroupAdvsCellSection) {
        BannerContContainerTBCell *cell = [BannerContContainerTBCell cellWithTableView:tableView];
        cell.delegate =self;
        cell.bannerArray = self.advArray;
        
        return cell;
    }else if (indexPath.section == KGroupIndexsCellSection) {
        
        MallIndexsTBCell *cell = [MallIndexsTBCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.indexsArray = self.indexsArray;
        
        return cell;
        
    }else if (indexPath.section == KGroupArticleCellSection) {
        
        FWHeadLineTBCell *cell = [FWHeadLineTBCell cellWithTbaleview:tableView];
        
        cell.headLineArray = self.articleArray;
        
        return cell;
    }else if (indexPath.section == KGroupDeal_listCellSection) {

        CustomGoodsModel *model = self.dealListArray[indexPath.row];
        CustomGoodsComTBCell *cell = [CustomGoodsComTBCell cellWithTbaleview:tableView];
        
        cell.goodModel = model;
        
        return cell;
        
    }else if (indexPath.section == KGroupZt_htm3CellSection) {
        
        static NSString *cellIndent3 =  @"KGroupZt_htm3CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent3] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KGroupZt_htm3CellSection];
        
        [cell setCellContent:self.zt3Html isWebViewDidFinishLoad:self.zt3_isWebViewDidFinishLoad];
        return cell;
        
    }else if (indexPath.section == KGroupZt_htm4CellSection) {
        
        static NSString *cellIndent4 =  @"KGroupZt_htm4CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent4] ;
        
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KGroupZt_htm4CellSection];
        
        [cell setCellContent:self.zt4Html isWebViewDidFinishLoad:self.zt4_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KGroupZt_htm5CellSection) {
        static NSString *cellIndent5 =  @"KGroupZt_htm5CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent5] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KGroupZt_htm5CellSection];
        [cell setCellContent:self.zt5Html isWebViewDidFinishLoad:self.zt5_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KGroupZt_htm6CellSection) {
        static NSString *cellIndent6 =  @"KGroupZt_htm6CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent6] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KGroupZt_htm6CellSection];
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
    
    
    if (section == KGroupDeal_listCellSection && self.dealListArray.count > 0) {
        
        SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FW_SECTION_HEADEVIEW_HIGHT) imageName:@"group" titleName:@"团购推荐"];
        [view setBackgroundColor:kBackGroundColor];
        return view;
    }
    
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == KGroupDeal_listCellSection) {
        
        return self.dealListArray.count == 0 ? 0.001f : FW_SECTION_HEADEVIEW_HIGHT;
        
        //return FW_SECTION_HEADEVIEW_HIGHT;
    }else if (section == KGroupZt_htm3CellSection) {
        return [self.zt3Html length] > 0 ? 10.0f : 0.001f;
    }else if (section == KGroupZt_htm4CellSection) {
        return [self.zt4Html length] > 0 ? 10.0f : 0.001f;
    }else if (section == KGroupZt_htm5CellSection) {
        return [self.zt5Html length] > 0 ? 10.0f : 0.001f;
    }else if (section == KGroupZt_htm6CellSection) {
        return [self.zt6Html length] > 0 ? 10.0f : 0.001f;
        
    }else if (section == KGroupArticleCellSection ){
        
        return self.articleArray.count > 0 ? 10.0f : 0.001f;
    }
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (KGroupSectons - 1 == section) {
        return 10.0f;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == KGroupAdvsCellSection) {
        
        return FW_O2O_BANNER_HIGHT;
        
    }else if (indexPath.section == KGroupIndexsCellSection) {
        
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == KGroupArticleCellSection) {
        
        return FW_HEADELINE_HIGHT;
        
    }else if(indexPath.section == KGroupZt_htm3CellSection) {
        if ([_count1 intValue] != 0) {
            return [_count1 intValue];
        }
        
    }else if(indexPath.section == KGroupZt_htm4CellSection) {
        if ([_count2 intValue] != 0) {
            return [_count2 intValue];
        }
    }else if(indexPath.section == KGroupZt_htm5CellSection) {
        if ([_count3 intValue] != 0) {
            return [_count3 intValue];
        }
    }else if(indexPath.section == KGroupZt_htm6CellSection) {
        if ([_count4 intValue] != 0) {
            return [_count4 intValue];
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section ==KGroupDeal_listCellSection ) {
        CustomGoodsModel *model = self.dealListArray[indexPath.row];
        FWO2OJumpModel *fw =[FWO2OJumpModel new];
        fw.type =0;
        fw.url = model.app_url;
        fw.name =model.brief;
        fw.isHideTabBar = YES;
        fw.isHideNavBar = YES;
        [FWO2OJump didSelect:fw];
    }
}

#pragma mark 事件代理
- (void)goNextVC:(MallIndexModel *)model {
    
    if (kOlderVersion == 1) {
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.type = 11;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        

        
        jump.url = [NSString stringWithFormat:@"%@?ctl=%@&cate_id=%@%@",API_LOTTERYOUT_URL,model.ctl,model.id,WEB_BASE_INFO];
        [FWO2OJump didSelect:jump];
    }else {
        
        GroupBuyListVC *vc = [GroupBuyListVC new];
        vc.haselect = YES;
        vc.selectpid = [model.id integerValue];
        [[AppDelegate sharedAppDelegate] pushViewController:vc];
    }
    
 
    
}
- (void)clickButton:(NSString *)goodsID
{
    GroupBuyListVC *vc = [GroupBuyListVC new];
    vc.haselect = YES;
    vc.selectpid = [goodsID integerValue];
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
    [self performSelector:@selector(delayTimer) withObject:nil afterDelay:0.5];
   
}
- (void)delayTimer
{
     [self backToTop];
}
- (void)refreshTableView:(NSString *)myHeight withTag:(NSInteger)Tag{
    
    NSIndexPath *indexPath;
    
    switch (Tag) {
        case KGroupZt_htm3CellSection:
        {
            self.zt3_isWebViewDidFinishLoad = YES;
             self.count1 = myHeight ;
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KGroupZt_htm3CellSection];
            
        }
            break;
        case KGroupZt_htm4CellSection:
        {
            self.zt4_isWebViewDidFinishLoad = YES;
            self.count2 = myHeight ;
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KGroupZt_htm4CellSection];
            
        }
            break;
        case KGroupZt_htm5CellSection:
        {
            self.zt5_isWebViewDidFinishLoad = YES;
             self.count3 = myHeight ;
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KGroupZt_htm5CellSection];
            
        }
            break;
        case KGroupZt_htm6CellSection:
        {
            self.zt6_isWebViewDidFinishLoad = YES;
            self.count4 = myHeight ;
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KGroupZt_htm6CellSection];
            
        }
            break;
        default:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark BannerContContainerDelegate

- (void)bannerContContainerGoNextVC:(BannerModel *)model {
//    FWO2OJumpModel *jump = [FWO2OJumpModel new];
//    if ([model.type integerValue]== 0) {
//        jump.type = 0;
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
- (void)searchBtn
{
    [self.navigationController pushViewController:[[DiscoveryViewController alloc] init] animated:NO];
}

- (void)contenBtn
{
    CityPositioningViewController *city = [CityPositioningViewController new];
    city.delegate = self;
    city.modalPresentationStyle = UIModalPresentationCustom;
    self.animator =[[ZFModalTransitionAnimator alloc] initWithModalViewController:city];
    self.animator.transitionDuration = 0.5f;
    self.animator.direction = ZFModalTransitonDirectionTop;
    city.transitioningDelegate = self.animator;
    [self presentViewController:city animated:YES completion:nil];
}


- (void)closeBtn
{
    
    if (self.fanweApp.is_refresh_tableview) {
        [self updateNewData];
        
        if ([self.fanweApp.city_name length]>2) {
            CGRect new = imageView.frame;
            new.origin.x = 120+10*([self.fanweApp.city_name length] - 2);
            imageView.frame = new;
        }else
        {
            CGRect new = imageView.frame;
            new.origin.x = 120;
            imageView.frame = new;
        }
        
//        [btn setTitle:[NSString stringWithFormat:@"团购·%@",self.fanweApp.city_name] forState:UIControlStateNormal];
        nav.titleText = [NSString stringWithFormat:@"团购·%@",self.fanweApp.city_name];
        self.fanweApp.is_refresh_tableview = NO;
        
    }

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


@end
