//
//  ActivityListVC.m
//  FanweO2O
//  活动列表
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ActivityListVC.h"
#import "ActivityListTBVC.h"
#import "LFLUISegmentedControl.h"
#import "ActivityBcateListModel.h"
#import "NSDictionary+Property.h"
#import "SecondaryNavigationBarView.h"
#import "DiscoveryViewController.h"

#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"

#define LFHIGHT     44
@interface ActivityListVC ()<LFLUISegmentedControlDelegate,UIScrollViewDelegate,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) LFLUISegmentedControl * LFLuisement;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *allArray;         //存放数据
@property (nonatomic, strong) NSMutableArray *viewArray;        //存放试图

@end

@implementation ActivityListVC
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackGroundColor;
    
    self.httpManager = [NetHttpsManager manager];
    self.fanweApp = [GlobalVariables sharedInstance];
    
    self.page = 2;
    
    self.allArray = [NSMutableArray new];
    self.viewArray = [NSMutableArray new];
    [self bulidNav];
    [self updateNewData];
    [self popViewController];
    
   
    if (_content !=nil || ![_content isEqualToString:@""]) {
        nav.searchText =_content;
    }
    nav.isTitleOrSearch =NO;
}
- (void)setContent:(NSString *)content
{
    _content =content;
}
- (void)popViewController
{
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
    
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    [self.view addSubview:nav];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    HideIndicatorInView(self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//下拉刷新
- (void)updateNewData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"events" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
      HideIndicatorInView(self.view);
        [self.allArray removeAllObjects];
        self.allArray = [ActivityBcateListModel mj_objectArrayWithKeyValuesArray:responseJson[@"bcate_list"]];
        self.title = responseJson[@"page_title"];
        [self handleData];
        
        //NSLog(@"++++++++++++++++++");
        //[responseJson[@"item"][0] createPropertyCode];
        
    } FailureBlock:^(NSError *error) {
        
        
        HideIndicatorInView(self.view);
    }];

}


- (void)handleData {
    
    NSMutableArray *data = [NSMutableArray new];
    for (ActivityBcateListModel *a in self.allArray ) {
        [data addObject:a.name];
    }
    self.LFLuisement = [LFLUISegmentedControl segmentWithFrame:CGRectMake(0, 64,SCREEN_WIDTH ,LFHIGHT) titleArray:data defaultSelect:0 widthFloat:75];
    self.LFLuisement.delegate = self;
    [self.LFLuisement lineColor:kAppFontColorRed];
    [self.LFLuisement titleColor:kAppFontColorLightGray selectTitleColor:kAppFontColorComblack BackGroundColor:[UIColor whiteColor] titleFontSize:14];
    [self.view addSubview:self.LFLuisement];
    [self.view sendSubviewToBack:self.LFLuisement];
    [self.view addSubview:self.mainScrollView];
    [self.view sendSubviewToBack:self.mainScrollView];
}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5);
    //    滑动SV里视图,切换标题
    [self.LFLuisement selectTheSegument:pageNumber];
}


#pragma mark ---LFLUISegmentedControlDelegate
/**
 *  点击标题按钮
 *
 *  @param selection 对应下标 begain 0
 */
-(void)uisegumentSelectionChange:(NSInteger)selection{
     pageNumber = selection;
    //    加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.2 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH *selection, 0)];
    }];
}

#pragma mark getter

- (UIScrollView *)mainScrollView {
    
    if(_mainScrollView == nil) {
        CGFloat begainScrollViewY = LFHIGHT+64;
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, begainScrollViewY, SCREEN_WIDTH,(SCREEN_HEIGHT - begainScrollViewY))];
        _mainScrollView.backgroundColor = [UIColor cyanColor];
        _mainScrollView.bounces = NO;         _mainScrollView.pagingEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.allArray.count, (SCREEN_HEIGHT - begainScrollViewY));
        //设置代理
        _mainScrollView.delegate = self;
        //添加滚动显示的4个对应的界面view
        [self.viewArray removeAllObjects];
        for (int i = 0; i < self.allArray.count; i++) {
            
            ActivityListTBVC *vc = [ActivityListTBVC new];
            ActivityBcateListModel *bcate = self.allArray[i];
            vc.bcateModel = bcate;
            vc.word =_content;
            vc.view.frame = CGRectMake(SCREEN_WIDTH *i, 0, SCREEN_WIDTH,SCREEN_HEIGHT - LFHIGHT - 64);
            [_mainScrollView addSubview:vc.view];
            if (i == 0) {
                [vc viewWillAppear:YES];
            }
            [self.viewArray addObject:vc];
        }
    }
    
    return _mainScrollView;
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goToDiscovery
{
    [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
}
- (void)popNewView
{
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
    ActivityListTBVC *vc = self.viewArray[pageNumber];
    [vc.tableView.mj_header beginRefreshing];
    
    
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

@end
