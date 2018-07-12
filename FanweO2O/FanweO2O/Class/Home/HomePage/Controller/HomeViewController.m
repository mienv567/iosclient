//
//  HomeViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/23.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomNavigationView.h"
#import "CityPositioningViewController.h"
#import "SDCycleScrollView.h"
#import "TopHeaderScrollView.h"
#import "MallViewController.h"
#import "BaseNavigationController.h"
#import "RightLittleButtonOnBottom.h"
#import "CityPositioningViewController.h"
#import "AdvsWebViewController.h"

#import "CustomGoodsTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "RefreshManager.h"
#import "SectionHeaderView.h"
#import "CustomGoodsComTBCell.h"

#import "GroupBuyTBVC.h"
#import "MallIndexsTBCell.h"
#import "CustomGoodsModel.h"
#import "MallIndexModel.h"
#import "BannerModel.h"
#import "HeadLineModel.h"
#import "BannerContContainerTBCell.h"
#import "FWHeadLineTBCell.h"
#import "HomeZtCell.h"
#import "HeadLineModel.h"
#import "FWHeadLineTBCell.h"
#import "FWO2OJump.h"
#import "RecommendModel.h"
#import "FWO2OJumpModel.h"

#import "LKDBHelper.h"

#import "O2OHomeMainModel.h"
#import "HomeWKZtCell.h"
#import "GlobalVariables.h"
#import "O2OAccountLoginVC.h"

#import <UShareUI/UShareUI.h>

#import <WebKit/WebKit.h>

#import "NSDictionary+BlocksKit.h"
#import "SearchViewController.h"
//暂时使用.....
#import "SetViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoveryViewController.h"

#import "NTalkerChatViewController.h"
#import "XNGoodsInfoModel.h"
#import "HWScanViewController.h"
#import "LogInViewController.h"
#import "StoreWebViewController.h"


#define KHomeArticleCellSection         2   //头条位置
#define KHomeAdvsCellSection            0   //广告位置
#define KHomeAdvs2CellSection           5
#define KHomeIndexsCellSection          1   //菜单列表位置
#define KHomeZt_htm3CellSection         3   //专题1
#define KHomeZt_htm6CellSection         4   //专题1
#define KHomeZt_htm5CellSection         6   //专题1
#define KHomeZt_htm4CellSection         7   //专题1
#define KHomeDeal_listCellSection       9   //店家推荐
#define KHomeSupplier_listCellSection   8   //猜你喜欢
#define KHomeCate_listCellSection       10
#define KHomeEvent_listCellSection      11  //活动列表
#define KHomeYouhui_listCellSection     11  //优惠列表

#define KHomeSectons                    10   //Section的个数



@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,CustomNavigationViewDelegate,SDCycleScrollViewDelegate,RightLittleButtonOnBottomDelegate,MallIndexsTBCellDelegate,HomeZtCellDelegate,BannerContContainerDelegate,CustomGoodsTBCellDelegate,CityPositioningViewControllerDelegate,FWHeadLineTBCellDelegate,HomeWKZtCellDelegate>



