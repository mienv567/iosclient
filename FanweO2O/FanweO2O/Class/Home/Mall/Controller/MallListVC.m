//
//  MallListVC.m
//  FanweO2O
//  商品列表
//  Created by hym on 2017/1/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MallListVC.h"
#import "ClassSectionView.h"
#import "ClassSectionModel.h"
#import "MallListClassSectionView.h"
#import "ClassSelcectVC.h"
#import "LMDropdownView.h"
#import "NSDictionary+Property.h"
#import "CustomGoodsTableViewCell.h"
#import "CustomGoodsModel.h"
#import "CustomGoodsComTBCell.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "BrandCustomView.h"

#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "RightLittleButtonOnBottom.h"
#import "UITableView+CNHEmptyDataSet.h"
#define LMD_VIEW_TAG    2001


@interface MallListVC ()<UITableViewDelegate,UITableViewDataSource,MallListClassSectionViewDelegate,ClassSelcectVCDelegate,CustomGoodsTBCellDelegate,LMDropdownViewDelegate,BrandCustomViewDelegate,SecondaryNavigationBarViewDelegate,PopViewDelegate,RightLittleButtonOnBottomDelegate,UIScrollViewDelegate>

{
    PopView *pop;
    RightLittleButtonOnBottom  *_rightLittleButtonOnBottom;
}
@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@property (nonatomic, strong) ClassBcate_list *selectCommon;
@property (nonatomic, strong) ClassBrand_list *selectBrand;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, assign) BOOL hsClass;

@property (nonatomic, strong) NSArray *brandArray;

@property (nonatomic, strong) BrandCustomView *brandVC;

@property (nonatomic, strong) MallListClassSectionView *mallListClassSection;

@end

@implementation MallListVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
    
    
    
    self.order_type = @"";
    
    self.kind =2;
    if (_content !=nil || ![_content isEqualToString:@""]) {
        self.searchText =_content;
    }
    self.judgeNav =NO;
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(104);
    }];
    
    //[self.tableView.mj_header beginRefreshing];
    [self updateNewData];
    
    self.mallListClassSection = [[MallListClassSectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    self.mallListClassSection.delegate = self;
    [self.view addSubview:self.mallListClassSection];
    
    
    //UIView *view
    /*
    if (indexPath.section == 0) {
        
        MallListClassSectionTBCell *cell = [MallListClassSectionTBCell cellWithTableView:tableView];
        
        cell.delegate = self;
        //cell.array = self.sectionArray;
        [cell upDataWith:self.sectionArray hsClass:self.hsClass];
        return cell;
        
    }
    */

    [self popViewController];

}
- (void)setContent:(NSString *)content
{
    _content = content;
}

- (void)popViewController
{
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
    
    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
    _rightLittleButtonOnBottom.delegate = self;
    _rightLittleButtonOnBottom.hidden = YES;
    _rightLittleButtonOnBottom.kind =0;
    [self.view addSubview:_rightLittleButtonOnBottom];
}
- (void)handerData {
    
    [super handerData];
    
    [self doInitSectionArray];
    
    self.dataArray = [NSMutableArray new];

    self.tableView.backgroundColor = kBackGroundColor;
    

    //赋于下拉的里效果视图
    self.dropdownView = [[LMDropdownView alloc] init];
      self.dropdownView.contentBackgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
//    self.dropdownView.contentBackgroundColor = [UIColor purpleColor];
    self.dropdownView.closedScale = 1;
    self.dropdownView.animationDuration = 0.3;
    self.dropdownView.delegate = self;
    self.dropdownView.blackMaskAlpha = 0.1;
    UIView *dropdownView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_HEIGHT, CGRectGetHeight(self.view.frame) - 104)];
    dropdownView.backgroundColor = [UIColor clearColor];
//    dropdownView.backgroundColor = [UIColor redColor];
    dropdownView.tag = LMD_VIEW_TAG;
    
    [self.view addSubview:dropdownView];
    
    [self.view sendSubviewToBack:dropdownView];
    
}