{
    CustomNavigationView                *_customView;
    TopHeaderScrollView                 *_headerAdvsView;
    RightLittleButtonOnBottom           *_rightLittleButtonOnBottom;
    CityPositioningViewController       *m;
    GlobalVariables                     *_fanweApp;
    O2OHomeMainModel                    *mainModel;
    
}
@property (strong,nonatomic)NSArray *netImages;  //网络图片

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //清空表数据  clear table data
    //[LKDBHelper clearTableData:[O2OHomeMainModel class]];
    _fanweApp =[GlobalVariables sharedInstance];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.sectionHeaderHeight = 1;
    self.tableView.sectionFooterHeight = 0;
    self.fd_prefersNavigationBarHidden = YES;
    if (self.fanweApp.city_name) {
//        [_customView.leftButton setTitle:self.fanweApp.city_name forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDefaultCity) name:FW_O2O_CITY_DEFAULT_SELECT_MSG object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtableView) name:FW_O2O_MYWEBVIEW_CHANGE_CITY object:nil];
    
}
- (void)refreshtableView
{
//    [_customView.leftButton setTitle:self.fanweApp.city_name forState:UIControlStateNormal];
    [self updateNewData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

//    [_customView.leftButton setTitle:self.fanweApp.city_name forState:UIControlStateNormal];
    
    [self iconData];
    self.tabBarController.tabBar.hidden = NO;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    HideIndicatorInView(self.view);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)handerData {
    
    [super handerData];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(-20);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    _customView = [CustomNavigationView EditNibFromXib];
    _customView.delegate =self;
    [self.view addSubview:_customView];
    [_customView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_offset(64);
        
    }];
    
    //设置返回顶部按钮
    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
    _rightLittleButtonOnBottom.delegate = self;
    _rightLittleButtonOnBottom.hidden = YES;
    _rightLittleButtonOnBottom.kind =0;
    [self.view addSubview:_rightLittleButtonOnBottom];
    
    m =[[CityPositioningViewController alloc] init];
    m.delegate =self;
    m.view.frame =CGRectMake(0, 0, kScreenW, -kScreenH);
    [self.view addSubview:m.view];
    

}
- (void)iconData
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"index" forKey:@"ctl"];
    [parameters setValue:@"wap" forKey:@"act"];
    
   [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
         mainModel = [O2OHomeMainModel mj_objectWithKeyValues:responseJson];
       if (mainModel !=nil) {
           _customView.model =mainModel;
       }
   } FailureBlock:^(NSError *error) {
       
   }];
}
#pragma mark 网络请求