- (void)doInitSectionArray {
    
    ClassSectionModel *model1 = [ClassSectionModel new];
    model1.name = @"全部";
    model1.image = @"o2o_classSection_down_icon";
    model1.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model2 = [ClassSectionModel new];
    model2.name = @"品牌";
    model2.image = @"o2o_classSection_down_icon";
    model2.imageSelect = @"o2o_classSection_up_icon";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeBrand" object:nil userInfo:nil];
    
    ClassSectionModel *model3 = [ClassSectionModel new];
    model3.image = @"o2o_sales_default_icon";
    model3.imageSelect = @"o2o_sales_up_icon";
    model3.name = @"价格";
    model3.hsChange = YES;
    
    ClassSectionModel *model4 = [ClassSectionModel new];
    
    model4.name = @"销量";
    //model4.hsSelect = YES;
    model4.hsChange = YES;
    
    self.sectionArray = [NSMutableArray new];
    
    [self.sectionArray addObjectsFromArray:@[model1,model2,model3,model4]];
  
    
    self.brandArray = nil;
    self.brandVC = nil;
}

- (void)updateNewData {
    
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_footer endRefreshing];
    //self.order_type = @"distance";
    self.order_type = @"";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"goods" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    
    if (self.order_type.length > 0) {
        [parameters setValue:self.order_type forKey:@"order_type"];
    }
    
    if (self.haselect) {
        
        if (self.selectpid && self.selectLevelPid) {
            
            [parameters setValue:@(self.selectLevelPid) forKey:@"cate_id"];
        }else {
            
            [parameters setValue:@(self.selectpid) forKey:@"cate_id"];
        }

        
        
    }
    
    ShowIndicatorTextInView(self.view,@"");

    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        HideIndicatorInView(self.view);
        NSLog(@"================");
        //[responseJson[@"item"][0] createPropertyCode];
        
        [self doInitSectionArray];
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        

        if (self.haselect) {
            
            
            self.haselect = NO;
            BOOL hsFind = NO;
            for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
                if (a.id == self.selectpid ) {
                    self.selectCommon = a;
                    
                    
                    BOOL hsFind1 = NO;
                    for (ClassBcate_type *hsSelectModel in a.bcate_type) {
                        if (hsSelectModel.id == self.selectLevelPid) {
                           self.selectCommon.hsSelectModel = hsSelectModel;
                            ClassSectionModel *model1 = self.sectionArray[0];
                            model1.name = hsSelectModel.name;
                            hsFind1 = YES;
                        }
                        
                    }
                    
                    if (!hsFind1) {
                        self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
                        ClassSectionModel *model1 = self.sectionArray[0];
                        model1.name = self.selectCommon.name;
                    }
                    
                    hsFind = YES;
                    break;
                }
            }
            if (!hsFind) {
                
                
                for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
                    
                    for (ClassBcate_type *hsSelectModel  in a.bcate_type) {
                        if (hsSelectModel.id == self.selectpid) {
                            
                            self.selectCommon = a;
                            
                            
                            self.selectCommon.hsSelectModel = hsSelectModel;
                            ClassSectionModel *model1 = self.sectionArray[0];
                            model1.name = hsSelectModel.name;
                                
                            
                            hsFind = YES;
                            break;
                        }
                    }
                }
                
                
                if (!hsFind) {
                    self.selectCommon = [self.classSectionModel.bcate_list firstObject];
                    self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
                }
            }
            
            self.selectBrand = [self.classSectionModel.brand_list firstObject];
            
            
            
            
            
            
        }else {
            
            self.selectCommon = [self.classSectionModel.bcate_list firstObject];
            self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
            
            self.selectBrand = [self.classSectionModel.brand_list firstObject];
        }

        self.page_total = [responseJson[@"page"][@"page_total"] integerValue];
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];

        
        self.title = responseJson[@"page_title"];
        
        if (self.page >= self.page_total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
        [self.tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArray.count];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)updateMoreData {
    self.page ++;
    [self.tableView.mj_header endRefreshing];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"goods" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:@(self.page) forKey:@"page"];
    
    if (self.order_type.length > 0) {
        [parameters setValue:self.order_type forKey:@"order_type"];
    }
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    //[parameters setValue:self.order_type forKey:@"order_type"];
    //[parameters setValue:@"distance" forKey:@"order_type"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.id) forKey:@"cate_id"];
    
    NSString *bid = @"";
    if (self.brandArray.count != 0) {
        
        for (int i = 0; i < self.brandArray.count; i++) {
            ClassBrand_list *list = self.brandArray[i];
            
            bid = [bid stringByAppendingString:list.id];
            if (i != self.brandArray.count - 1) {
                bid = [bid stringByAppendingString:@","];
            }
        }
        [parameters setValue:bid forKey:@"bid"];
    }
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.tableView.mj_footer endRefreshing];
        
        self.page_total = [responseJson[@"page"][@"page_total"] integerValue];
        
        NSArray *a = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        [self.dataArray addObjectsFromArray:a];
        
        if (self.page >= self.page_total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
        [self.tableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        self.page --;
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    if (self.hsClass) {
        
        return self.dataArray.count;
    }
    
    return ceil(self.dataArray.count/2.0);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#define CLASS_SECTION_TAG   1001

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (self.hsClass) {
    
        CustomGoodsComTBCell *cell = [CustomGoodsComTBCell cellWithTbaleview:tableView];
        
        CustomGoodsModel *model = self.dataArray[indexPath.row];
        cell.count =1;
        cell.goodModel = model;
        
        return cell;
    }
    
    CustomGoodsTableViewCell *cell = [CustomGoodsTableViewCell cellWithTbaleview:tableView];
    
    cell.delegate = self;
    cell.hsShowPrice = YES;
    [cell upDataWith:self.dataArray indexPath:indexPath];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.hsClass) {
        
        CustomGoodsModel *model = self.dataArray[indexPath.row];
        FWO2OJumpModel *fw =[FWO2OJumpModel new];
        fw.type =0;
        fw.url =model.app_url;
        fw.name =model.brief;
        fw.isHideTabBar = YES;
        fw.isHideNavBar = YES;
        [FWO2OJump didSelect:fw];
        
    }
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



#pragma marl MallListClassSectionTBCellDelegate

- (void)MallListClassSectionSelect:(ClassSectionModel *)model {
    
    
    //[self.view addSubview:vc.view];
    
    if (model.tag == 0) {
        
        ClassSelcectVC *vc = [[ClassSelcectVC alloc] initWithNibName:@"ClassSelcectVC" bundle:nil];
        
        vc.view.frame = CGRectMake(0, 64 + 40 , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        
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
                    [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
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
        if (self.classSectionModel != nil) {
        
            if (_brandVC == nil) {
                self.brandVC = [[BrandCustomView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenW, kScreenH-104)];
                self.brandVC.delegate = self;
                self.brandVC.model = self.classSectionModel;
            }
           
            
            if (model.hsSelect) {
                
                if (self.dropdownView.isOpen) {
                    
                    //[self LMDropdownHide];
                    [self.dropdownView hide];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        ClassSectionModel *model1 = self.sectionArray[1];
                        
                        model1.hsSelect = YES;
                        [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
                        [self.tableView reloadData];
                        
                        UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                        
                        [self.view bringSubviewToFront:dropdownView];
                        
                        [self.dropdownView showInView:dropdownView withContentView:self.brandVC atOrigin:CGPointMake(0,0)];
                    });
                    
                }else {
                    
                    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                    
                    [self.view bringSubviewToFront:dropdownView];
                    
                    [self.dropdownView showInView:dropdownView withContentView:self.brandVC atOrigin:CGPointMake(0,0)];
                }
                
                
            }else {
                [self LMDropdownHide];
            }

            
            
        }
    }else if (model.tag == 2) {
        
        
        if ([self.order_type isEqualToString:@"price_asc"]) {
            //价格升序-->价格降序
            self.order_type = @"price_desc";
            model.image = @"o2o_sales_down_icon";
            model.imageSelect = @"o2o_sales_up_icon";
            
        }else if([self.order_type isEqualToString:@"price_desc"]){
            //价格降序-->价格升序
            self.order_type = @"price_asc";
            model.image = @"o2o_sales_up_icon";
            model.imageSelect = @"o2o_sales_down_icon";
        }else {
            //销量-->价格升序
            self.order_type = @"price_asc";
            model.image = @"o2o_sales_up_icon";
            model.imageSelect = @"o2o_sales_down_icon";
        }
        
        model.hsSelect = NO;
        [self.sectionArray replaceObjectAtIndex:2 withObject:model];
        
        
        ClassSectionModel *model3 = self.sectionArray[3];
        model3.hsSelect = NO;
        [self.sectionArray replaceObjectAtIndex:3 withObject:model3];
        [self LMDropdownHide];
        [self updateSelectData];
        
    }else if (model.tag == 3) {
        self.order_type = @"buy_count";
        
        ClassSectionModel *model1 = self.sectionArray[2];
        model1.image = @"o2o_sales_default_icon";
        model1.imageSelect = @"o2o_sales_up_icon";
    
        [self.sectionArray replaceObjectAtIndex:2 withObject:model1];
        
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
        self.brandVC =nil;
        [self.brandVC removeFromSuperview ];
    }else if (classSelectType == ClassSelectArea) {
        
        
    }
    
    [self updateSelectData];
    
    [self LMDropdownHide];
    
}

#pragma mark 选择
- (void)updateSelectData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"goods" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    
    if (self.order_type.length > 0) {
        [parameters setValue:self.order_type forKey:@"order_type"];
    }
    
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    
    //[parameters setValue:self.order_type forKey:@"order_type"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.id
     ) forKey:@"cate_id"];
    

    NSString *bid = @"";
    if (self.brandArray.count != 0) {
        
        for (int i = 0; i < self.brandArray.count; i++) {
            ClassBrand_list *list = self.brandArray[i];
            
            bid = [bid stringByAppendingString:list.id];
            if (i != self.brandArray.count - 1) {
                bid = [bid stringByAppendingString:@","];
            }
        }
        [parameters setValue:bid forKey:@"bid"];
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        NSLog(@"================");
        
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        BOOL hsFind = NO;
        for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
            if (a.id == self.selectCommon.id ) {
                
                
                BOOL hsFind1 = NO;
                for (ClassBcate_type *b in a.bcate_type) {
                    
                    if (b.id == self.selectCommon.hsSelectModel.id) {
                        
                        self.selectCommon = a;
                        self.selectCommon.hsSelectModel = b;
                        
                        if ([b.name isEqualToString:@"全部"]) {
                            ClassSectionModel *model1 = self.sectionArray[0];
                            model1.name = self.selectCommon.name;
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
                    
                }
                
                
                hsFind = YES;
                break;
            }
        }

        self.selectBrand = [self.classSectionModel.brand_list firstObject];
        
      
        
     
        self.page_total = [responseJson[@"page"][@"page_total"] integerValue];
        if (self.page >= self.page_total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        [self.dataArray removeAllObjects];
        
        //NSArray *a = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        self.dataArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        //self.title = responseJson[@"page_title"];
        [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

/*

- (void)updateSelectBrandData:(NSMutableArray *)array;
{
    [self LMDropdownHide];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"goods" forKey:@"ctl"];
    [parameters setValue:@"wap_index" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    NSString *bid = @"";
    if (array.count != 0) {
        
        for (int i = 0; i < array.count; i++) {
            ClassBrand_list *list = array[i];
            
            bid = [bid stringByAppendingString:list.id];
            if (i != array.count - 1) {
                bid = [bid stringByAppendingString:@","];
            }
        }
        
    }
    
    [parameters setValue:bid forKey:@"bid"];
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        [self.dataArray removeAllObjects];
        self.dataArray = [CustomGoodsModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
          [self.tableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
 
 */

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView {
    ClassSectionModel *model1 = self.sectionArray[0];
    
    model1.hsSelect = NO;
    
    ClassSectionModel *model2 = self.sectionArray[1];
    
    model2.hsSelect = NO;
    [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
    
    [self.tableView reloadData];
    
}



- (void)LMDropdownHide {
    
    [self.dropdownView hide];
   
    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
    [self.view sendSubviewToBack:dropdownView];
    
    
    for (UIView *view in self.dropdownView.mainView.subviews) {
        if ([view isKindOfClass:[MallListClassSectionView class]] || [view isKindOfClass:[BrandCustomView class]]) {
            [view removeFromSuperview];
        }
    }
    

}

- (void)MallListClassSection:(BOOL)hsClass {
    
    self.hsClass = hsClass;
    [self.mallListClassSection upDataWith:self.sectionArray hsClass:self.hsClass];
    [self.tableView reloadData];
}

- (void)brand:(NSMutableArray *)brandArray
{
    self.brandArray = brandArray;
    [self LMDropdownHide];
    [self updateSelectData];
}
- (void)goBackBrandView
{
     [self LMDropdownHide];
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
        
        _rightLittleButtonOnBottom.hidden =NO;
        
    }else
    {
        _rightLittleButtonOnBottom.hidden =YES;
    }
}
- (void)backToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