- (void)updateNewData {
    
    self.page = 2;
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"index" forKey:@"ctl"];
    [parameters setValue:@"wap" forKey:@"act"];
    
    
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        UIView *bgView = [self.view viewWithTag:123456];
        if (bgView) {
            HideIndicatorInView(self.view);
            [bgView removeFromSuperview];
            
        }
        
        mainModel = [O2OHomeMainModel mj_objectWithKeyValues:responseJson];
        mainModel.rowid = 1;
        [mainModel saveToDB];
        if (mainModel !=nil) {
             _customView.model =mainModel;
        }
        [self.tableView.mj_header endRefreshing];
        
        self.city_id = responseJson[@"city_id"];
        
        self.city_name = responseJson[@"city_name"];
        
        self.indexsArray = [MallIndexModel mj_objectArrayWithKeyValuesArray:responseJson[@"indexs"][@"list"]];
        
        self.advArray = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs"]];
        
        //_banner2Array = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs2"]];
        
        self.is_banner_square = [responseJson[@"is_banner_square"] integerValue];
        
        //猜你喜欢
        self.dealListArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        
        //商家推荐
        self.supplierListArray = [RecommendModel mj_objectArrayWithKeyValuesArray:responseJson[@"supplier_list"]];
        
        //头条
        self.articleArray = [HeadLineModel mj_objectArrayWithKeyValuesArray:responseJson[@"article"]];
        
        //专题推荐
        self.zt3Html = [responseJson toString:@"zt_html3"];
        
        self.zt4Html = [responseJson toString:@"zt_html4"];
        self.zt5Html = [responseJson toString:@"zt_html5"];
        self.zt6Html = [responseJson toString:@"zt_html6"];
        
        self.zt3_isWebViewDidFinishLoad = NO;
        self.zt4_isWebViewDidFinishLoad = NO;
        self.zt5_isWebViewDidFinishLoad = NO;
        self.zt6_isWebViewDidFinishLoad = NO;
        
        /*
        [self deleteWebCache];
        
        self.myZt5Height = 0;
        self.myZt3Height = 0;
        
        self.myZt4Height = 0;
        self.myZt6Height = 0;
        */
        
        //广告2
        self.adv2Array = [BannerModel mj_objectArrayWithKeyValuesArray:responseJson[@"advs2"]];
        
        
        [self.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        [self noNetWorkHander];
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)updateMoreData {
    //ctl=shop&act=load_index_list_data
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"index" forKey:@"ctl"];
    [parameters setValue:@"load_index_list_data" forKey:@"act"];
    [parameters setValue:@(self.page ++) forKey:@"page"];
    //__weak MallViewController *weakSelf = self;
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_footer endRefreshing];
        
        NSArray *array = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"deal_list"]];
        [self.dealListArray addObjectsFromArray:array];
        if ([responseJson[@"page_total"] integerValue] <= self.page) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        
        
    } FailureBlock:^(NSError *error) {
        
        self.page --;
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    AdvsWebViewController *advsWeb =[[AdvsWebViewController alloc] init];
    [self.navigationController pushViewController:advsWeb animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KHomeSectons;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KHomeAdvsCellSection) {
        
        return self.advArray.count == 0 ? 0 : 1;
        
    }else if (section == KHomeIndexsCellSection){
        
        return self.indexsArray.count == 0 ? 0 : 1;
        
    }else if (section == KHomeArticleCellSection) {
        
        return self.articleArray.count == 0 ? 0 : 1;
        
    }else if (section == KHomeZt_htm3CellSection) {
        
        if ([self.zt3Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KHomeZt_htm4CellSection) {
        
        if ([self.zt4Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KHomeZt_htm5CellSection) {
        
        if ([self.zt5Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KHomeZt_htm6CellSection) {
        
        if ([self.zt6Html length]) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == KHomeSupplier_listCellSection ) {
        
        return self.supplierListArray.count == 0 ? 0 : 1;

    }else if (section == KHomeDeal_listCellSection) {
        
        return ceil(self.dealListArray.count/2.0);
        
    }else if (section == KHomeAdvs2CellSection) {
        return self.adv2Array.count == 0 ? 0 : 1;
    }
    
    return 1;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == KHomeDeal_listCellSection) {
        return self.dealListArray.count == 0 ? 0.001f : FW_SECTION_HEADEVIEW_HIGHT;
    } else if (section == KHomeSupplier_listCellSection) {
        return self.supplierListArray.count == 0 ? 0.001f : 10.0f;
    } else if (section == KHomeZt_htm3CellSection) {
//        return 0;
        return [self.zt4Html length] > 0 ? 10.0f : 0.001f;
    } else if (section == KHomeZt_htm4CellSection) {
        return [self.zt4Html length] > 0 ? 10.0f : 0.001f;
    } else if (section == KHomeZt_htm5CellSection) {
        return [self.zt5Html length] > 0 ? 10.0f : 0.001f;
    } else if (section == KHomeZt_htm6CellSection) {
        return [self.zt6Html length] > 0 ? 10.0f : 0.001f;
    } else if (section == KHomeAdvs2CellSection) {
        return 0;
    } else if (section == KHomeArticleCellSection){
        return self.articleArray.count > 0 ? 3.0f : 0.001f;
    } else if (section == KHomeIndexsCellSection) {
        return 0;
    }
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == KHomeAdvsCellSection) {
        
        return FW_O2O_BANNER_BIG_HIGHT;
        
    }else if (indexPath.section == KHomeIndexsCellSection) {
        
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == KHomeArticleCellSection) {
        
        return FW_HEADELINE_HIGHT;
        
    }else if(indexPath.section == KHomeZt_htm3CellSection) {
//        return 0;
        if ([_count1 intValue] !=0) {
            return [_count1 intValue];
        }
        return UITableViewAutomaticDimension;
    }else if(indexPath.section == KHomeZt_htm4CellSection) {
        return 0;
//        if ([_count2 intValue] !=0) {
//            return [_count2 intValue];
//        }
    }else if(indexPath.section == KHomeZt_htm5CellSection) {
        if ([_count3 intValue] !=0) {
            return [_count3 intValue];
        }
    } else if(indexPath.section == KHomeZt_htm6CellSection) {
        if ([_count4 intValue] !=0) {
            return [_count4 intValue];
        }
    } else if (indexPath.section == KHomeAdvs2CellSection) {
        return 0;
    } else if (indexPath.section == KHomeSupplier_listCellSection) {
        
        return FW_RECOMMEND_HIGHT;
    }
    
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//        if (section == KHomeSupplier_listCellSection && _supplierListArray.count > 0) {
//
//            SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FW_SECTION_HEADEVIEW_HIGHT) imageName:@"group" titleName:@"团购推荐"];
//            [view setBackgroundColor:kBackGroundColor];
//            return view;
//        }
    
    if (section == KHomeDeal_listCellSection && self.dealListArray.count > 0) {
        
        SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FW_SECTION_HEADEVIEW_HIGHT) imageName:@"guess" titleName:@"商品推荐"];
        [view setBackgroundColor:[UIColor whiteColor]];
        return view;
    } else {
        UIView *view = [UIView new];
        [view setBackgroundColor:kBackGroundColor];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (KHomeSectons - 1 == section) {
//        return 10.0f;
//    }
    return 0.001f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
    
    //广告栏
    if (indexPath.section == KHomeAdvsCellSection) {
        BannerContContainerTBCell *cell = [BannerContContainerTBCell cellWithTableView:tableView isSquare:self.is_banner_square];
        cell.delegate = self;
        cell.bannerArray = self.advArray;
        
        return cell;
    } else if (indexPath.section == KHomeAdvs2CellSection) {
//        static NSString *cellIndent =  @"KHomeAdvs2CellSection";
//        BannerContContainerTBCell *cell = [BannerContContainerTBCell cellWithTableView:tableView reuseIdentifier:cellIndent];
//        cell.delegate =self;
//        cell.bannerArray = self.adv2Array;
//        return cell;
    } else if (indexPath.section == KHomeIndexsCellSection) {
        MallIndexsTBCell *cell = [MallIndexsTBCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.indexsArray = self.indexsArray;
        return cell;
    } else if (indexPath.section == KHomeArticleCellSection) {
        
        FWHeadLineTBCell *cell = [FWHeadLineTBCell cellWithTbaleview:tableView];
        cell.delegate =self;
        cell.headLineArray = self.articleArray;
        
        return cell;
    }else if (indexPath.section == KHomeSupplier_listCellSection) {
        
        RecommendTableViewCell *cell = [RecommendTableViewCell cellWithTableView:tableView];
        cell.dataArray = self.supplierListArray;

        return cell;

    } else if (indexPath.section == KHomeZt_htm3CellSection) {
        
        static NSString *cellIndent3 =  @"KGroupZt_htm3CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent3] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KHomeZt_htm3CellSection];
//        NSLog(@"-------------+++++++++++%@",[self createHTML:self.zt3Html])   ;
        [cell setCellContent:self.zt3Html isWebViewDidFinishLoad:self.zt3_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KHomeZt_htm4CellSection) {
        
//        static NSString *cellIndent4 =  @"KGroupZt_htm4CellSection";
//        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent4] ;
//
//        cell.delegate =  self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
//        cell.backgroundColor = kBackGroundColor;
//        [cell setTableViewTag:KHomeZt_htm4CellSection];
//
//        [cell setCellContent:self.zt4Html isWebViewDidFinishLoad:self.zt4_isWebViewDidFinishLoad];
//        return cell;
    }else if (indexPath.section == KHomeZt_htm5CellSection) {
        static NSString *cellIndent5 =  @"KGroupZt_htm5CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent5] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KHomeZt_htm5CellSection];
        [cell setCellContent:self.zt5Html isWebViewDidFinishLoad:self.zt5_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KHomeZt_htm6CellSection) {
        static NSString *cellIndent6 =  @"KGroupZt_htm6CellSection";
        HomeZtCell *cell = [HomeZtCell cellWithTableView:tableView cellIndent:cellIndent6] ;
        cell.delegate =  self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell被选中后的颜色不变
        cell.backgroundColor = kBackGroundColor;
        [cell setTableViewTag:KHomeZt_htm6CellSection];
        [cell setCellContent:self.zt6Html isWebViewDidFinishLoad:self.zt6_isWebViewDidFinishLoad];
        return cell;
    }else if (indexPath.section == KHomeDeal_listCellSection) {  //商品推荐
        CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
        cell.delegate = self;
        [cell upDataWith:self.dealListArray indexPath:indexPath];
        return cell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 0) {
        _customView.backgroundColor =RGBA(0, 0, 0, 0.3);
        _customView.rightButton.backgroundColor =[UIColor colorWithRed:230/255.0 green:229/255.0 blue:227/255.0 alpha:0.8];
    } else {
        CGFloat alpha=scrollView.contentOffset.y / 90.0f > 0.3f ? 0.8 : scrollView.contentOffset.y / 90.0f;
        _customView.backgroundColor =[UIColor colorWithPatternImage:[self getImageWithAlpha:1]];
        if (alpha >0.3) {
            _customView.rightButton.backgroundColor =[UIColor colorWithWhite:1 alpha:1];
        }
    }
    if (scrollView.contentOffset.y > kScreenH) {
        
        _rightLittleButtonOnBottom.hidden =NO;
        
    } else {
        _rightLittleButtonOnBottom.hidden =YES;
    }
}
- (void)backToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    [self.tableView scrollsToTop];
    //    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    //    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color=[UIColor colorWithRed:98/255.0 green:178/255.0 blue:249/255.0 alpha:alpha];
    CGSize colorSize=CGSizeMake(1, 1);
    UIGraphicsBeginImageContext(colorSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark 事件代理

- (void)refreshTableView:(NSString *)myHeight withTag:(NSInteger)Tag{
    
    NSIndexPath *indexPath;
    switch (Tag) {
        case KHomeZt_htm3CellSection:
        {
            self.zt3_isWebViewDidFinishLoad = YES;
            _count1 =myHeight;
            self.myZt3Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KHomeZt_htm3CellSection];
            
        }
            break;
        case KHomeZt_htm4CellSection:
        {
            self.zt4_isWebViewDidFinishLoad = YES;
            _count2 =myHeight;
            self.myZt4Height = [myHeight floatValue];
            
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KHomeZt_htm4CellSection];
            
        }
            break;
        case KHomeZt_htm5CellSection:
        {
            self.zt5_isWebViewDidFinishLoad = YES;
            _count3 =myHeight;
            self.myZt5Height = [myHeight floatValue];
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KHomeZt_htm5CellSection];
            
        }
            break;
        case KHomeZt_htm6CellSection:
        {
            self.zt6_isWebViewDidFinishLoad = YES;
            _count4 =myHeight;
            self.myZt6Height = [myHeight floatValue];
            indexPath = [NSIndexPath indexPathForRow:0 inSection:KHomeZt_htm6CellSection];
            
        }
            break;
        default:
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    //[self.tableView reloadData];
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

- (void)goWebView:(NSString *)url {
    
}

#pragma mark 菜单列表代理
- (void)goNextVC:(MallIndexModel *)model {
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
        
    } else if ([model.ctl isEqualToString:@"user_center"]) {
        
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

- (void)beginRefreshTableView:(float)myHeight isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad {
//    self.zt3_isWebViewDidFinishLoad = isWebViewDidFinishLoad;
//    [self.tableView reloadData];
}
#pragma mark BannerContContainerDelegate

- (void)bannerContContainerGoNextVC:(BannerModel *)model {
//    FWO2OJumpModel *jump = [FWO2OJumpModel new];
//    NSLog(@"%@",model);
//    if ([model.type integerValue]== 0) {
//        jump.type = 0;
//        
//        if (!model.data) {
//            return;
//        }else {
//            if ([model.data.url length] == 0) {
//                return;
//            }
//        }
//        
//        jump.url = model.data.url;
//        jump.isHideNavBar = YES;
//        jump.name = model.name;
//        jump.isHideTabBar = YES;
//
//    }else {
//        
//
//        jump.data_id = model.id;
//        jump.isHideTabBar = YES;
//        jump.isHideNavBar = YES;
//        jump.type = [model.type integerValue];
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

// 点击首页搜索框调用
- (void)goToDiscoveryViewController
{
    DiscoveryViewController *vc = [[DiscoveryViewController alloc] init];
//    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    self.tabBarController.selectedIndex = 1;
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tabBarItemCount"];
//    [[NSUserDefaults standardUserDefaults]setObject:0 forKey:@"tabBarItemCount"];
}

- (void)customGoodGoNextVC:(CustomGoodsModel *)model {
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    jump.type = 0;
    jump.url = model.app_url;
    jump.name = model.brief;
    jump.isHideNavBar = YES;
    jump.isHideTabBar = YES;
    [FWO2OJump didSelect:jump];
}



#pragma mark 获取无网络时候的缓存


- (void)noNetWorkHander {
    
    LKDBHelper* globalHelper = [O2OHomeMainModel getUsingLKDBHelper];
    NSMutableArray *ne = [globalHelper searchWithSQL:@"select * from @t" toClass:[O2OHomeMainModel class]];
    
    if (ne.count != 0) {
        O2OHomeMainModel *model = [ne lastObject];
        self.city_id = model.city_id;
        self.city_name = model.city_name;
        self.articleArray = model.article;
        self.is_banner_square = model.is_banner_square;
        self.advArray = model.advs;
        self.adv2Array = model.advs2;
        self.indexsArray = model.indexs.list;
        self.supplierListArray = model.supplier_list;
        self.dealListArray = model.deal_list;
        self.zt3Html = model.zt_html3;
        self.zt4Html = model.zt_html4;
        self.zt5Html = model.zt_html5;
        self.zt6Html = model.zt_html6;
    }else {
        [self notNwetWork];
    }
    
    
    [self.tableView reloadData];
    
}

#pragma mark 默认城市选择
- (void)selectDefaultCity {
//    [_customView.leftButton setTitle:self.fanweApp.city_name forState:UIControlStateNormal];
}
//选择城市按钮  现在修改为扫码
- (void)customLeftButton
{
    if(_fanweApp.is_set_pass){
        HWScanViewController *vc = [[HWScanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
         [[HUDHelper sharedInstance] tipMessage:@"请先设置支付密码~"];
        NSString *urlstring = [NSString stringWithFormat:@"https://app.yitonggo.com/wap/index.php?ctl=uc_money&act=altPass"];
             StoreWebViewController *vc = [StoreWebViewController webControlerWithUrlString:urlstring andNavTitle:nil isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
 
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
////    [UIView animateWithDuration:0.5 animations:^{
////        m.view.frame =CGRectMake(0, 0, kScreenW, kScreenH);
//////         self.tabBarController.tabBar.hidden =YES;
////    }];
////    [UIView animateWithDuration:0.6 animations:^{
////        //        m.view.frame = CGRectMake(0, 0, kScreenW, -kScreenH);
////        self.tabBarController.tabBar.hidden =YES;
////    }];
//    [UIView animateWithDuration:0.5 animations:^{
//        m.view.frame =CGRectMake(0, 0, kScreenW, kScreenH);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.42 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.tabBarController.tabBar.hidden =YES;
//        });
//
//    } completion:^(BOOL finished) {
//
//    }];
//
//    //[self.navigationController pushViewController:[[MessageCenterViewController alloc] init] animated:YES];

}





//关闭城市按钮
- (void)closeBtn
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:NO];

    [UIView animateWithDuration:0.5 animations:^{
        m.view.frame = CGRectMake(0, 0, kScreenW, -kScreenH);
        self.tabBarController.tabBar.hidden =NO;
    }];

    
    if (self.fanweApp.is_refresh_tableview) {
        
        [self updateNewData];
//        [_customView.leftButton setTitle:self.fanweApp.city_name forState:UIControlStateNormal];
        self.fanweApp.is_refresh_tableview = NO;
    }
}
//更多按钮
- (void)moreButton
{
    

    
    FWO2OJumpModel *model =[FWO2OJumpModel new];
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=notices",
                          API_LOTTERYOUT_URL];
    model.url =urlString;
    model.type = 0;
    model.name = @"方维热点";
    model.isHideTabBar = YES;
    model.isHideNavBar = YES;
    [FWO2OJump didSelect:model];
}

- (void)loginView:(BOOL)islogin
{
    if (islogin ==YES) {
        
//        XNGoodsInfoModel *info = [[XNGoodsInfoModel alloc] init];
//        info.appGoods_type = @"3";
//        //info.clientGoods_Type = @"1";
//        info.goods_id = @"366";
//        info.goods_showURL = @"http://o2owap.fanwe.net/public/attachment/201704/06/11/58e5b0fc74036_800x800.jpg";
//        info.clientGoods_type = @"3";
//        info.goods_imageURL = @"http://o2owap.fanwe.net/public/attachment/201704/06/11/58e5b0fc74036_800x800.jpg";
//        info.goods_URL = @"http://o2owap.fanwe.net/wap/index.php?ctl=deal&data_id=366";
//        info.goodsTitle = @"驿站配送";
//        info.goodsPrice = @"100";
//        info.goods_imageURL = @"http://o2owap.fanwe.net/public/attachment/201704/06/11/58e5b0fc74036_800x800.jpg";
//        
//        
//        NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
//        ctrl.productInfo = info;
//        ctrl.settingid = @"md_198_1496913879749";
//        ctrl.erpParams = @"www.baidu.com";
//        ctrl.kefuId = @"";
//        ctrl.isSingle = @"0";
//        ctrl.pageURLString  = @"";
//        ctrl.pageTitle  = @"";
        //ctrl.pushOrPresent = NO;
        
//        [[AppDelegate sharedAppDelegate] pushViewController:ctrl];
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        //ctrl.pushOrPresent = NO;
        //[self presentViewController:nav animated:YES completion:nil];
       
        
        
        MessageCenterViewController *message =[MessageCenterViewController new];
        message.comeCount=0;
        [self.navigationController pushViewController:message animated:YES];
    }else
    {
       [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:[[LogInViewController alloc] init] animated:YES completion:nil];
    }
}
- (NSString *)createHTML:(NSString *)htmlStr {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<body>"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html\"; charset=\"utf-8\"/>"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">"];
    //    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\"/>",[[NSBundle mainBundle] URLForResource:iPad?@"NewsDetail_iPad.css":@"NewsDetail.css" withExtension:nil]];
    
    // [html appendFormat:@"<style>#content_show img{width:%fpx;margin-bottom:8px;margin-top:8px;display:block}</style>", SCREEN_SIZE.width-(iPad ? 140:30)];
    
    [html appendFormat:@"<div id=\"content_show\" style=\"width:%fpx;text-align:justify;margin-left:auto;margin-right:auto;color:#909090;\">",kScreenW-(30)];
    
    [html appendString:@"</head>"];
    
    [html appendString:htmlStr];
    [html appendString:@"</body>"];
    
    NSString *source = [[NSBundle mainBundle] pathForResource:@"ImgAutoResize" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"320" withString:[NSString stringWithFormat:@"%f", kScreenW-(30)]];
    
    [html appendString:jsString];
    
    [html appendString:@"</html>"];
    
    return html;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 网页清楚缓存

- (void)deleteWebCache {
    
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
        
    {
        
        [storage deleteCookie:cookie];
        
    }
    
    //    清除webView的缓存
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}


#pragma mark 首次无网络加载 

- (void)notNwetWork {
    
    UIView *bgView = [self.view viewWithTag:123456];
    if (bgView) {
        return;
    }
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.tag = 123456;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    UILabel *maxLabel = [[UILabel alloc]init];
    maxLabel.font = [UIFont systemFontOfSize:20];
    maxLabel.textColor = [UIColor darkGrayColor];
    maxLabel.text = @"亲,您的手机网络不太顺畅哦~";
    [bgView addSubview:maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(bgView);
    }];
    
    UIImageView *WIFIImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"o2o_notNetwork_icon"]];
    [bgView addSubview:WIFIImage];
    [WIFIImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.bottom.mas_equalTo(maxLabel.mas_top).offset(-10);
        make.width.height.mas_equalTo(120);
        make.height.height.mas_equalTo(120);
    }];
    
    UILabel *minLabel = [[UILabel alloc]init];
    minLabel.font = [UIFont systemFontOfSize:16];
    minLabel.textColor = [UIColor lightGrayColor];
    minLabel.text = @"请检查您的手机是否联网";
    [bgView addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(maxLabel.mas_bottom).offset(10);
    }];
    
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [starBtn addTarget:self action:@selector(getupdateNewData) forControlEvents:UIControlEventTouchUpInside];
    [starBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [starBtn setBackgroundColor:[UIColor whiteColor]];
    [starBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [starBtn.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [starBtn.layer setBorderWidth:1];
    [starBtn.layer setCornerRadius:5];
    [starBtn.layer setMasksToBounds:YES];
    
    [bgView addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(minLabel.mas_bottom).offset(10);
    }];
}

- (void)getupdateNewData {
    ShowIndicatorTextInView(self.view,@"");
    
    NSNotification * notification = [NSNotification notificationWithName:FW_O2O_INIT_MSG object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self updateNewData];
}


@end
